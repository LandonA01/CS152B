`timescale 1ns / 1ps

module uart_tx #(
    parameter CLOCK_HZ = 100_000_000,
    parameter BAUD_RATE = 9600
) (
    input wire clk,
    input wire rst,
    input wire [7:0] data,
    input wire transmit,
    output wire tx_line
);
    localparam CLKS_PER_BIT = (CLOCK_HZ + BAUD_RATE / 2) / BAUD_RATE;
    localparam CNT_WIDTH = (CLKS_PER_BIT > 1) ? $clog2(CLKS_PER_BIT) : 1;

    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [CNT_WIDTH-1:0] clk_cnt;
    reg [2:0] data_index;
    reg [7:0] data_latched;
    reg tx_line_r;

    assign tx_line = tx_line_r;

    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            clk_cnt <= 0;
            data_index <= 0;
            data_latched <= 0;
            tx_line_r <= 1'b1;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    tx_line_r <= 1'b1;
                    clk_cnt <= 0;
                    data_index <= 0;
                    if (transmit) begin
                        data_latched <= data;
                        tx_line_r <= 1'b0;
                    end
                end

                START: begin
                    if (clk_cnt == CLKS_PER_BIT - 1) begin
                        clk_cnt <= 0;
                        tx_line_r <= data_latched[0];
                    end else begin
                        clk_cnt <= clk_cnt + 1'b1;
                    end
                end

                DATA: begin
                    if (clk_cnt == CLKS_PER_BIT - 1) begin
                        clk_cnt <= 0;
                        if (data_index == 7) begin
                            tx_line_r <= 1'b1;
                        end else begin
                            data_index <= data_index + 1'b1;
                            tx_line_r <= data_latched[data_index + 1'b1];
                        end
                    end else begin
                        clk_cnt <= clk_cnt + 1'b1;
                    end
                end

                STOP: begin
                    if (clk_cnt == CLKS_PER_BIT - 1) begin
                        clk_cnt <= 0;
                    end else begin
                        clk_cnt <= clk_cnt + 1'b1;
                    end
                end

                default: begin
                    clk_cnt <= 0;
                    tx_line_r <= 1'b1;
                end
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: if (transmit) next_state = START;
            START: if (clk_cnt == CLKS_PER_BIT - 1) next_state = DATA;
            DATA: if (clk_cnt == CLKS_PER_BIT - 1 && data_index == 7)
                next_state = STOP;
            STOP: if (clk_cnt == CLKS_PER_BIT - 1 && !transmit)
                next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    
endmodule
