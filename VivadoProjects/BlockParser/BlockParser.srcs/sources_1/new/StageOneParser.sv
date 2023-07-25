`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2023 01:21:33 PM
// Design Name: 
// Module Name: StageOneParser
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


module StageOneParser import Block::*; ( input clk, enb, rst,
                        input TextBlock chars, 
                        output logic holdPipeline
    );
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
