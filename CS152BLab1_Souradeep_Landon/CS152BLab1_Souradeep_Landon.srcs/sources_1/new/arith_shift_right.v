`timescale 1ns / 1ps

module arith_shift_right(
    input wire [15:0] A, B,
    output wire [15:0] A_shifted
);
    wire [15:0] stage1, stage2, stage4, stage8;
    wire shift_16_or_more;

    sixteen_bit_mux shift1 (
        .A({A[15], A[15:1]}), .B(A), .sel(B[0]), .Y(stage1)
    );
    sixteen_bit_mux shift2 (
        .A({{2{stage1[15]}}, stage1[15:2]}),
        .B(stage1), .sel(B[1]), .Y(stage2)
    );
    sixteen_bit_mux shift4 (
        .A({{4{stage2[15]}}, stage2[15:4]}),
        .B(stage2), .sel(B[2]), .Y(stage4)
    );
    sixteen_bit_mux shift8 (
        .A({{8{stage4[15]}}, stage4[15:8]}),
        .B(stage4), .sel(B[3]), .Y(stage8)
    );

    or (shift_16_or_more,
        B[4], B[5], B[6], B[7], B[8], B[9],
        B[10], B[11], B[12], B[13], B[14], B[15]);
    sixteen_bit_mux shift_big (
        .A({16{A[15]}}), .B(stage8),
        .sel(shift_16_or_more), .Y(A_shifted)
    );
endmodule
