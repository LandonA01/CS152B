`timescale 1ns / 1ps

module uart_9600_tb;
    localparam CLOCK_HZ = 100_000_000;
    localparam BAUD_RATE = 9600;
    localparam BIT_CYCLES = (CLOCK_HZ + BAUD_RATE / 2) / BAUD_RATE;

    reg clk = 0;
    reg rst = 1;
    reg transmit = 0;
    reg [7:0] data_in = 8'h69;
    wire tx_line;
    wire [7:0] data_out;

    integer i;
    reg expected_bit;
    integer corner_case_id = 19;
    reg [8*64-1:0] corner_case_name = "BAUD_9600_AT_100_MHZ";

    uart_tx #(
        .CLOCK_HZ(CLOCK_HZ),
        .BAUD_RATE(BAUD_RATE)
    ) tx (
        .clk(clk), .rst(rst), .data(data_in),
        .transmit(transmit), .tx_line(tx_line)
    );

    uart_rx #(
        .CLOCK_HZ(CLOCK_HZ),
        .BAUD_RATE(BAUD_RATE)
    ) rx (
        .clk(clk), .rst(rst), .rx_line(tx_line), .data(data_out)
    );

    always #5 clk = ~clk;

    initial begin
        #2000000;
        $fatal(1, "9600-baud test timed out");
    end

    initial begin
        repeat (5) @(negedge clk);
        rst = 0;
        repeat (5) @(negedge clk);
        transmit = 1;
        @(negedge clk);
        transmit = 0;
    end

    initial begin
        $dumpfile("uart_9600_tb.vcd");
        $dumpvars(0, uart_9600_tb);
        @(negedge tx_line);
        for (i = 0; i < 10; i = i + 1) begin
            repeat (BIT_CYCLES / 2) @(posedge clk);
            #1;
            if (i == 0)
                expected_bit = 0;
            else if (i == 9)
                expected_bit = 1;
            else
                expected_bit = data_in[i - 1];

            if (tx_line !== expected_bit)
                $fatal(1, "9600-baud bit %0d: expected %b, got %b", i, expected_bit, tx_line);

            repeat (BIT_CYCLES - BIT_CYCLES / 2) @(posedge clk);
        end

        repeat (20) @(posedge clk);
        #1;
        if (data_out !== 8'h69)
            $fatal(1, "9600-baud receiver: expected 69, got %h", data_out);

        $display("PASS: 9600 baud at 100 MHz");
        $finish;
    end
endmodule
