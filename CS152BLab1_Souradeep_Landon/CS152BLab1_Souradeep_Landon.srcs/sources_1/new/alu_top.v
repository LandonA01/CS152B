`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2026 10:39:17 AM
// Design Name: 
// Module Name: alu_top
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


module alu_top(
        input wire [15:0] A_in, Bin,
        output wire [15:0] alu_out,
        output wire zero, overflow
    );
endmodule



/*𝐴 and 𝐵 are treated as either signed or unsigned integers depending on the opcode. The following opcodes
operate on signed values:
• 0000 subtraction
• 0001 addition
• 0100 decrement
• 0101 increment
• 0110 two's compliment invert
• 1100 arithmetic shift left
• 1110 arithmetic shift right
• 1001 set less than or equal
These opcodes treat 𝐴 and 𝐵 purely as unsigned values:
• 0010 bitwise OR
• 0011 bitwise AND
• 1000 logical shift left
• 1010 logical shift right*/



/*For two-operand functions, 𝐴 is treated as the first operand and 𝐵 is treated as the second operand. For one-
operand functions, the function acts only on 𝐴 and the value of 𝐵 is ignored.
In addition to the output 𝑆, there are two single-bit flags: zero and overflow. The zero flag should be raised if
and only if the output 𝑆 is equal to 16'b0. The overflow flag should be raised in the following conditions:
• Arithmetic overflow and underflow
• Inverting INT_MIN
• When an arithmetic shift changes the sign of the result*/