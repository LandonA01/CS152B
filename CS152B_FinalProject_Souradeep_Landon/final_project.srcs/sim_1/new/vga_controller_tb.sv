`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2026 11:38:47 AM
// Design Name: 
// Module Name: vga_controller_tb
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


module vga_controller_tb;
   
    
    
    logic clk_div, button;
    logic HSync, VSync;
    
    logic [3:0] R, G ,B;
    logic [9:0] H_count, V_count;
    
    initial begin
    
    //instantiate signals
    clk_div = 0;
    button = 0;
    HSync = 0;
    VSync = 0;
    R = 4'b0000;
    G = 4'b0000;
    B = 4'b0000;
    H_count = 12'd0;
    V_count = 12'd0;
    

    end
    
    
   
    always #5 clk_div = ~clk_div;
   
    
endmodule


//Testbench Goals:
//1. Ensure that HSync and VSync toggle properly
// 2. Ensure that H_count and V_count wrap around properly
