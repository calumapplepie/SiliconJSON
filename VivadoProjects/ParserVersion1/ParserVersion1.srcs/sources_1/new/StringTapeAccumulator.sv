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
        output logic [7:0] tape [32],
        input clk, rst, enable
    );
    typedef logic [31:0] StringLength;
    StringLength strLen;
    // could store just string length instead, but flip-flops are cheap
    TapeIndex startIndex;
    logic wasEnabled;

    always @(posedge clk ) begin
        if(rst) begin
            foreach(tape[i]) tape[i] = '0;
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
                // this should give it big endian ordering? we will see
                tape[startIndex  ] = {strLen[ 7: 0]};
                tape[startIndex+1] = {strLen[15: 8]};
                tape[startIndex+2] = {strLen[23:16]};
                tape[startIndex+4] = {strLen[31:24]};
                // add null byte
                tape[curIndex] = 8'b0;
                curIndex++;
                wasEnabled = 1'b0;
            end
        end
    end

    



endmodule
