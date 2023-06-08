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


module StructureTapeAccumulator(
        input JsonTapeElement nextTapeEntry,
        input clk, rst, enable
    );
    JsonTapeElement tape []
    TapeIndex curIndex;

    // we statically size our array for now
    initial tape = new [32];

    always @(posedge clk ) begin
        if (rst) begin
            tape.delete();
        end else if(enable) begin
            // root handler
            if(nextTapeEntry[56:63] == "r" && curIndex != 0) begin
                // curindex check might want to be replaced with a flag on reset
                tape[0][0:55] = curIndex;
            end
            tape[curIndex] = nextTapeEntry;
            curIndex++;
        end
    end



endmodule
