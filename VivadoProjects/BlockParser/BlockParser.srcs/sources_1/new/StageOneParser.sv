`timescale 1ns / 1ps

module StageOneParser import Block::*; ( input clk, enb, rst,
                        input Ram::InputBlockRamRead readChars,
                        output Ram::IndexBlockRamWrite indexOut,
                        output Ram::InputBlockRamWrite inputControl
    );
    
    TextBlock chars;
    ScannedJsonBlock scannedBitmapsA, scannedBitmapsB;
    InputIndex startingIndex;
    InputIndex [3:0] structureStarts;
    logic [3:0] structureStartsValid;
    logic holdPipeline;
    
    GenericBramReader #(.NUMWORDS(BlockSizeChars), .WriteType(Ram::InputBlockRamWrite), .ReadType(Ram::InputBlockRamRead), .USEPORTS(2))  READS(
        .clk, .rst, .enable(enb && !holdPipeline), 
        .data(chars), .ramWrite(inputControl), .ramRead(readChars)
    ); 
    
    LayoutStageOne layoutFinder (.clk, .enb, .rst, .chars, .scannedBitmaps(scannedBitmapsA));
    
    BitmapToIndicies structure_start_count (.clk, .rst, .enb, .holdPipeline, 
                                            .bitmap(scannedBitmapsA.structuralStart), .startingIndex, 
                                            .oneIndexes(structureStarts), .valids(structureStartsValid)
    ); // includes pipelining all on its own!
    
    always_ff @(posedge clk) begin
        if(rst) startingIndex <= '0;
        else if(enb && !holdPipeline) startingIndex <= startingIndex + BlockSizeChars;
    
    end

    always_ff @(posedge clk) begin
        if(enb && ! holdPipeline) begin
            scannedBitmapsB <= scannedBitmapsA;  // when we pass a map on to the next stage, it needs to be delayed a bit
        end
    end 

    VariableMultiRecorder #(.BITWIDTH(16), .WriteType(Ram::IndexBlockRamWrite)) structureStartRecorder(
        .clk, .enb, .rst, 
        .inputVals(structureStarts), .valids(structureStartsValid), 
        .ramOut(indexOut)
    );
    
    
    // todo: testbench
    
    
    
    
    /*
    okay fam lets talk.  SO; simdjson makes a variety of design decisions that make it good for CPU and less good for FPGA
    if we want to just yoink the approach.  While the first half of stage one is almost completely unproblematic, except for one adder,
    the second half gets quite dicey, and stage two is outright evil.
    
    The first half asssembles bitmaps.  Okay, cool.  The second half scans those bitmaps and makes indexes into arrays.  A bit tougher for hardware.
    They write 8 indicies at once, and then go back and check if they should have written less.  its pretty clever, see json_structural_indexer.h
    
    Problem: we can only write 2 words into block rams at a time.  Solution: asymetric rams, have 32 bit write ports and 16 bit read ports
    Problem: attempted implementaion of asymetric rams ran into vivado compile error, not to be fixed until 2023.2
    Solution: reattempt asymetric rams.
    
    The hold pipeline exists because in a truly hostile 64 bit word, you may need to write out 16 or 32 or more structural character
    indexes to write, and so we need to hold on to this current block of text while we go through them all. 
    
    Also, simdjson throws away the information on where quotes and backslashes are between stages 1 and 2 of their implementation.  
    Which i think is silly.
    */
    
endmodule
