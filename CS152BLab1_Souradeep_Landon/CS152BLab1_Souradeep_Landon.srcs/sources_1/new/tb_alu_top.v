`timescale 1ns / 1ps

module tb_alu_top;
    reg [15:0] A, B;
    reg [3:0] ALUCtrl;
    wire [15:0] alu_out;
    wire zero, overflow;
    integer test_count, errors, i, j, op;
    reg [15:0] corners [0:19];

    alu_top dut (
        .A_in(A), .Bin(B), .ALUCtrl(ALUCtrl),
        .alu_out(alu_out), .zero(zero), .overflow(overflow)
    );

    task check_case;
        input [3:0] test_op;
        input [15:0] test_a, test_b;
        reg [15:0] expected;
        reg expected_zero, expected_overflow;
        begin
            A = test_a;
            B = test_b;
            ALUCtrl = test_op;

            expected_overflow = 1'b0;
            expected = 16'h0000;
            case (test_op)
                4'h0: begin
                    expected = test_a - test_b;
                    expected_overflow = (test_a[15] != test_b[15]) &&
                                        (test_a[15] != expected[15]);
                end
                4'h1: begin
                    expected = test_a + test_b;
                    expected_overflow = (test_a[15] == test_b[15]) &&
                                        (test_a[15] != expected[15]);
                end
                4'h2: expected = test_a | test_b;
                4'h3: expected = test_a & test_b;
                4'h4: begin
                    expected = test_a - 16'h0001;
                    expected_overflow = (test_a == 16'h8000);
                end
                4'h5: begin
                    expected = test_a + 16'h0001;
                    expected_overflow = (test_a == 16'h7FFF);
                end
                4'h6: begin
                    expected = -test_a;
                    expected_overflow = (test_a == 16'h8000);
                end
                4'h8: expected = test_a << test_b;
                4'h9: expected = ($signed(test_a) <= $signed(test_b)) ?
                                  16'h0001 : 16'h0000;
                4'hA: expected = test_a >> test_b;
                4'hC: begin
                    expected = test_a << test_b;
                    expected_overflow = (test_a[15] != expected[15]);
                end
                4'hE: begin
                    expected = $signed(test_a) >>> test_b;
                    expected_overflow = (test_a[15] != expected[15]);
                end
                default: expected = 16'h0000;  // unused opcodes 7,B,D,F
            endcase
            expected_zero = (expected == 16'h0000);
            #1;
            test_count = test_count + 1;
            if ((alu_out !== expected) ||
                (zero !== expected_zero) ||
                (overflow !== expected_overflow)) begin
                errors = errors + 1;
                $display("FAIL op=%h A=%h B=%h: S=%h Z=%b O=%b, expected S=%h Z=%b O=%b",
                         test_op, test_a, test_b, alu_out, zero, overflow,
                         expected, expected_zero, expected_overflow);
            end
        end
    endtask

    initial begin
        A = 0; B = 0; ALUCtrl = 0;
        test_count = 0; errors = 0;
        $dumpfile("alu_lab1.vcd");
        $dumpvars(0, A, B, ALUCtrl, alu_out, zero, overflow);

        // Sign limits, equal operands, opposite signs, shift magnitudes,
        // and patterns that expose bugs in the staged barrel shifters.
        corners[ 0] = 16'h0000;
        corners[ 1] = 16'h0001;
        corners[ 2] = 16'h0002;
        corners[ 3] = 16'h0003;
        corners[ 4] = 16'h0004;
        corners[ 5] = 16'h0007;
        corners[ 6] = 16'h0008;
        corners[ 7] = 16'h000F;
        corners[ 8] = 16'h0010;
        corners[ 9] = 16'h0011;
        corners[10] = 16'h001F;
        corners[11] = 16'h7FFF;
        corners[12] = 16'h8000;
        corners[13] = 16'h8001;
        corners[14] = 16'hFFFF;
        corners[15] = 16'h5555;
        corners[16] = 16'hAAAA;
        corners[17] = 16'h1234;
        corners[18] = 16'hFEDC;
        corners[19] = 16'h4000;

        for (op = 0; op < 16; op = op + 1) begin
            for (i = 0; i < 20; i = i + 1) begin
                for (j = 0; j < 20; j = j + 1) begin
                    check_case(op, corners[i], corners[j]);
                end
            end
            for (i = 0; i < 300; i = i + 1) begin
                check_case(op, $random, $random);
            end
        end

        if (errors == 0)
            $display("PASS: %0d ALU checks completed, 0 failures.", test_count);
        else
            $display("FAIL: %0d of %0d ALU checks failed.", errors, test_count);
        $finish;
    end
endmodule
