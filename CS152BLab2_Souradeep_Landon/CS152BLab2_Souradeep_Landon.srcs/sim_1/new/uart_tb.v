`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2026 11:34:39 AM
// Design Name: 
// Module Name: uart_tb
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


module uart_tb;

reg clk, rst, transmit;
reg [7:0] data_in, data_out;


    uart_top uart_dut(
        .clk(clk),
        .rst(rst),
        .transmit(traansmit),
        .data_in(data_in),
        .data_out(data_out)
    );


always #5 clk = ~clk;

initial begin
clk = 0;
rst = 0;
transmit = 0;
data_in = 8'b0;



#1;
rst = 1;
#1;
rst = 0;
#1;
data_in = 8'b10011001;
#1;

end


endmodule
