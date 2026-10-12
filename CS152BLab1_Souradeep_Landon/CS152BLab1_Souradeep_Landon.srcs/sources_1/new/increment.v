`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2026 11:03:25 AM
// Design Name: 
// Module Name: increment
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


module increment(

    input wire A, Cin,
    output wire A_inc, Cout
    );
    
    
    adder(
        .A(A),
        .B(1'b1),
        .Cin(Cin),
        .S(A_inc),
        .Cout(Cout)
    );
    
endmodule

