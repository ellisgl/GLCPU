`timescale 1ns / 1ps
`default_nettype none
module alu_slice (
    input op0,
    input op1,
    input op2,
    input op3,
    input op4,
    input r,
    input s,
    input c_in,
    // output pg0,
    // output pg1,
    output c_out,
    output o
);

    // Stage 1:
    //     op0 XOR r
    //     op1 XOR s
    wire op0r = op0 ^ r;
    wire op1s = op1 ^ s;

    // Stage 2:
    //     a = op0r NAND op1s)
    //     b = op0r NOR  op1s)
    wire a    = ~(op0r & op1s);
    wire b    = ~(op0r | op1s);

    // Stage 3:
    // assign pg1 = a;
    // assign pg0 = b;

    // c_out = a NAND (c_in NAND (NOT b))
    assign c_out = ~(a & ~(c_in & ~b));

    // o = ((a NOR op4) XOR (b NOR op3)) XOR (c_in NOR op2)
    assign o = ((~(a | op4)) ^ (~(b | op3))) ^ (~(c_in | op2));

endmodule
