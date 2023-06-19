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
        input JsonTapeElement nextTapeEntry, numberSecondElement,
        input logic [23:0] keyValuePairs,
        input clk, rst, enable,
        output hash
    );
    
    TapeIndex curIndex;
    TapeIndex lastBraceIndex;
    TapeIndex dualWriteIndex;
    
    JsonTapeElement curIndexTapeEntry;
    JsonTapeElement lastBraceTapeEntry;
    JsonTapeElement dualWriteTapeEntry;
    
    logic doCloseBraceWrite, doNumberWrite, doDualWrite;
    
    TapeBlockRam #(.WORDSIZE(64), .NUMWORDS(StructTapeLength)) blockRam  (
            .clk(clk), .ena('1), .enb('1), //always enable
            .wea(enable),            .web(doDualWrite),  
            .addra(curIndex),        .addrb(dualWriteIndex),
            .dia(curIndexTapeEntry), .dib(dualWriteTapeEntry), .hash(hash));
    
    assign doCloseBraceWrite = nextTapeEntry[63:56] == "}";
    assign doNumberWrite     = nextTapeEntry[63:56] inside {"l", "d", "u"}; //fancy set membership op i saw in the spec 
    assign doDualWrite       = (doCloseBraceWrite || doNumberWrite) && enable;
    
    assign dualWriteIndex    = doCloseBraceWrite ? lastBraceIndex    : curIndex + 1; 
    assign dualWriteTapeEntry= doCloseBraceWrite ? numberSecondElement : lastBraceTapeEntry;
    
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
            if(doNumberWrite) curIndex <= curIndex + 2;
            else              curIndex <= curIndex + 1;  

            
        end
    end



endmodule
