module logic_shift_right (
        input wire [15:0] A,
        input wire [15:0] B,
        output wire [15:0] A_shifted 
);

  wire [15:0] shift_right_logic_result1, shift_right_logic_result2, shift_right_logic_result3, shift_right_logic_result4, shift_right_logic_result5;
     
     
     //shift by 1
    sixteen_bit_mux right_logic_shift_1_mux (
        .A({1'd0, A[15:1]}),
        .B(A),
        .sel(B[0]),
        .Y(shift_right_logic_result_1)
    );
    
    //shift by 2
    sixteen_bit_mux right_logic_shift_2_mux (
        .A({2'd0, A[15:2]}),
        .B(shift_right_logic_result_1),
        .sel(B[1]),
        .Y(shift_right_logic_result_2)
    );
    
    
    //shift by 4
    sixteen_bit_mux right_logic_shift_3_mux (
        .A({4'd0, A[15:4]}),
        .B(shift_right_logic_result_2),
        .sel(B[2]),
        .Y(shift_right_logic_result_3)
    );
    
    //shift by 8
    sixteen_bit_mux right_logic_shift_4_mux (
        .A({8'd0, A[15:8]}),
        .B(shift_right_logic_result_3),
        .sel(B[4]),
        .Y(shift_right_logic_result_4)
    );
    
    
    wire b_15_to_5 = |B[15:5];
    
    //shift by 16 or more
    sixteen_bit_mux right_logic_shift_5_mux (
        .A(16'd0),
        .B(shift_right_logic_result_4),
        .sel(b_15_to_5),
        .Y(shift_right_logic_result_5)
    );
    
    assign A_shifted = shift_left_arith_result_5;

endmodule