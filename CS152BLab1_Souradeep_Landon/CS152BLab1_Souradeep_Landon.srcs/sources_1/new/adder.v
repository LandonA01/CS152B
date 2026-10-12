`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2026 10:42:15 AM
// Design Name: 
// Module Name: adder
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


module adder(
        input wire A, B, Cin,
        output wire S, Cout
    );
    
    wire a_and_b, a_and_cin, b_and_cin;
    
    xor(S, A, B, Cin);   
    and(a_and_b, a, b);  
    and(a_and_cin, a, cin); 
    and(b_and_cin, b, cin); 
    or(Cout, a_and_b, a_and_cin, b_and_cin); 
    
    
endmodule
