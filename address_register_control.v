`timescale 1ns / 1ps
`default_nettype none
module address_register_control (
    input             clk,
    input             n_rst,
    input       [7:0] data,
    input             pcLoad,
    input             pcInc,
    input             arLoad,
    input             arInc,
    input             tlLoad,
    input             thLoad,
    input             sel,
    output reg [15:0] programCounter,
    output reg [15:0] addressRegister
);

    reg   [7:0] tempLow;
    reg   [7:0] tempHigh;
    wire [15:0] addrBus;
    
    localparam resetVector = 16'h0000; // Changes to 16'hFFFE for top down

    always @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            programCounter  <= resetVector;
            addressRegister <= resetVector;
        end else begin
            if (tlLoad) begin
                tempLow <= data;
            end
            
            if (thLoad) begin
                tempHigh <= data;
            end

            if (pcInc) begin
                programCounter <= programCounter + 1;
            end else if (pcLoad) begin
                programCounter <= addrBus;
            end

            if (arInc) begin
                addressRegister <= addressRegister + 1;
            end else if (arLoad) begin
                addressRegister <= addrBus;
            end
        end
    end

    assign addrBus[7:0]  = (sel) ? programCounter[7:0]  : tempLow;
    assign addrBus[15:8] = (sel) ? programCounter[15:8] : tempHigh;
endmodule
