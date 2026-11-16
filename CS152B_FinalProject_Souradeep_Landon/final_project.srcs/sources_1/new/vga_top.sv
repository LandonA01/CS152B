`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2026 11:32:38 AM
// Design Name: 
// Module Name: vga_top
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


module vga_top(
        input logic clk, rst, button,
        output logic HSync, VSync,
        output logic [3:0] R, G, B
    );
    
    logic clk_div;
    
    
    clk_divider clk_div_1 
    (
        .clk(clk),
        .rst(rst),
        .clk_div(clk_div)
    );
    
   
   vga_controller vga_1 
   (
    .clk_div(clk_div),
    .button(button), 
    .HSync(Hsync),
    .VSync(VSync),
    .R(R),
    .G(G),
    .B(B)
   );
    
    
    
  
endmodule
