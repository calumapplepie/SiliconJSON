`timescale 1ns / 1ps

package Block;
    parameter int BlockSizeChars = 8;
    parameter int BlockSizeBits = BlockSizeChars * 8;
    typedef Core::UTF8_Char[BlockSizeChars-1:0] TextBlock;
    typedef logic [BlockSizeChars-1:0]          BitBlock;
    typedef logic [$clog2(BlockSizeChars)-1:0]  BitBlockIndex;
    typedef logic [$clog2(Core::MaxInputLength)-1:0] InputIndex;
    
    
    
    typedef struct{
          // literal backslash chars
          BitBlock backslash;
          // escaped characters (directly after a backslash)
          BitBlock escaped;
          // unescaped quotes
          BitBlock quote;
          // string characters, including start but not end quote
          BitBlock in_string;
    } ScannedCharBlock;
    
    typedef struct{ 
          BitBlock whitespace;
          BitBlock pseudoStructural;
    } ScannedLayoutBlock;
    
    
    typedef struct {
        ScannedCharBlock   strings;
        ScannedLayoutBlock layout;
        BitBlock followsPotentialScalar;// they have a whole definition for this but I assume its for a good reason
    } ScannedJsonBlock;
    
    
endpackage
