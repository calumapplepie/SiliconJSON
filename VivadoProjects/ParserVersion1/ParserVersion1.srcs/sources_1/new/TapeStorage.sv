`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/05/2023 03:36:42 PM
// Design Name: 
// Module Name: TapeStorage
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


module TapeStorage import Ram::*; #(NUMTAPES = 2, ADDRWIDTH= $clog2(NUMTAPES)-1) ( 
    input clk, //let users define their own ram enable code
    input [ADDRWIDTH:0] selectParser, selectReader,
    input StringBlockRamWrite parserStringWrite, readerStringWrite,
    input StructBlockRamWrite parserStructWrite, readerStructWrite,
    output StringBlockRamRead readerStringRead, 
    output StructBlockRamRead readerStructRead 
);

    StringBlockRamWrite stringRamW [NUMTAPES-1:0];
    StringBlockRamRead  stringRamR [NUMTAPES-1:0];
    StructBlockRamWrite structRamW [NUMTAPES-1:0];
    StructBlockRamRead  structRamR [NUMTAPES-1:0];
    logic               enb        [NUMTAPES-1:0];
    
    // todo: make this a generate
    // i shouldn't need to, but vivado won't obey LRM 23.3.3.5, or some other thing is happening... not sure
    TapeInstance tape0  (.clk, .enb(enb[0]), .stringRamW(stringRamW[0]), .structRamW(structRamW[0]), .stringRamR(stringRamR[0]), .structRamR(structRamR[0]));
    TapeInstance tape1  (.clk, .enb(enb[1]), .stringRamW(stringRamW[1]), .structRamW(structRamW[1]), .stringRamR(stringRamR[1]), .structRamR(structRamR[1]));

    
    always_comb begin 
        // I think/hope this will stop latches from being inferred? 
        // assignment technique credit this SO thread
        // https://electronics.stackexchange.com/questions/179142/systemverilog-structure-initialization-with-default-1
        foreach(stringRamW[i]) stringRamW[i] = '{default: 'x};
        foreach(structRamW[i]) structRamW[i] = '{default: 'x};
        
        // default to disabled
        foreach(enb[i]       ) enb[i]        = '0;
        
        stringRamW [selectParser] = parserStringWrite;
        structRamW [selectParser] = parserStructWrite;
        enb[selectParser] = '1;
        
        // wish there was a way to declare that selectParser != selectReader
        // that'd probably allow some optimizations on vivado's side
        stringRamW [selectReader] = readerStringWrite;
        structRamW [selectReader] = readerStructWrite;
        readerStringRead = stringRamR[selectReader];
        readerStructRead = structRamR[selectReader];
        
        enb[selectReader] = '1;
        
    end
    
endmodule
