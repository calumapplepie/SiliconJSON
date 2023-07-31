`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2023 05:28:19 PM
// Design Name: 
// Module Name: LayoutStageOne
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


module LayoutStageOne import Block::*; (
        input clk, rst, enb, 
        input TextBlock chars, 
        output ScannedJsonBlock scannedBitmaps
    );
    BitBlock layoutChars, whitespace, followsScalar;
    logic prev_scalar, next_scalar;
    ScannedCharBlock    strings;
    ScannedLayoutBlock  scannedStruct;
        
    
    StringStageOne processString (.clk, .rst, .enb, .chars, .scannedChars(strings));
    StructureAndWhitespaceBitmapBuilder gimmeSomeBits (.chars, .layoutChars, .whitespace);
    
    always_comb begin
        scannedStruct.whitespace = whitespace;
        scannedStruct.pseudoStructural = layoutChars;
        scannedBitmaps.strings = strings;
        scannedBitmaps.layout  = scannedStruct;
        scannedBitmaps.followsPotentialScalar = followsScalar;
        scannedBitmaps.structuralStart = structuralStart;

    end
    
    always_comb begin
        // models jsonscanner::next
        automatic BitBlock scalar, nonquoteScalar;
        scalar = ~(whitespace | layoutChars);
        nonquoteScalar = scalar & ~strings.quote;
        followsScalar = nonquoteScalar << 1 | prev_scalar;
        next_scalar = nonquoteScalar[BlockSizeChars-1];
    end
    
    always_comb begin
        // model what happens in json_block::structural_start()
        automatic BitBlock potentialStructStart, string_tail, potentialScalarStart, scalar;
        scalar = ~(whitespace | layoutChars);
        potentialScalarStart = scalar &~ followsScalar;
        potentialStructStart = characters.layoutChars | potentialScalarStart;
        string_tail = strings.quote ^ strings.in_string;
        structuralStart = potentialStructStart &~ string_tail;
    end

    always_ff @(posedge clk) begin
        if(rst) prev_scalar <= '0;
        else if(enb) prev_scalar <= next_scalar;
    end
    
endmodule
