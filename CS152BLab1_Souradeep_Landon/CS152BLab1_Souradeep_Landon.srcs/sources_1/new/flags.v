`timescale 1ns / 1ps

module flags(
    input wire [3:0] ALUCtrl,
    input wire [15:0] A, B,
    input wire [15:0] S, Sum, D, A_asl, A_asr,
    output wire Overflow, Zero
);
    wire n0, n1, n2, n3;
    wire is_sub, is_add, is_dec, is_inc, is_neg, is_asl, is_asr;
    not (n0, ALUCtrl[0]);
    not (n1, ALUCtrl[1]);
    not (n2, ALUCtrl[2]);
    not (n3, ALUCtrl[3]);

    and (is_sub, n3, n2, n1, n0);                 //0000
    and (is_add, n3, n2, n1, ALUCtrl[0]);         //0001
    and (is_dec, n3, ALUCtrl[2], n1, n0);         //0100
    and (is_inc, n3, ALUCtrl[2], n1, ALUCtrl[0]); //0101
    and (is_neg, n3, ALUCtrl[2], ALUCtrl[1], n0); //0110
    and (is_asl, ALUCtrl[3], ALUCtrl[2], n1, n0); //1100
    and (is_asr, ALUCtrl[3], ALUCtrl[2], ALUCtrl[1], n0); //1110

    wire add_same_sign, add_result_changed, overflow_add;
    wire sub_diff_sign, sub_result_changed, overflow_sub;
    xnor (add_same_sign, A[15], B[15]);
    xor  (add_result_changed, A[15], Sum[15]);
    and  (overflow_add, add_same_sign, add_result_changed);
    xor  (sub_diff_sign, A[15], B[15]);
    xor  (sub_result_changed, A[15], D[15]);
    and  (overflow_sub, sub_diff_sign, sub_result_changed);

    wire lower_all_ones, lower_all_zero, sign_is_zero;
    wire overflow_inc, overflow_dec, overflow_neg;
    and (lower_all_ones, A[14], A[13], A[12], A[11],
         A[10], A[9], A[8], A[7], A[6], A[5], A[4],
         A[3], A[2], A[1], A[0]);
    nor (lower_all_zero, A[14], A[13], A[12], A[11],
         A[10], A[9], A[8], A[7], A[6], A[5], A[4],
         A[3], A[2], A[1], A[0]);
    not (sign_is_zero, A[15]);
    and (overflow_inc, sign_is_zero, lower_all_ones); //7FFF + 1
    and (overflow_dec, A[15], lower_all_zero);        //8000 - 1
    and (overflow_neg, A[15], lower_all_zero);        //-8000

    wire overflow_asl, overflow_asr;
    xor (overflow_asl, A[15], A_asl[15]);
    xor (overflow_asr, A[15], A_asr[15]); //0 for valid arithmetic right shifts

    wire active_sub, active_add, active_dec, active_inc;
    wire active_neg, active_asl, active_asr;
    and (active_sub, is_sub, overflow_sub);
    and (active_add, is_add, overflow_add);
    and (active_dec, is_dec, overflow_dec);
    and (active_inc, is_inc, overflow_inc);
    and (active_neg, is_neg, overflow_neg);
    and (active_asl, is_asl, overflow_asl);
    and (active_asr, is_asr, overflow_asr);
    or (Overflow, active_sub, active_add, active_dec, active_inc,
        active_neg, active_asl, active_asr);

    nor (Zero, S[15], S[14], S[13], S[12],
         S[11], S[10], S[9], S[8], S[7], S[6], S[5],
         S[4], S[3], S[2], S[1], S[0]);

         
endmodule
