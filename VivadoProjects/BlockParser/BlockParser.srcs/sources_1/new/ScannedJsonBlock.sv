`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2023 02:05:32 PM
// Design Name: 
// Module Name: ScannedJsonBlock
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
import Block::BitBlock, Block::TextBlock;

// using a class for this to allow use of all kinds of member functions
class ScannedCharBlock;
      // literal backslash chars
      BitBlock backslash;
      // escaped characters (directly after a backslash)
      BitBlock escaped;
      // unescaped quotes
      BitBlock quote;
      // string characters, including start but not end quote
      BitBlock in_string;
      
      function new(BitBlock back, escape, quo, in_str);
        backslash   = back;
        escaped     = escape;
        quote       = quo;
        in_string   = in_str;
      endfunction
endclass

class ScannedLayoutBlock;

endclass


class ScannedJsonBlock;
    

endclass
