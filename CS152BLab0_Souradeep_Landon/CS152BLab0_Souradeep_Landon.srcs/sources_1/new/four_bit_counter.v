`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/28/2026 10:50:44 AM
// Design Name: 
// Module Name: four_bit_counter
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


module four_bit_counter #(parameter CLOCK_DIV_FACTOR = 50_000_000)
(
        input wire clk,
        input wire rst,
        output wire [3:0] count
    );
    
    //4 bit counter
    //overflows to 0 (wraps around) once it hits 15 (max width)
    //resets to 0 on posedge of reset (async)
    //the output  is continously asserted as the current count value
    
   
    
    reg clk_div = 1'b0;
    reg [25:0] clk_div_cnt = 26'd0;
    
    //clock divider
    always @(posedge clk) begin
    if (clk_div_cnt > CLOCK_DIV_FACTOR) begin
        clk_div <= ~clk_div;
         clk_div_cnt  <= 26'd0;
         end
    else
         clk_div_cnt <= clk_div_cnt + 1;
    end
    
    
    
    reg [3:0] count_reg = 4'b0000;
    
    
    always @(posedge clk_div or posedge rst) begin
       if (rst) count_reg <= 4'b0000;
       else begin
            count_reg <= count_reg + 1'b1;
            if (count_reg == 4'b1111) count_reg <= 4'b0000;
       end
    end
    
    
    assign count = count_reg;
    
    
    
   
    


    
endmodule
