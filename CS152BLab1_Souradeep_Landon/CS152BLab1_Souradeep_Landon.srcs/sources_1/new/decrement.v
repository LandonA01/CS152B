`timescale 1ns / 1ps
module decrement(
    input wire [15:0] A,
    output wire [15:0] A_dec
);
    //adding 16'hFFFF is equivalent to subtracting 1 (source: Google)
    adder16 decrement_adder (
        .A(A), .B(16'hFFFF), .Cin(1'b0),
        .S(A_dec), .Cout()
    );
    
endmodule
