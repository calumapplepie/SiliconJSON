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


module StructureTapeAccumulator 
    import Core::JsonTapeElement, Core::StructTapeLength, Core::TapeIndex; (
        input JsonTapeElement nextTapeEntry,
        input logic [23:0] keyValuePairs,
        output JsonTapeElement tape[StructTapeLength],
        input clk, rst, enable
    );
    TapeIndex curIndex;
    TapeIndex lastBraceIndex;

    always_ff @(posedge clk ) begin
        if (rst) begin
            foreach(tape[i]) tape[i] <= '0;
            curIndex = 56'd1;
        end else if(enable) begin
            tape[curIndex] <= nextTapeEntry;
            
            if(nextTapeEntry[63:56] == "{") lastBraceIndex <= curIndex;
            
            // close brace handler
            else if(nextTapeEntry[63:56] == "}" ) begin
                tape[lastBraceIndex][31:0] <= curIndex;
                tape[lastBraceIndex][55:32] <= keyValuePairs;
                tape[curIndex][55:0] <= lastBraceIndex;
                
                // root handler
                if(1==1)begin
                    // it's always the root for now
                    tape[curIndex+1] <= {"r", 56'b0};
                    tape[0]          <= {"r", curIndex+1};
                end
            end
            curIndex++;
            
        end
    end



endmodule
