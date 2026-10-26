`timescale 1ns / 1ps

module uart_rx #(
    parameter CLOCK_HZ = 100_000_000,
    parameter BAUD_RATE = 9600
) (
    input wire clk,
    input wire rst,
    input wire rx_line,
    output reg [7:0] data
);
    localparam CLKS_PER_BIT = (CLOCK_HZ + BAUD_RATE / 2) / BAUD_RATE;
    localparam CNT_WIDTH = (CLKS_PER_BIT > 1) ? $clog2(CLKS_PER_BIT) : 1;
    localparam HALF_BIT = CLKS_PER_BIT / 2;

    localparam IDLE  = 2'd0;
    localparam START = 2'd1;
    localparam DATA  = 2'd2;
    localparam STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [CNT_WIDTH-1:0] clk_cnt;
    reg [2:0] data_index;

    always @(posedge clk) begin
        if (rst) begin
            data <= 0;
            state <= IDLE;
            clk_cnt <= 0;
            data_index <= 0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    clk_cnt <= 0;
                    data_index <= 0;
                end

                START: begin
                    if (clk_cnt == HALF_BIT - 1) begin
                        clk_cnt <= 0;
                    end else begin
                        clk_cnt <= clk_cnt + 1'b1;
                    end
                end

                DATA: begin
                    if (clk_cnt == CLKS_PER_BIT - 1) begin
                        clk_cnt <= 0;
                        data[data_index] <= rx_line;
                        if (data_index != 7)
                            data_index <= data_index + 1'b1;
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

                default: clk_cnt <= 0;
            endcase
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: if (!rx_line) next_state = START;
            START: if (clk_cnt == HALF_BIT - 1)
                next_state = rx_line ? IDLE : DATA;
            DATA: if (clk_cnt == CLKS_PER_BIT - 1 && data_index == 7)
                next_state = STOP;
            STOP: if (clk_cnt == CLKS_PER_BIT - 1)
                next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end
endmodule
