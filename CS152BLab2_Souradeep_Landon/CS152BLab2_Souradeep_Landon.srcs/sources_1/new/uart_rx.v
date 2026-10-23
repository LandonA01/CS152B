`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/19/2026 10:14:28 AM
// Design Name: 
// Module Name: uart_rx
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


module uart_rx #(parameter BAUD_RATE = 9600) (
        input wire clk,
        input wire rst,
        input wire rx_line,
        output reg [7:0] data
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
    
    
    
    //State change 
    always @(posedge clk) begin
        if (rst) state <= IDLE;
        else state <= next_state;
    end
    
    
    //Next-state logic
    
    always @(*) begin
        next_state = IDLE; // default
        case (state) 
            IDLE: begin
                data <= 8'b0;        //performed on reset and new frames
                clk_cnt <= 0;
                data_index <= 0;
                next_state = rx_line ? IDLE : START; //if bit is HIGH, stay. else, go to START
            end
            START: begin
            // need to sample the middle of start here to confirm it is still LOW; else --> IDLE
            // this is --> CLKS_PER_BIT - 1  / 2 cycles
                if (clk_cnt < (CLKS_PER_BIT-1) / 2) begin
                    clk_cnt <= clk_cnt + 1;
                    next_state = START; // stay here unil we make the below check
                end else begin
                    next_state = rx_line ? IDLE : DATA;
                end
            end
            DATA: begin
                if (clk_cnt < CLKS_PER_BIT -1) begin
                    clk_cnt <= clk_cnt + 1;
                end else begin
                    clk_cnt <= 0;
                    data[data_index] <= rx_line;
                    
                    if (data_index < 8) begin
                    data_index <= data_index + 1;
                    end else begin
                    data_index <= 3'b0;
                    next_state = STOP; 
                    end
                end
            end
            STOP: begin
                if (clk_cnt < CLKS_PER_BIT - 1) begin
                clk_cnt <= clk_cnt + 1;
                end else begin
                    clk_cnt <= 0;
                    next_state = IDLE;
                end
            end
        endcase
    end
    

    
  
    
    
    
    
    
    
    
    
    
    
    
endmodule
