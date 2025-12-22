`timescale 1ns/1ps

// Simple testbench for alu_select
module alu_select_tb;
    reg i3, i4, i5;
    wire op0, op1, op2, op3, op4;

    // Instantiate UUT
    alu_select uut (
        .i3(i3),
        .i4(i4),
        .i5(i5),
        .op0(op0),
        .op1(op1),
        .op2(op2),
        .op3(op3),
        .op4(op4)
    );

    // Expected signals computed in the testbench
    reg exp_op0, exp_op1, exp_op2, exp_op3, exp_op4;
    integer i;
    reg fail;

    initial begin
        $dumpfile("alu_select_tb.vcd");
        $dumpvars(0, alu_select_tb);

        $display("time i3 i4 i5 | op0 op1 op2 op3 op4 | exp_op0 exp_op1 exp_op2 exp_op3 exp_op4 | result");

        fail = 0;

        // Try all 8 combinations of i3,i4,i5
        for (i = 0; i < 8; i = i + 1) begin
            {i3, i4, i5} = i[2:0];
            #5; // wait for outputs to settle

            // expected values from canonical truth table (Logisim export)
            // assign {exp_op0, exp_op1, exp_op2, exp_op3, exp_op4}
            case ({i3,i4,i5})
                3'b000: {exp_op0,exp_op1,exp_op2,exp_op3,exp_op4} = 5'b00000; // from 6'b000000
                3'b001: {exp_op0,exp_op1,exp_op2,exp_op3,exp_op4} = 5'b11101; // from 6'b111011
                3'b010: {exp_op0,exp_op1,exp_op2,exp_op3,exp_op4} = 5'b01000; // from 6'b010001
                3'b011: {exp_op0,exp_op1,exp_op2,exp_op3,exp_op4} = 5'b10100; // from 6'b100011
                3'b100: {exp_op0,exp_op1,exp_op2,exp_op3,exp_op4} = 5'b10000; // from 6'b100000
                3'b101: {exp_op0,exp_op1,exp_op2,exp_op3,exp_op4} = 5'b01101; // from 6'b011011
                3'b110: {exp_op0,exp_op1,exp_op2,exp_op3,exp_op4} = 5'b11110; // from 6'b110111
                3'b111: {exp_op0,exp_op1,exp_op2,exp_op3,exp_op4} = 5'b00100; // from 6'b000011
            endcase

            if ( (op0 !== exp_op0) || (op1 !== exp_op1) || (op2 !== exp_op2) || (op3 !== exp_op3) || (op4 !== exp_op4) ) begin
                $display("%4t  %b  %b  %b |  %b   %b   %b   %b   %b |   %b      %b      %b      %b      %b | FAIL", $time, i3, i4, i5, op0, op1, op2, op3, op4, exp_op0, exp_op1, exp_op2, exp_op3, exp_op4);
                fail = 1;
            end else begin
                $display("%4t  %b  %b  %b |  %b   %b   %b   %b   %b |   %b      %b      %b      %b      %b | PASS", $time, i3, i4, i5, op0, op1, op2, op3, op4, exp_op0, exp_op1, exp_op2, exp_op3, exp_op4);
            end
        end

        if (fail) begin
            $display("\nTEST RESULT: FAIL");
        end else begin
            $display("\nTEST RESULT: PASS");
        end

        #5; $finish;
    end

endmodule
