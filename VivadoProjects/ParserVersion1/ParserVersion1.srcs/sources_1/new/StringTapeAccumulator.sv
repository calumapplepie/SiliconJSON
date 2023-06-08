`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2023 05:16:29 PM
// Design Name: 
// Module Name: StringTapeAccumulator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module StringTapeAccumulator(
        input UTF8_Char nextStringByte,
        output TapeIndex curIndex,
        input clk, rst, enable
    );
    typedef logic [31:0] StringLength;
    StringLength strLen,
    // could store just string length instead, but flip-flops are cheap
    TapeIndex startIndex;
    logic wasEnabled;

    logic [7:0] tape [];
    
    initial tape = new [64]

    always @(posedge clk ) begin
        if(rst) begin
            tape.delete();
        end else if (enable) begin
            if(! wasEnabled) begin
                startIndex = curIndex;
                curIndex += 56'd4;;
                wasEnabled = 1'b1;
                strLen = 32'b0;
            end
            strLen++;
            tape[curIndex] = nextStringByte;
            curIndex++;
            
        end else begin
            if(wasEnabled) begin
                tape[startIndex:startIndex+3]=strLen;
                wasEnabled = 1'b0;
            end
        end
    end

    



endmodule
