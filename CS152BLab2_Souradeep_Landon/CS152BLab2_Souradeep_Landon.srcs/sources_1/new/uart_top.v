`timescale 1ns / 1ps

module uart_top #(
    parameter CLOCK_HZ = 100_000_000,
    parameter BAUD_RATE = 9600
) (
    input wire clk,
    input wire rst,
    input wire transmit,
    input wire [7:0] data_in,
    input wire rx_line,
    output wire tx_line,
    output wire [7:0] data_out
);
    uart_rx #(
        .CLOCK_HZ(CLOCK_HZ),
        .BAUD_RATE(BAUD_RATE)
    ) receiver (
        .clk(clk),
        .rst(rst),
        .rx_line(rx_line),
        .data(data_out)
    );

    uart_tx #(
        .CLOCK_HZ(CLOCK_HZ),
        .BAUD_RATE(BAUD_RATE)
    ) transmitter (
        .clk(clk),
        .rst(rst),
        .data(data_in),
        .transmit(transmit),
        .tx_line(tx_line)
    );
endmodule
