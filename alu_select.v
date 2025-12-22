`timescale 1ns / 1ps
`default_nettype none
module alu_select (
    input i3,
    input i4,
    input i5,
    // output pg,
    output op0,
    output op1,
    output op2,
    output op3,
    output op4
);
    wire not_i5 = ~i5;
    wire a      = ~(i3 & i4 & not_i5); // NAND3

    assign op0  = i3 ^ i5;
    assign op1  = i4 ^ i5;
    // op2 is true when i5 is set OR when i3&i4&~i5 (matches Logisim truth table)
    assign op2  = i5 | ~a;
    assign op3  = ~a;
    assign op4  = ~(not_i5| i4);
    //assign pg   = i4 | i5;
endmodule
