`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2026 11:03:25 AM
// Design Name: 
// Module Name: decrement
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


module decrement(
        input wire A, Cin,
        output wire A_dec, Cout
    );
    
    
    subtractor sub_1(
    .A(B),
    .B(1'b1),
    .Cin(Cin),
    .D(A_dec),
    .Cout(Cout)
    );

    
    
    
    
endmodule
