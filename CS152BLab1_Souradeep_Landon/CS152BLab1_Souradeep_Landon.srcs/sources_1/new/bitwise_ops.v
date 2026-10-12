`timescale 1ns / 1ps

module bitwise_or(
    input wire [15:0] A, B,
    output wire [15:0] A_or_B
);
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : bits
            or (A_or_B[i], A[i], B[i]);
        end
    endgenerate
    
endmodule
