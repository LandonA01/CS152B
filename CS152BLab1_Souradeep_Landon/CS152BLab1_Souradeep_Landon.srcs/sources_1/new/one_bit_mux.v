`timescale 1ns / 1ps

//sel = 1 --> a; sel = 0 --> b
module one_bit_mux(
    input wire a, b, sel,
    output wire y
);
    wire nsel, w0, w1;
    not (nsel, sel);
    and (w0, nsel, b);
    and (w1, sel, a);
    or  (y, w0, w1);
    
endmodule
