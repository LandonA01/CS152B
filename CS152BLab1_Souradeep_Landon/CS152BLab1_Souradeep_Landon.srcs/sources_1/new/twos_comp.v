`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2026 10:10:23 AM
// Design Name: 
// Module Name: twos_comp
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


module twos_comp(
        input wire B,
        output wire B_twos
    );
    
    wire B_not;
    
    not(B_not, B);
    
    
    adder adder_twos_inst
    (
    .A(1'b1),
    .B(B_not),
    .Cin(1'b0),
    .S(B_twos),
    .Cout(1'b0)
    );
    
endmodule
