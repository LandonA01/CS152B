`timescale 1ns / 1ps

module increment(
    input wire [15:0] A,
    output wire [15:0] A_inc
);
    adder16 increment_adder (
        .A(A), .B(16'h0001), .Cin(1'b0),
        .S(A_inc), .Cout()
    );
    
endmodule
