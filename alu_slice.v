`timescale 1ns / 1ps
`default_nettype none
module alu_slice (
    input  op0,
    input  op1,
    input  op2,
    input  op3,
    input  op4,
    input  a,
    input  b,
    input  c_in,
    output c_out,
    output o
);

    // Stage 1:
    //     op0 XOR a
    //     op1 XOR b
    wire op0a = op0 ^ a;
    wire op1b = op1 ^ b;

    // Stage 2:
    //     x0 = op0a NAND op1b
    //     x1 = op0a NOR  op1b
    wire x0   = ~(op0a & op1b);
    wire x1   = ~(op0a | op1b);

    // Stage 3:

    // c_out = a NAND (c_in NAND (NOT b))
    assign c_out = ~(x0 & ~(c_in & ~x1));

    // o = ((a NOR op4) XOR (b NOR op3)) XOR (c_in NOR op2)
    assign o = ((~(x0 | op4)) ^ (~(x1 | op3))) ^ (~(c_in | op2));
endmodule
