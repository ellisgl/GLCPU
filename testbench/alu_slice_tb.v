`timescale 1ns/1ps

module alu_op_tb;
    reg op0, op1, op2, op3, op4, r, s, c_in;
    wire c_out, o;

    alu_op uut (
        .op0(op0), .op1(op1), .op2(op2), .op3(op3), .op4(op4),
        .r(r), .s(s), .c_in(c_in),
        .c_out(c_out), .o(o)
    );

    reg expected_cout [0:255];
    reg expected_o [0:255];
    integer fd, ret, lineno;
    reg [8*200:0] line; // buffer for fgets
    integer in0, in1, in2, in3, in4, inr, ins, inc;
    integer out0, out1, out2, out3;
    integer idx;
    integer i;
    reg fail;

    initial begin
        // initialize expected arrays to unknown
        for (i = 0; i < 256; i = i + 1) begin
            expected_cout[i] = 1'bx;
            expected_o[i]    = 1'bx;
        end

        fd = $fopen("alu_op_truth_table.txt", "r");
        if (fd == 0) begin
            $display("ERROR: could not open alu_op_truth_table.txt");
            $finish;
        end

        lineno = 0;
        while (!$feof(fd)) begin
            line = "";
            ret = $fgets(line, fd);
            lineno = lineno + 1;
            // skip comments and empty lines
            if (line[8*1 - 1 -:8] == "#") begin
                continue;
            end
            // try to parse a data line
            // Format: op0 op1 op2 op3 op4 r s c_in | pg0 pg1 c_out o  (we ignore pg0/pg1)
            ret = $sscanf(line, "%d %d %d %d %d %d %d %d | %d %d %d %d",
                in0, in1, in2, in3, in4, inr, ins, inc, out0, out1, out2, out3);
            if (ret == 12) begin
                idx = (in0<<7) | (in1<<6) | (in2<<5) | (in3<<4) | (in4<<3) | (inr<<2) | (ins<<1) | (inc<<0);
                // ignore out0/out1 (pg0/pg1); store only c_out and o
                expected_cout[idx] = out2; expected_o[idx] = out3;
            end
        end
        $fclose(fd);

        $display("Loaded truth table; starting tests...");
        $dumpfile("alu_op_tb.vcd");
        $dumpvars(0, alu_op_tb);

        fail = 0;
        $display("i7..i0 | in(op0..c_in) | out(c_out o) | exp | result");

        for (i = 0; i < 256; i = i + 1) begin
            {op0,op1,op2,op3,op4,r,s,c_in} = {i[7], i[6], i[5], i[4], i[3], i[2], i[1], i[0]};
            #1; // settle
            #1;
            if ((c_out !== expected_cout[i]) || (o !== expected_o[i])) begin
                $display("%b | %b%b%b%b%b%b%b%b | %b%b | %b%b | FAIL", i, op0,op1,op2,op3,op4,r,s,c_in, c_out,o, expected_cout[i], expected_o[i]);
                fail = 1;
            end else begin
                $display("%b | %b%b%b%b%b%b%b%b | %b%b | %b%b | PASS", i, op0,op1,op2,op3,op4,r,s,c_in, c_out,o, expected_cout[i], expected_o[i]);
            end
        end

        if (fail) $display("\nTEST RESULT: FAIL"); else $display("\nTEST RESULT: PASS");
        $finish;
    end

endmodule
