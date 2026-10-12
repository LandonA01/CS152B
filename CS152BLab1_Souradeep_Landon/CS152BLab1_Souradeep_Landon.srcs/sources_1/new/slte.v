`timescale 1ns / 1ps

module slte(
    input wire [15:0] A, B, D,
    output wire [15:0] A_lte_B
);
    wire different_signs, result_sign_changed, sub_overflow;
    wire negative_after_overflow_correction, equal, less_or_equal;

    xor (different_signs, A[15], B[15]);
    xor (result_sign_changed, A[15], D[15]);
    and (sub_overflow, different_signs, result_sign_changed);
    xor (negative_after_overflow_correction, D[15], sub_overflow);
    nor (equal, D[15], D[14], D[13], D[12],
         D[11], D[10], D[9], D[8], D[7], D[6], D[5],
         D[4], D[3], D[2], D[1], D[0]);
    or  (less_or_equal, negative_after_overflow_correction, equal);
    buf (A_lte_B[0], less_or_equal);

    genvar i;
    generate
        for (i = 1; i < 16; i = i + 1) begin : high_result_bits
            buf (A_lte_B[i], 1'b0); //same as {15'b0, less_or_equal}
        end
    endgenerate


endmodule
