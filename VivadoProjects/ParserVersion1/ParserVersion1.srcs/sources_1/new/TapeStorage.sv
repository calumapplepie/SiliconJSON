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


module TapeStorage import Ram::*; #(NUMTAPES = 2, ADDRWIDTH= $clog2(NUMTAPES)) ( 
    input clk, //let users define their own ram enable code
    input [ADDRWIDTH-1:0] selectParser, selectReader,
    input StringBlockRamWrite parserStringWrite, readerStringWrite,
    input StructBlockRamWrite parserStructWrite, readerStructWrite,
    output StringBlockRamRead readerStringRead, 
    output StructBlockRamRead readerStructRead 
);
    logic [63:0] lookAtMe1,lookAtMe2;
    
    // its not an array of structs, vivado, you happy now????!?!
    StringBlockRamWrite stringRamW0;
    StringBlockRamRead  stringRamR0;
    StructBlockRamWrite structRamW0;
    StructBlockRamRead  structRamR0;
    logic               enb0;
    
    StringBlockRamWrite stringRamW1;
    StringBlockRamRead  stringRamR1;
    StructBlockRamWrite structRamW1;
    StructBlockRamRead  structRamR1;
    logic               enb1;
    
    // yes this is copy pasted, thats the only way to not trigger this bug AFAICT:
    // https://support.xilinx.com/s/question/0D54U000076hQ0GSAU/intermittent-struct-member-access-misbehavior?language=en_US&t=1689260946429
    TapeInstance tape0  (.clk, .enb(enb0), .stringRamW(stringRamW0), .structRamW(structRamW0), .stringRamR(stringRamR0), .structRamR(structRamR0));
    assign stringRamW0 = 1'd0 == selectParser ? parserStringWrite : readerStringWrite;
    assign structRamW0 = 1'd0 == selectParser ? parserStructWrite : readerStructWrite;
    assign enb0        = 1'd0 == selectParser ? '1 : 0;
    
    TapeInstance tape1  (.clk, .enb(enb0), .stringRamW(stringRamW0), .structRamW(structRamW0), .stringRamR(stringRamR0), .structRamR(structRamR0));
    assign stringRamW1 = 1'd1 == selectParser ? parserStringWrite : readerStringWrite;
    assign structRamW1 = 1'd1 == selectParser ? parserStructWrite : readerStructWrite;
    assign enb1        = 1'd1 == selectParser ? '1 : 0;
    
    assign readerStringRead = 1'd0 == selectReader ? stringRamR0 : stringRamR1;
    assign readerStructRead = 1'd0 == selectReader ? structRamR0 : structRamR1;
    
    
    /* Previous mux logic
    always_comb begin 
        // I think/hope this will stop latches from being inferred? 
        // assignment technique credit this SO thread
        // https://electronics.stackexchange.com/questions/179142/systemverilog-structure-initialization-with-default-1
        foreach(stringRamW[i]) stringRamW[i] = '{default: '0};
        foreach(structRamW[i]) structRamW[i] = '{default: '0};
        
        // default to disabled
        foreach(enb[i]       ) enb[i]        = '0;
        
        // based on the following link, weird problems with the obvious way to do things are common, sooo... yay!
        // https://support.xilinx.com/s/question/0D52E00006iHlfoSAC/systemverilog-struct-wrong-behaviour?language=en_US
        
        stringRamW [selectParser] = parserStringWrite;
        lookAtMe1 = parserStructWrite.dia;
        structRamW [selectParser] = parserStructWrite;
        lookAtMe2 = structRamW[selectParser].dia;
        
        
       
        // wish there was a way to declare that selectParser != selectReader
        // that'd probably allow some optimizations on vivado's side
        stringRamW [selectReader] = readerStringWrite;
        structRamW [selectReader] = readerStructWrite;
        readerStringRead = stringRamR[selectReader];
        readerStructRead = structRamR[selectReader];
        
        enb[selectReader] = '1; 
      
    end  */
    
endmodule
