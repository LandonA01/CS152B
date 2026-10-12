`timescale 1ns / 1ps
//one-bit full adder
module adder(
    input wire A, B, Cin,
    output wire S, Cout
);

    wire ab, ac, bc;
    xor (S, A, B, Cin);
    and (ab, A, B);
    and (ac, A, Cin);
    and (bc, B, Cin);
    or  (Cout, ab, ac, bc);
endmodule

//ripple-carry 16-bit adder built from sixteen full adders
module adder16(
    input wire [15:0] A, B,
    input wire Cin,
    output wire [15:0] S,
    output wire Cout
);

    wire [16:0] carry;
    buf (carry[0], Cin);
    buf (Cout, carry[16]);

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : bits
            adder fa (
                .A(A[i]), .B(B[i]), .Cin(carry[i]),
                .S(S[i]), .Cout(carry[i+1])
            );
        end
    endgenerate
endmodule
