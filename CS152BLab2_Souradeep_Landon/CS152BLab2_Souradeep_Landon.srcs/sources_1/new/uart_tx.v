`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2026 10:14:28 AM
// Design Name: 
// Module Name: uart_tx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_tx #(parameter BAUD_RATE = 9600)(
    input wire clk,
    input wire rst,
    input wire [7:0] data,
    input wire transmit, //for state transition
    output wire tx_line
    );
    
     //Clocks-per-bit
    localparam CLKS_PER_BIT = 100_000_000 / BAUD_RATE;
    localparam CNT_WIDTH = $clog2(CLKS_PER_BIT);
    
    //Counter to count clocks per bit
    reg [CNT_WIDTH-1:0] clk_cnt;
    
    
    //States
    localparam IDLE = 2'b00;
    localparam START = 2'b01;
    localparam DATA = 2'b10;
    localparam STOP = 2'b11;
    
    
    //State registers
    reg [1:0] state, next_state;
    
    
    //Auxiliary elements
    reg [2:0] data_index; // store data @ corresponding index
    reg tx_line_r; // registered version of tx_line for synchronous update
    
    
    
    //Auxiliary logic management
    always @(posedge clk) begin
        if (rst) begin 
        state <= IDLE;
        clk_cnt <= '0;
        data_index <= '0;
        tx_line_r <= 1'b1;
        end else begin 
            state <= next_state;
            case(state)
                IDLE: begin
                    tx_line_r <= 1'b1; //hold line HIGH when idle
                end
                START: begin
                 if (clk_cnt < CLKS_PER_BIT-1) begin
                    clk_cnt <= clk_cnt + 1;
                    tx_line_r <= 1'b0;                    
                 end  else begin
                    clk_cnt <= '0;
                 end
                end
                DATA: begin
                    if (clk_cnt < CLKS_PER_BIT-1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        tx_line_r <= data[data_index];
                        clk_cnt <= '0;
                        
                        if (data_index < 7) begin
                            data_index <= data_index + 1;
                        end else begin
                            data_index <= 3'b0;
                        end
                    end
                end
                STOP: begin
                    if (clk_cnt < CLKS_PER_BIT-1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= '0;
                        tx_line_r <= 1'b1;
                    end
                end
            endcase
            
        end
    end
    
    always @(*) begin
        next_state = state; //default;
        case(state)
        IDLE: begin 
            next_state = IDLE;
            if (transmit == 1'b1) begin
                next_state = START;
            end  // --> button transitions to START state; send a 0 
        end
        START: begin
        if (clk_cnt < CLKS_PER_BIT-1) begin
            next_state = START;
            end else begin 
                next_state = DATA; 
            end
        end
        DATA: begin
            next_state = DATA;
            if (clk_cnt == CLKS_PER_BIT-1) begin
                if (data_index == 7) begin
                    next_state = STOP;
                end
            end
        end
        STOP: begin
            if (clk_cnt < CLKS_PER_BIT - 1) begin
                next_state = STOP;
            end else begin
                next_state = IDLE;
            end
        end
        endcase
    end
    
    assign tx_line = tx_line_r;
    
    
endmodule
