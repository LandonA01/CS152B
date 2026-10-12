`timescale 1ns / 1ps

module bitwise_and(
    input wire [15:0] A, B,
    output wire [15:0] A_and_B
);
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : bits
            and (A_and_B[i], A[i], B[i]);
        end
    endgenerate
    
endmodule
