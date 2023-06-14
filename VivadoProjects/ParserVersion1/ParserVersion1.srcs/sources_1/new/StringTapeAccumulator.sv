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


module StringTapeAccumulator
    import Core::UTF8_Char, Core::TapeIndex, Core::StringTapeLength;
    (
        input UTF8_Char nextStringByte,
        output TapeIndex startIndex,
        output logic [7:0] tape [StringTapeLength],
        input clk, rst, enable
    );
    typedef logic [31:0] StringLength;
    StringLength strLen;
    TapeIndex curIndex;
    logic wasEnabled;

    always @(posedge clk ) begin
        if(rst) begin
            foreach(tape[i]) tape[i] = '0;
            curIndex = '0;
            wasEnabled = '0;
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
                // Each string starts with the length of the string, in a 32 byte big-endian integer
                tape[startIndex  ] = {strLen[ 7: 0]};
                tape[startIndex+1] = {strLen[15: 8]};
                tape[startIndex+2] = {strLen[23:16]};
                tape[startIndex+3] = {strLen[31:24]};
                // add null byte
                tape[curIndex] = 8'b0;
                curIndex++;
                wasEnabled = 1'b0;
            end
        end
    end

    



endmodule
