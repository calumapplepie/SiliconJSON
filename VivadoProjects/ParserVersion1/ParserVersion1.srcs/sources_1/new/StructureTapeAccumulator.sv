`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2023 05:16:29 PM
// Design Name: 
// Module Name: StructureTapeAccumulator
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


module StructureTapeAccumulator (
        input JsonTapeElement nextTapeEntry,
        output JsonTapeElement tape[32],
        input clk, rst, enable
    );
    TapeIndex curIndex;

    always @(posedge clk ) begin
        if (rst) begin
            foreach(tape[i]) tape[i] <= '0;
            curIndex = '0;
        end else if(enable) begin
            // root handler
            if(nextTapeEntry[63:56] == "r" ) begin
                // curindex check might want to be replaced with a flag on reset
                tape[0][55:0] <= curIndex;
            end
            tape[curIndex] <= nextTapeEntry;
            curIndex++;
        end
    end



endmodule
