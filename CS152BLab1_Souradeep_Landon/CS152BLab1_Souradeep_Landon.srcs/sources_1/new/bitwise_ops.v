module bitwise_or(
    input wire [15:0] A,
    input wire [15:0] B,
    output wire [15:0] A_or_B
);


or(A_or_B, A, B);





endmodule


//0010 bitwise OR
//0011 bitwise AND