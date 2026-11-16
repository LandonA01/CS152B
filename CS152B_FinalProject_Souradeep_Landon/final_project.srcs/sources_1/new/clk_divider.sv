`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2026 10:51:08 AM
// Design Name: 
// Module Name: clk_divider
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


module clk_divider(
    input logic clk, rst,
    output logic clk_div
    );
    
    logic [1:0] clk_cnt;
    
    always_ff @(posedge clk) begin
        if (rst) clk_cnt <= '0;
        else begin
            if (clk_cnt == 3)
                clk_cnt <= '0;
            else begin 
                clk_cnt <= clk_cnt + 1;
                clk_div <= ~clk_div;
                end
        end
    end
    
 
    
 
 //Note: can also use Vivado's PLL/Clocking Wizard... --> tradeoffs?
 
 
endmodule


//100 MHz clk --> 25 MHz clk
//every 4 system clocks, toggle divide clock

//0 --> 1 --> 2 --> 3 --> 4