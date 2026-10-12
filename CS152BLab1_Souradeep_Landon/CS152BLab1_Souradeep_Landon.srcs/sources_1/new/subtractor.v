`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2026 10:09:47 AM
// Design Name: 
// Module Name: subtractor
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


module subtractor(
         input wire A, B, Cin,
         output wire D, Cout
    );
    
    //add, but add A to -B (twos comp B)
    
    wire B_sub;
    
    twos_comp twos_sub_inst(
    .B(B),
    .B_twos(B_sub)
    );
    
    adder adder_sub_inst(
    .A(A),
    .B(B_sub),
    .Cin(1'b0),
    .S(D),
    .Cout(Cout)
    );
    
    //pass B into twos_comp instance
    //pass the result into an adder instance
    
    
    
    /*  //if subtraction,  B is B_sub;
    wire [15:0] B_xor, B_sub;
    xor(B_xor, B, {15{1'b1}};
    //adder these two --> (B_sub, B_xor, 1'b1);
    //10000
    
    //if increment, adder just add 1
    //if decrement, subtractor just sub 1
    
    
    //if two's complement invert, then do the B thing above
    
    
    //arithmetic shift left:
    // 011 shift 1 --> 110
    // 011 shift 2 --> 100
    // remember: it's a tree of muxes
    
    wire [15:0] shift_left_result1, shift_left_result2, shift_left_result3, shift_left_result4, shift_left_result5;
    
    
    //note, B is shamt
    assign shift_left_result1 = B[0] ? {A[14:0], 1'b0} : A;
    assign shift__left_result2 = B[1] ? {A[13:0], 2'b00} : shift_left_result1;
    assign shift_left_result3 = B[2] ? {A[11:0], 4'b0000} : shift_left_result2;
    assign shift_left_result4 = B[4] ? {A[7:0], 8'b00000000} : shift_left_result3;
    assign shift_left_result5 = B[15:5] ? 16'b0 : shift_left_result4;
    
    //the squiggles are due to A and B not being multi-bit in this module
    
    
    
    //arithmetic shift right
    //need to first note the MSB of the original signal --> A[15]
    // as we shift right, copy this MSB over
    
    wire [15:0] shift_right_result1, shift_right_result2, shift_right_result3, shift_right_result4, shift_right_result5;
    
    assign shift_right_result1 = B[0] ? {A[15], A[15:1]} : A;
    assign shift_right_result2 = B[1] ? {{2{A[15]}}, A[15:2]} : shift_right_result1;
    assign shift_right_result3 = B[2] ? {{4{A[15]}}, A[15:4]} : shift_right_result2;
    assign shift_right_result4 = B[4] ? {{8{A[15]}}, A[15:8]} : shift_right_result3;
    assign shift_right_result5 = B[15:5] ? {16{A[15]}} : shift_right_result4;
    
    
    //Set less than or equal (SLTE) A<=B
    
    //A = -5, B = -3  A <B of course
    // -5 -(-3)  --> -2
    // A = -3, B = -5
    // -3 - (-5) --> 2    so, if A < B, A + (-B) is negative. A == B if zero == 1'b1 from this subtraction
    //don't forget about the Overflow case (where we go from super negative --> positive on A); thus SLTE is (Overflow XOR Sign bit) OR Zero
    //We XOR the Overflow and Sign bit because, if both are high, the actually A > B because that means you went from pos --> neg., meaning 
    //smaller number minus bigger negative number --> positive but too positive so it wraps around to negative
    
    
    //111001
    //001001
    */
    
endmodule
