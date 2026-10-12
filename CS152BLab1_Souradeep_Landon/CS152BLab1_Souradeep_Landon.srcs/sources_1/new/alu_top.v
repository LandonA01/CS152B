`timescale 1ns / 1ps

module alu_top(
    input wire [15:0] A_in, Bin,
    input wire [3:0] ALUCtrl,
    output wire [15:0] alu_out,
    output wire zero, overflow
);

    wire [15:0] op_sub, op_add, op_or, op_and;
    wire [15:0] op_dec, op_inc, op_neg, op_lsl;
    wire [15:0] op_lsr, op_sle, op_asr;
    wire sub_carry_unused, add_carry_unused;

    subtractor sub_unit (.A(A_in), .B(Bin), .D(op_sub), .Cout(sub_carry_unused));
    adder16 add_unit (
        .A(A_in), .B(Bin), .Cin(1'b0),
        .S(op_add), .Cout(add_carry_unused)
    );

    bitwise_or or_unit (.A(A_in), .B(Bin), .A_or_B(op_or));
    bitwise_and and_unit (.A(A_in), .B(Bin), .A_and_B(op_and));
    decrement dec_unit (.A(A_in), .A_dec(op_dec));
    increment inc_unit (.A(A_in), .A_inc(op_inc));
    twos_comp neg_unit (.B(A_in), .B_twos(op_neg));
    arith_or_logic_shift_left lsl_unit (.A(A_in), .B(Bin), .A_shifted(op_lsl));
    logic_shift_right lsr_unit (.A(A_in), .B(Bin), .A_shifted(op_lsr));
    slte sle_unit (.A(A_in), .B(Bin), .D(op_sub), .A_lte_B(op_sle));

    //logical and arithmetic left shifts share the same datapath
    arith_shift_right asr_unit (.A(A_in), .B(Bin), .A_shifted(op_asr));

    //4-bit opcode -> sixteen-way mux tree. unused opcodes output 0
    //stage 0: choose within pairs using ALUCtrl[0]
    wire [15:0] lo0, lo1, lo2, lo3, hi0, hi1, hi2, hi3;
    sixteen_bit_mux m00 (.A(op_add), .B(op_sub),.sel(ALUCtrl[0]), .Y(lo0)); // 0,1
    sixteen_bit_mux m01 (.A(op_and), .B(op_or),.sel(ALUCtrl[0]), .Y(lo1));  // 2,3
    sixteen_bit_mux m02 (.A(op_inc), .B(op_dec),.sel(ALUCtrl[0]), .Y(lo2)); // 4,5
    sixteen_bit_mux m03 (.A(16'h0000),.B(op_neg),.sel(ALUCtrl[0]), .Y(lo3));// 6,7
    sixteen_bit_mux m04 (.A(op_sle), .B(op_lsl),.sel(ALUCtrl[0]), .Y(hi0)); // 8,9
    sixteen_bit_mux m05 (.A(16'h0000),.B(op_lsr),.sel(ALUCtrl[0]), .Y(hi1));// A,B
    sixteen_bit_mux m06 (.A(16'h0000),.B(op_lsl),.sel(ALUCtrl[0]), .Y(hi2));// C,D
    sixteen_bit_mux m07 (.A(16'h0000),.B(op_asr),.sel(ALUCtrl[0]), .Y(hi3));// E,F

    //stage 1: select each group of four using ALUCtrl[1]
    wire [15:0] q0, q1, q2, q3;
    sixteen_bit_mux m10 (.A(lo1), .B(lo0), .sel(ALUCtrl[1]), .Y(q0));
    sixteen_bit_mux m11 (.A(lo3), .B(lo2), .sel(ALUCtrl[1]), .Y(q1));
    sixteen_bit_mux m12 (.A(hi1), .B(hi0), .sel(ALUCtrl[1]), .Y(q2));
    sixteen_bit_mux m13 (.A(hi3), .B(hi2), .sel(ALUCtrl[1]), .Y(q3));

    //stages 2 and 3: choose the final output using ALUCtrl[2:3]
    wire [15:0] half0, half1;
    sixteen_bit_mux m20 (.A(q1), .B(q0), .sel(ALUCtrl[2]), .Y(half0));
    sixteen_bit_mux m21 (.A(q3), .B(q2), .sel(ALUCtrl[2]), .Y(half1));
    sixteen_bit_mux m30 (.A(half1), .B(half0), .sel(ALUCtrl[3]), .Y(alu_out));

    flags flag_unit (
        .ALUCtrl(ALUCtrl), .A(A_in), .B(Bin), .S(alu_out),
        .Sum(op_add), .D(op_sub), .A_asl(op_lsl), .A_asr(op_asr),
        .Overflow(overflow), .Zero(zero)
    );


endmodule
