`timescale 1ns / 1ps

module uart_tb;
    localparam CLOCK_HZ = 1000;
    localparam BAUD_RATE = 100;
    localparam BIT_CYCLES = CLOCK_HZ / BAUD_RATE;

    reg clk = 0;
    reg rst = 1;
    reg transmit = 0;
    reg [7:0] data_in = 0;
    reg rx_manual = 1;
    reg loopback = 0;

    wire tx_line;
    wire rx_line = loopback ? tx_line : rx_manual;
    wire [7:0] data_out;

    integer checks = 0;
    integer i;
    integer corner_case_id = 0;
    reg [8*64-1:0] corner_case_name = "INITIAL";

    uart_top #(
        .CLOCK_HZ(CLOCK_HZ),
        .BAUD_RATE(BAUD_RATE)
    ) dut (
        .clk(clk),
        .rst(rst),
        .transmit(transmit),
        .data_in(data_in),
        .rx_line(rx_line),
        .tx_line(tx_line),
        .data_out(data_out)
    );

    always #5 clk = ~clk;

    task mark_case;
        input integer id;
        input [8*64-1:0] name;
        begin
            corner_case_id = id;
            corner_case_name = name;
            $display("CASE %0d: %0s at %0t", id, name, $time);
        end
    endtask

    task wait_clocks;
        input integer count;
        begin
            repeat (count) @(negedge clk);
        end
    endtask

    task check_leds;
        input [7:0] expected;
        begin
            if (data_out !== expected)
                $fatal(1, "LEDs: expected %h, got %h at %0t", expected, data_out, $time);
            checks = checks + 1;
        end
    endtask

    task check_serial_frame;
        input [7:0] expected;
        integer bit_number;
        begin
            @(negedge tx_line);
            wait_clocks(BIT_CYCLES / 2);
            if (tx_line !== 1'b0)
                $fatal(1, "Missing start bit at %0t", $time);
            checks = checks + 1;

            for (bit_number = 0; bit_number < 8; bit_number = bit_number + 1) begin
                wait_clocks(BIT_CYCLES);
                if (tx_line !== expected[bit_number])
                    $fatal(1, "TX bit %0d: expected %b, got %b at %0t",
                           bit_number, expected[bit_number], tx_line, $time);
                checks = checks + 1;
            end

            wait_clocks(BIT_CYCLES);
            if (tx_line !== 1'b1)
                $fatal(1, "Missing stop bit at %0t", $time);
            checks = checks + 1;
        end
    endtask

    task push_send;
        begin
            transmit = 1;
            wait_clocks(8);
            transmit = 0;
            wait_clocks(8);
        end
    endtask

    task receive_frame;
        input [7:0] value;
        input stop_bit;
        integer bit_number;
        begin
            rx_manual = 0;
            wait_clocks(BIT_CYCLES);
            for (bit_number = 0; bit_number < 8; bit_number = bit_number + 1) begin
                rx_manual = value[bit_number];
                wait_clocks(BIT_CYCLES);
                if (data_out[bit_number] !== value[bit_number])
                    $fatal(1, "RX bit %0d: expected %b, got %b",
                           bit_number, value[bit_number], data_out[bit_number]);
                checks = checks + 1;
            end
            rx_manual = stop_bit;
            wait_clocks(BIT_CYCLES);
            rx_manual = 1;
        end
    endtask

    task loopback_frame;
        input [7:0] value;
        begin
            data_in = value;
            fork
                check_serial_frame(value);
                push_send;
            join
            wait_clocks(20);
            check_leds(value);
        end
    endtask

    initial begin
        #200000;
        $fatal(1, "Simulation timed out");
    end

    initial begin
        $dumpfile("uart_tb.vcd");
        $dumpvars(0, uart_tb);

        mark_case(1, "RESET_AND_IDLE");
        wait_clocks(8);
        rst = 0;
        wait_clocks(8);
        check_leds(8'h00);
        if (tx_line !== 1'b1)
            $fatal(1, "TX must be high after reset");
        checks = checks + 1;

        loopback = 1;
        mark_case(2, "NORMAL_FRAME_A5");
        loopback_frame(8'hA5);

        mark_case(3, "ONE_CYCLE_SEND_PULSE");
        fork
            check_serial_frame(8'hA5);
            begin
                transmit = 1;
                wait_clocks(1);
                transmit = 0;
            end
        join
        wait_clocks(20);
        check_leds(8'hA5);

        mark_case(4, "ALL_ZERO_DATA");
        loopback_frame(8'h00);
        mark_case(5, "ALL_ONE_DATA");
        loopback_frame(8'hFF);
        mark_case(6, "EDGE_BITS_81");
        loopback_frame(8'h81);

        mark_case(7, "DATA_CHANGED_DURING_TX");
        data_in = 8'h53;
        fork
            check_serial_frame(8'h53);
            begin
                push_send;
                wait_clocks(BIT_CYCLES * 2);
                data_in = 8'hCA;
            end
        join
        wait_clocks(20);
        check_leds(8'h53);

        mark_case(8, "SEND_BUTTON_HELD");
        data_in = 8'h3C;
        fork
            check_serial_frame(8'h3C);
            begin
                transmit = 1;
                wait_clocks(160);
                transmit = 0;
            end
        join
        check_leds(8'h3C);
        for (i = 0; i < 25; i = i + 1) begin
            wait_clocks(1);
            if (tx_line !== 1'b1)
                $fatal(1, "Held button caused another frame");
        end
        checks = checks + 1;

        mark_case(9, "SEND_REQUEST_WHILE_BUSY");
        data_in = 8'hE7;
        fork
            check_serial_frame(8'hE7);
            begin
                push_send;
                wait_clocks(10);
                push_send;
            end
        join
        wait_clocks(25);
        check_leds(8'hE7);
        for (i = 0; i < 20; i = i + 1) begin
            wait_clocks(1);
            if (tx_line !== 1'b1)
                $fatal(1, "Send request during TX caused an extra frame");
        end
        checks = checks + 1;

        mark_case(10, "RESET_DURING_TX");
        wait_clocks(10);
        data_in = 8'h00;
        push_send;
        wait_clocks(12);
        rst = 1;
        wait_clocks(8);
        rst = 0;
        wait_clocks(8);
        check_leds(8'h00);
        if (tx_line !== 1'b1)
            $fatal(1, "Reset did not stop TX");
        checks = checks + 1;
        wait_clocks(BIT_CYCLES * 12);
        if (tx_line !== 1'b1)
            $fatal(1, "Transmission restarted after reset");
        checks = checks + 1;

        loopback = 0;
        rx_manual = 1;
        wait_clocks(20);
        mark_case(11, "VALID_EXTERNAL_RX");
        receive_frame(8'h96, 1'b1);
        wait_clocks(10);
        check_leds(8'h96);

        mark_case(12, "FALSE_START_GLITCH");
        rx_manual = 0;
        wait_clocks(2);
        rx_manual = 1;
        wait_clocks(BIT_CYCLES * 2);
        check_leds(8'h96);

        mark_case(13, "STOP_BIT_NOT_CHECKED");
        receive_frame(8'h01, 1'b0);
        wait_clocks(15);
        check_leds(8'h01);

        mark_case(14, "EXTENDED_IDLE_HIGH");
        rx_manual = 1;
        wait_clocks(BIT_CYCLES * 12);
        check_leds(8'h01);

        mark_case(15, "NEXT_FRAME_AFTER_IDLE");
        receive_frame(8'h39, 1'b1);
        wait_clocks(10);
        check_leds(8'h39);

        mark_case(16, "BACK_TO_BACK_RX_FRAMES");
        receive_frame(8'h55, 1'b1);
        receive_frame(8'hAA, 1'b1);
        wait_clocks(10);
        check_leds(8'hAA);

        mark_case(17, "RESET_CLEARS_RECEIVED_DATA");
        receive_frame(8'hF0, 1'b1);
        wait_clocks(10);
        check_leds(8'hF0);
        rst = 1;
        wait_clocks(8);
        rst = 0;
        wait_clocks(8);
        check_leds(8'h00);

        mark_case(18, "RESET_DURING_RX");
        rx_manual = 0;
        wait_clocks(BIT_CYCLES * 3);
        rst = 1;
        wait_clocks(8);
        rx_manual = 1;
        rst = 0;
        wait_clocks(BIT_CYCLES * 12);
        check_leds(8'h00);

        $display("PASS: %0d UART checks", checks);
        $finish;
    end
endmodule
