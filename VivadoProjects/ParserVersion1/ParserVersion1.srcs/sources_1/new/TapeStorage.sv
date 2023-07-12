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
    StringBlockRamWrite stringRamW [NUMTAPES-1:0];
    StringBlockRamRead  stringRamR [NUMTAPES-1:0];
    StructBlockRamWrite structRamW [NUMTAPES-1:0];
    StructBlockRamRead  structRamR [NUMTAPES-1:0];
    logic               enb        [NUMTAPES-1:0];
    
    // this shouldn't need to be a generate, for the tape to work, but vivado won't obey LRM 23.3.3.5, or some other thing is happening... not sure
    genvar  i;
    for(i=0; i<NUMTAPES; i++) begin:tape
        TapeInstance tape  (.clk, .enb(enb[i]), .stringRamW(stringRamW[i]), .structRamW(structRamW[i]), .stringRamR(stringRamR[i]), .structRamR(structRamR[i]));
                
                // lets try assigning the structs in here, see if the problem continues
                assign stringRamW[i] = i == selectParser ? parserStringWrite : readerStringWrite;
                assign structRamW[i] = i == selectParser ? parserStructWrite : readerStructWrite;
                assign enb[i] = i == selectParser ? '1 : 0;
    
    end:tape
    
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
