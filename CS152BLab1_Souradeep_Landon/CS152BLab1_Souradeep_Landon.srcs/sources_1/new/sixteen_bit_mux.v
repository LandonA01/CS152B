module sixteen_bit_mux (
    input wire [15:0] A,
    input wire [15:0] B,
    input wire sel,
    output wire [15:0] Y
);


genvar i;
generate for (i=0 ; i<16; i=i+1) begin
    one_bit_mux sixteen_bit_inst(
        .a(A[i]),
        .b(B[i]),
        .sel(sel),
        .y(Y[i])
    );
    end
    endgenerate









endmodule