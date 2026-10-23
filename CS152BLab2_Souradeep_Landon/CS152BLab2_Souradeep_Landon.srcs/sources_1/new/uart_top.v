`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2026 11:17:26 AM
// Design Name: 
// Module Name: uart_top
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


module uart_top(
        input wire clk,
        input wire rst,
        input wire transmit,
        input wire [7:0] data_in,
        output wire [7:0] data_out
    );
    
    
    wire uart_line;
    
    
    uart_rx #(.BAUD_RATE(9600)) receiver (
        .clk(clk),
        .rst(rst),
        .rx_line(uart_line),   //connect to tx
        .data(data_out) //LEDs to receive data
    );
    
    uart_tx #(.BAUD_RATE(9600)) transmitter (
    .clk(clk),
    .rst(rst),
    .data(data_in),   //Switches to send data
    .transmit(transmit),
    .tx_line(uart_line)    //connect to rx
    );
    
    
    
    
    
    
    
endmodule
