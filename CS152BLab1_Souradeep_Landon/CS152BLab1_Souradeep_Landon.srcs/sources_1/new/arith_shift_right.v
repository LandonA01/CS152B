`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2026 10:11:15 AM
// Design Name: 
// Module Name: arith_shift_right
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module arith_shift_right(
       input wire [15:0] A,
       input wire [15:0] B,
       output wire [15:0] A_shifted 
    );

    
     wire [15:0] shift_right_arith_result1, shift_right_arith_result2, shift_right_arith_result3, shift_right_arith_result4, shift_right_arith_result5;
     
     
     //shift by 1
    sixteen_bit_mux right_arith_shift_1_mux (
        .A({A[15], A[15:1]}),
        .B(A),
        .sel(B[0]),
        .Y(shift_right_arith_result_1)
    );
    
    //shift by 2
    sixteen_bit_mux right_arith_shift_2_mux (
        .A({{2{A[15]}}, A[15:2]}),
        .B(shift_right_arith_result_1),
        .sel(B[1]),
        .Y(shift_right_artih_result_2)
    );
    
    
    //shift by 4
    sixteen_bit_mux right_arith_shift_3_mux (
        .A({{4{A[15]}}, A[15:4]}),
        .B(shift_right_arith_result_2),
        .sel(B[2]),
        .Y(shift_right_arith_result_3)
    );
    
    //shift by 8
    sixteen_bit_mux right_arith_shift_4_mux (
        .A({{8{A[15]}}, A[15:8]}),
        .B(shift_right_arith_result_3),
        .sel(B[4]),
        .Y(shift_right_arith_result_4)
    );
    
    
    wire b_15_to_5 = |B[15:5];
    
    //shift by 16 or more
    sixteen_bit_mux right_arith_shift_5_mux (
        .A({16{A[15]}}),
        .B(shift_right_arith_result_4),
        .sel(b_15_to_5),
        .Y(shift_right_arith_result_5)
    );
    
    assign A_shifted = shift_right_arith_result_5;
    

endmodule
