module flags(
    input wire [3:0]  ALUCtrl,
    input wire [15:0] A, B,
    input wire [15:0] S,          //ALU output
    input wire [15:0] Sum,        //add output
    input wire [15:0] D,          //sub result
    input wire [15:0] B_twos,     //two's result
    input wire [15:0] A_shifted,  //arith shift result
    input wire [15:0] A_inc,      //inc result
    input wire [15:0] A_dec,      //dec result
    output wire Overflow,
    output wire Zero
);

    //decode opcode

    wire is_sub, is_add, is_dec, is_inc;
    wire is_neg, is_asl, is_asr;

    wire n0, n1, n2, n3;

    not (n0, ALUCtrl[0]);
    not (n1, ALUCtrl[1]);
    not (n2, ALUCtrl[2]);
    not (n3, ALUCtrl[3]);

    and (is_sub, n3, n2, n1, n0);                   //0000
    and (is_add, n3, n2, n1, ALUCtrl[0]);            //0001
    and (is_dec, n3, ALUCtrl[2], n1, n0);            //0100
    and (is_inc, n3, ALUCtrl[2], n1, ALUCtrl[0]);    //0101
    and (is_neg, n3, ALUCtrl[2], ALUCtrl[1], n0);    //0110
    and (is_asl, ALUCtrl[3], ALUCtrl[2], n1, n0);    //1100
    and (is_asr, ALUCtrl[3], ALUCtrl[2],
         ALUCtrl[1], n0);                            //1110


    //add overflow

    wire add_same_sign, add_sign_changed;
    wire overflow_add;

    xnor (add_same_sign, A[15], B[15]);
    xor  (add_sign_changed, A[15], Sum[15]);
    and  (overflow_add, add_same_sign, add_sign_changed);


    //sub overflow

    wire sub_different_sign, sub_sign_changed;
    wire overflow_sub;

    xor (sub_different_sign, A[15], B[15]);
    xor (sub_sign_changed, A[15], D[15]);
    and (overflow_sub, sub_different_sign, sub_sign_changed);


    //inc overflow

    wire inc_lower_ones, inc_sign_zero;
    wire overflow_inc;

    not (inc_sign_zero, A[15]);

    and (inc_lower_ones,
         A[14], A[13], A[12], A[11],
         A[10], A[9], A[8], A[7],
         A[6], A[5], A[4], A[3],
         A[2], A[1], A[0]);

    and (overflow_inc, inc_sign_zero, inc_lower_ones);


    //dec underflow

    wire dec_lower_zero;
    wire overflow_dec;

    nor (dec_lower_zero,
         A[14], A[13], A[12], A[11],
         A[10], A[9], A[8], A[7],
         A[6], A[5], A[4], A[3],
         A[2], A[1], A[0]);

    and (overflow_dec, A[15], dec_lower_zero);


    //invert INT_MIN overflow

    wire neg_lower_zero;
    wire invert_int_min;

    nor (neg_lower_zero,
         A[14], A[13], A[12], A[11],
         A[10], A[9], A[8], A[7],
         A[6], A[5], A[4], A[3],
         A[2], A[1], A[0]);

    and (invert_int_min, A[15], neg_lower_zero);


    //artih shift overflow

    wire arith_shift_overflow;

    xor (arith_shift_overflow, A[15], A_shifted[15]);


    //pick overflow signal depending on the current operation

    wire active_add, active_sub;
    wire active_inc, active_dec;
    wire active_neg, active_asl, active_asr;

    and (active_add, is_add, overflow_add);
    and (active_sub, is_sub, overflow_sub);
    and (active_inc, is_inc, overflow_inc);
    and (active_dec, is_dec, overflow_dec);
    and (active_neg, is_neg, invert_int_min);
    and (active_asl, is_asl, arith_shift_overflow);
    and (active_asr, is_asr, arith_shift_overflow);

    or (Overflow,
        active_add,
        active_sub,
        active_inc,
        active_dec,
        active_neg,
        active_asl,
        active_asr);


    //zero flag

    nor (Zero,
         S[15], S[14], S[13], S[12],
         S[11], S[10], S[9], S[8],
         S[7], S[6], S[5], S[4],
         S[3], S[2], S[1], S[0]);

endmodule