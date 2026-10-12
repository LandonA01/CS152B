`timescale 1ns / 1ps

module subtractor(
    input wire [15:0] A, B,
    output wire [15:0] D,
    output wire Cout
);
    wire [15:0] B_inverted;
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : invert_b
            not (B_inverted[i], B[i]);
        end
    endgenerate

    adder16 subtract_adder (
        .A(A), .B(B_inverted), .Cin(1'b1),
        .S(D), .Cout(Cout)
    );


endmodule
