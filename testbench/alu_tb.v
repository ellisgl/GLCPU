`timescale 1ns/1ps
module alu_tb;
    reg en;
    reg i3, i4, i5;
    reg c_in;
    reg [7:0] r, s;

    wire zero;
    wire [7:0] fOut;
    wire c_out;
    wire overflow;

    alu uut (
        .en(en), .i3(i3), .i4(i4), .i5(i5), .c_in(c_in), .r(r), .s(s),
        .zero(zero), .fOut(fOut), .c_out(c_out), .overflow(overflow)
    );

    // reference to internal select signals for convenience
    wire op0 = uut.op0;
    wire op1 = uut.op1;
    wire op2 = uut.op2;
    wire op3 = uut.op3;
    wire op4 = uut.op4;

    reg [7:0] patterns [0:15];
    integer pi, pj, a, b, pass_count, fail_count;

    reg [7:0] f_exp;
    reg c_in_k;
    reg c_out_k;
    reg c_out_prev;
    integer k;
    reg op0r, op1s, a_bit, b_bit, o_bit;
    reg expected_zero;
    reg expected_overflow;
    reg [7:0] expected_fOut;
    reg [7:0] cvec;
    reg op0r2, op1s2, a2, b2, ctmp;

    initial begin
        // patterns (some fixed, some pseudo-random)
        patterns[0] = 8'h00; patterns[1] = 8'hff; patterns[2] = 8'h55; patterns[3] = 8'haa;
        patterns[4] = 8'h01; patterns[5] = 8'h7f; patterns[6] = 8'h80; patterns[7] = 8'h3c;
        for (pi = 8; pi < 16; pi = pi + 1) patterns[pi] = $random;

        $display("Loaded patterns; starting ALU tests...");
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        pass_count = 0; fail_count = 0;

        // iterate op selection, c_in, en, and pattern pairs for r and s
        for (a = 0; a < 8; a = a + 1) begin
            {i3,i4,i5} = a[2:0];
            // allow select logic to settle
            #1;
            for (b = 0; b < 2; b = b + 1) begin
                c_in = b;
                for (en = 0; en < 2; en = en + 1) begin
                    for (pi = 0; pi < 16; pi = pi + 1) begin
                        for (pj = 0; pj < 16; pj = pj + 1) begin
                            r = patterns[pi];
                            s = patterns[pj];
                            #1; // settle
                            // compute expected behavior
                            c_in_k = c_in;
                            c_out_prev = 1'b0;
                            for (k = 0; k < 8; k = k + 1) begin
                                op0r = op0 ^ r[k];
                                op1s = op1 ^ s[k];
                                a_bit = ~(op0r & op1s);
                                b_bit = ~(op0r | op1s);
                                c_out_k = ~(a_bit & ~(c_in_k & ~b_bit));
                                o_bit = ((~(a_bit | op4)) ^ (~(b_bit | op3))) ^ (~(c_in_k | op2));
                                f_exp[k] = o_bit;
                                // advance carry
                                c_in_k = c_out_k;
                                c_out_prev = c_out_k;
                            end
                            expected_zero = &f_exp;
                            // c_out is the carry out of MSB (bit 7)
                            // To get c_out7 and c_out6 for overflow, recompute carries
                            // recompute carries to capture c_out6 and c_out7
                            c_in_k = c_in;
                            for (k = 0; k < 8; k = k + 1) begin
                                op0r2 = op0 ^ r[k];
                                op1s2 = op1 ^ s[k];
                                a2 = ~(op0r2 & op1s2);
                                b2 = ~(op0r2 | op1s2);
                                ctmp = ~(a2 & ~(c_in_k & ~b2));
                                cvec[k] = ctmp;
                                c_in_k = ctmp;
                            end
                            expected_overflow = cvec[6] ^ cvec[7];
                            if (en) expected_fOut = ~f_exp; else expected_fOut = 8'bzzzzzzzz;

                            // compare
                            if ((fOut !== expected_fOut) || (zero !== expected_zero) || (c_out !== cvec[7]) || (overflow !== expected_overflow)) begin
                                $display("FAIL: op=%b c_in=%b en=%b r=%02x s=%02x | fOut=%02x exp=%02x | zero=%b exp=%b | c_out=%b exp=%b | ovf=%b exp=%b",
                                    {i3,i4,i5}, c_in, en, r, s, fOut, expected_fOut, zero, expected_zero, c_out, cvec[7], overflow, expected_overflow);
                                fail_count = fail_count + 1;
                            end else begin
                                pass_count = pass_count + 1;
                            end

                        end
                    end
                end
            end
        end

        $display("ALU tests completed: passed=%0d failed=%0d", pass_count, fail_count);
        if (fail_count) $display("TEST RESULT: FAIL"); else $display("TEST RESULT: PASS");
        $finish;
    end
endmodule
