`timescale 1ns / 1ps

module twos_comp(
    input wire [15:0] B,
    output wire [15:0] B_twos
);
    wire [15:0] B_inverted;
    
    genvar i;

    generate
        for (i = 0; i < 16; i = i + 1) begin : invert_b
            not (B_inverted[i], B[i]);
        end
    endgenerate

    adder16 negate_adder (
        .A(B_inverted), .B(16'h0001), .Cin(1'b0),
        .S(B_twos), .Cout()
    );


endmodule
