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
        input clk, rst, enable, active,
        output Ram::StructBlockRamWrite ramConnection
    );
    
    TapeIndex curIndex;
    TapeIndex lastBraceIndex;
    TapeIndex dualWriteIndex;
    
    JsonTapeElement curIndexTapeEntry;
    JsonTapeElement lastBraceTapeEntry;
    JsonTapeElement dualWriteTapeEntry;
    
    logic [9:0] curDepth;
    
    logic doCloseBraceWrite, doNumberWrite, doDualWrite;
    /*
    TapeBlockRam #(.WORDSIZE(64), .NUMWORDS(StructTapeLength)) blockRam  (
            .clk(clk), .ena('1), .enb('1), //always enable
            .wea(enable | doDualWrite),            .web(doDualWrite),  
            .addra(curIndex),        .addrb(dualWriteIndex),
            .dia(curIndexTapeEntry), .dib(dualWriteTapeEntry));
    */
    
     always_comb begin  
            ramConnection.ena = enable;
            ramConnection.enb = enable; 
            ramConnection.wea = active | doDualWrite;            
            ramConnection.web = doDualWrite;  
            ramConnection.addra = curIndex;        
            ramConnection.addrb = dualWriteIndex;
            
            ramConnection.dib = dualWriteTapeEntry;
    end
    
    assign ramConnection.dia = curIndexTapeEntry;
            
    BlockRamStack stack (
        .clk, .enb(active && enable), .rst, 
        .pushEnable(doOpenBraceWrite), .popTrigger(doCloseBraceWrite), 
        .popData(lastBraceIndex[17:0]), .pushData(curIndex), .curDepth
    );
    
    assign lastBraceIndex[55:18] = '0;
   
    assign doOpenBraceWrite  = (nextTapeEntry[63:56] == "{" || nextTapeEntry[63:56] == "[");
    assign doCloseBraceWrite = (nextTapeEntry[63:56] == "}" || nextTapeEntry[63:56] == "]");
    assign doNumberWrite     = nextTapeEntry[63:56] inside {"l", "d", "u"}; //fancy set membership op i saw in the spec 
    assign doDualWrite       = (doCloseBraceWrite || doNumberWrite);
    
    assign dualWriteIndex    = doCloseBraceWrite ? lastBraceIndex    : curIndex + 1; 
    assign dualWriteTapeEntry= doCloseBraceWrite ? lastBraceTapeEntry: numberSecondElement;
    
    always_comb begin
        curIndexTapeEntry = nextTapeEntry; 
        
        if(doCloseBraceWrite) begin
            curIndexTapeEntry[55:0] = lastBraceIndex;
        end 
        
        // generate the last brace entry
        lastBraceTapeEntry = '0;
        lastBraceTapeEntry[31:0] = curIndex+1;
        lastBraceTapeEntry[55:32] = keyValuePairs;
        lastBraceTapeEntry[63:56] = nextTapeEntry[63:56]-2; // 2 less than a close brace or bracket is an open
        // thanks for the consistent layout ASCII inventors, this can be optimized with a 2 member LUT
        
        // root handler
        if (curDepth == 0) begin
            lastBraceTapeEntry[63:56] = "r";
            lastBraceTapeEntry[55:32] = '0;
            curIndexTapeEntry[63:56] = "r";
        end 
    end
    
    always_ff @(posedge clk ) begin
        if (rst) begin
            curIndex <= 56'd1;
        end else if(active && enable) begin            
            if(doNumberWrite) curIndex <= curIndex + 2;
            else              curIndex <= curIndex + 1;  
        end
    end



endmodule
