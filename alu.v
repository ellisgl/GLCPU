`timescale 1ns / 1ps
`default_nettype none

module alu (
    input        en,
    input        s0,
    input        s1,
    input        s2,
    input        c_in,
    input  [7:0] a,
    input  [7:0] b,
    output       zero,
    output [7:0] fOut,
    output       c_out,
    output       overflow
);
    wire [7:0] f;
    wire       op0;
    wire       op1;
    wire       op2;
    wire       op3;
    wire       op4;
    wire       c_out0;
    wire       c_out1;
    wire       c_out2;
    wire       c_out3;
    wire       c_out4;
    wire       c_out5;
    wire       c_out6;
    wire       c_out7;
  
    // s0 s1 s2 | Function
    // 0  0  0  | a + b + carry in
    // 0  1  0  | b - a - carry in
    // 0  1  1  | a - b - carry in
    // 1  0  0  | a OR b
    // 1  0  1  | a AND b
    // 1  1  0  | a XOR b
    // 1  1  1  | NOT (a XOR b)

    alu_select select (
        .s0(s0),
        .s1(s1),
        .s2(s2),
        .op0(op0),
        .op1(op1),
        .op2(op2),
        .op3(op3),
        .op4(op4)
    );

    alu_slice alu_slice0 (
        .op0(op0),
        .op1(op1),
        .op2(op2),
        .op3(op3),
        .op4(op4),
        .a(a[0]),
        .b(b[0]),
        .c_in(c_in),
        .c_out(c_out0),
        .o(f[0])
    );

    alu_slice alu_slice1 (
        .op0(op0),
        .op1(op1),
        .op2(op2),
        .op3(op3),
        .op4(op4),
        .a(a[1]),
        .b(b[1]),
        .c_in(c_out0),
        .c_out(c_out1),
        .o(f[1])
    );

    alu_slice alu_slice2 (
        .op0(op0),
        .op1(op1),
        .op2(op2),
        .op3(op3),
        .op4(op4),
        .a(a[2]),
        .b(b[2]),
        .c_in(c_out1),
        .c_out(c_out2),
        .o(f[2])
    );

    alu_slice alu_slice3 (
        .op0(op0),
        .op1(op1),
        .op2(op2),
        .op3(op3),
        .op4(op4),
        .a(a[3]),
        .b(b[3]),
        .c_in(c_out2),
        .c_out(c_out3),
        .o(f[3])
    );

    alu_slice alu_slice4 (
        .op0(op0),
        .op1(op1),
        .op2(op2),
        .op3(op3),
        .op4(op4),
        .a(a[4]),
        .b(b[4]),
        .c_in(c_out3),
        .c_out(c_out4),
        .o(f[4])
    );

    alu_slice alu_slice5 (
        .op0(op0),
        .op1(op1),
        .op2(op2),
        .op3(op3),
        .op4(op4),
        .a(a[5]),
        .b(b[5]),
        .c_in(c_out4),
        .c_out(c_out5),
        .o(f[5])
    );

    alu_slice alu_slice6 (
        .op0(op0),
        .op1(op1),
        .op2(op2),
        .op3(op3),
        .op4(op4),
        .a(a[6]),
        .b(b[6]),
        .c_in(c_out5),
        .c_out(c_out6),
        .o(f[6])
    );

    alu_slice alu_slice7 (
        .op0(op0),
        .op1(op1),
        .op2(op2),
        .op3(op3),
        .op4(op4),
        .a(a[7]),
        .b(b[7]),
        .c_in(c_out6),
        .c_out(c_out7),
        .o(f[7])
    );

    assign zero     = f[0] & f[1] & f[2] & f[3] & f[4] & f[5] & f[6] & f[7];
    assign c_out    = c_out7;
    assign overflow = c_out6 ^ c_out7;
    assign fOut     = en ? ~f : 8'bzzzzzzz;

endmodule
