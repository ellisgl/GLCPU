`timescale 1ns / 1ps
`default_nettype none
module alu_select (
    input s0,
    input s1,
    input s2,
    output op0,
    output op1,
    output op2,
    output op3,
    output op4
);
    wire not_s2 = ~s2;
    wire a      = ~(s0 & s1 & not_s2); // NAND3

    assign op0  = s0 ^ s2;
    assign op1  = s1 ^ s2;
    // op2 is true when s2 is set OR when s0&s1&~s2
    assign op2  = s2 | ~a;
    assign op3  = ~a;
    assign op4  = ~(not_s2 | s1);
endmodule
