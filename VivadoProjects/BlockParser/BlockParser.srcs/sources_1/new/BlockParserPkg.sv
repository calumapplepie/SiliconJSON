`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2023 01:21:33 PM
// Design Name: 
// Module Name: BlockParserPkg
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


package Block;
    parameter int BlockSizeChars = 8;
    parameter int BlockSizeBits = BlockSizeChars * 8;
    typedef Core::UTF8_Char[BlockSizeChars-1:0] TextBlock;
    typedef logic [BlockSizeChars-1:0]     BitBlock;
    
    
    typedef struct{
          // literal backslash chars
          BitBlock backslash;
          // escaped characters (directly after a backslash)
          BitBlock escaped;
          // unescaped quotes
          BitBlock quote;
          // string characters, including start but not end quote
          BitBlock in_string;} ScannedCharBlock;
    
    class ScannedLayoutBlock;
    
    endclass
    
    
    class ScannedJsonBlock;
        
    
    endclass
    
    
endpackage
