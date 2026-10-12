`timescale 1ns / 1ps
//sel = 1 --> A sel = 0 --> B

module sixteen_bit_mux(
    input wire [15:0] A, B,
    input wire sel,
    output wire [15:0] Y
);
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : bits
            one_bit_mux mux (.a(A[i]), .b(B[i]), .sel(sel), .y(Y[i]));
        end
    endgenerate

    
endmodule
