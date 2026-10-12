`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2026 10:20:16 AM
// Design Name: 
// Module Name: one_bit_mux
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


module one_bit_mux(
        input wire a,
        input wire b,
        input wire sel,
        output wire  y
    );
    
    wire w0, w1;
    wire nsel;
    
    // select 1 --> A, select 0 --> B
    //~select.... if select 1 --> 0; 0 & anything --> 0
    //OR of two signals
    
    not(nsel, sel);
    and(w0, nsel, b);
    and(w1, sel, b);
    or (y, w0, w1);
    
    
    
endmodule
