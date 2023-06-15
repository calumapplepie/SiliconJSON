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
        input clk, rst, enable
    );
    
    TapeIndex curIndex;
    TapeIndex lastBraceIndex;
    
    JsonTapeElement curIndexTapeEntry;
    JsonTapeElement lastBraceTapeEntry;
    
    
    
    TapeBlockRam #(.WORDSIZE(64), .NUMWORDS(StructTapeLength)) blockRam  (
            .clk(clk), .ena('1), .enb('1), //always enable
            .wea(enable), .web(doCloseBraceWrite),  
            .addra(curIndex), .addrb(lastBraceIndex),
            .dia(curIndexTapeEntry), .dib(lastBraceTapeEntry));
    
    logic doCloseBraceWrite;
    assign doCloseBraceWrite = (nextTapeEntry[63:56] == "}") && enable;

    
    always_comb begin
        curIndexTapeEntry = nextTapeEntry; 
        
        if(doCloseBraceWrite) begin
            curIndexTapeEntry[55:0] = lastBraceIndex;
        end 
        
        // generate the last brace entry
        lastBraceTapeEntry = '0;
        lastBraceTapeEntry[31:0] = curIndex+1;
        lastBraceTapeEntry[55:32] = keyValuePairs;
        lastBraceTapeEntry[63:56] = "{";
        
        // root handler
        if (lastBraceIndex == 0) begin
            lastBraceTapeEntry[63:56] = "r";
            lastBraceTapeEntry[55:32] = '0;
            curIndexTapeEntry[63:56] = "r";
        end 
    end
    
    always_ff @(posedge clk ) begin
        if (rst) begin
            //foreach(tape[i]) tape[i] <= '0;
            curIndex <= 56'd1;
            lastBraceIndex <= 56'd1;
        end else if(enable) begin            
            if(nextTapeEntry[63:56] == "{") lastBraceIndex <= curIndex;
            
            // close brace handler
            else if(nextTapeEntry[63:56] == "}") begin
                // unconditionally considers this close to be the last close brace
                lastBraceIndex <= 0; // stores after we've already stored the next tape entry
                
            end
            curIndex <= curIndex + 1;
            
        end
    end



endmodule
