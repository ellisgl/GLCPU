`timescale 1ns / 1ps
`default_nettype none
module alu (
    input        en,
    input        i3,
    input        i4,
    input        i5,
    input        c_in,
    input [7:0]  r,
    input [7:0]  s,
    output       zero,
    output [7:0] fOut,
    output       c_out,
    output       overflow
);
    wire [7:0] f;
    wire op0;
    wire op1;
    wire op2;
    wire op3;
    wire op4;
    wire c_out0;
    wire c_out1;
    wire c_out2;
    wire c_out3;
    wire c_out4;
    wire c_out5;
    wire c_out6;
    wire c_out7;

    alu_select select (
        .i3(i3),
        .i4(i4),
        .i5(i5),
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
        .r(r[0]),
        .s(s[0]),
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
        .r(r[1]),
        .s(s[1]),
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
        .r(r[2]),
        .s(s[2]),
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
        .r(r[3]),
        .s(s[3]),
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
        .r(r[4]),
        .s(s[4]),
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
        .r(r[5]),
        .s(s[5]),
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
        .r(r[6]),
        .s(s[6]),
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
        .r(r[7]),
        .s(s[7]),
        .c_in(c_out6),
        .c_out(c_out7),
        .o(f[7])
    );

    assign zero     = f[0] & f[1] & f[2] & f[3] & f[4] & f[5] & f[6] & f[7];
    assign c_out    = c_out7;
    assign overflow = c_out6 ^ c_out7;
    assign fOut     = en ? ~f : 8'bzzzzzzz;

endmodule
