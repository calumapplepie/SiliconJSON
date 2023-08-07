`timescale 1ns / 1ps
module DMATop import Ram::*, Core::*; (
        input  wire clk, enb, rst,
        input  wire [63:0] inputStreamData, [3:0] inputStreamDest,
        input  wire inputStreamValid, inputStreamLast, inputStreamReset,
        output wire inputStreamReady,
        input  wire outputStreamReset, outputStreamReady,
        output wire [63:0] outputStreamData, [3:0] outputStreamDest, 
        output wire outputStreamValid, outputStreamLast
    );  

    // declare the various memory interfaces
    InputBlockRamWrite  inputInWrite, parserInWrite;
    InputBlockRamRead   parserInRead;
    
    StringBlockRamWrite parserStrWrite, outputStrWrite;
    StringBlockRamRead  outputStrRead;
    
    StructBlockRamWrite parserLayWrite, outputLayWrite;
    StructBlockRamRead  outputLayRead;

    logic       inputEnable, parserEnable, outputEnable;
    logic       inputRst,    parserRst,    outputRst;
    logic       inputDone,   parserDone,   outputDone;    
    logic [3:0] inputBlock,  parserBlock,  outputBlock;
    
    InputIndex inputInLen,    parserInLen;                       // lengths of input tapes
    InputIndex parserStrLen,  outputStrLen;                                 // lengths of string tape
    InputIndex parserLayLen,  outputLayLen;                                 // lengths of structure tapes

    DMAOrchestrator dma_mgr  ( .clk, .enb, .rst,
        .inputEnable, .parserEnable, .outputEnable,
        .inputRst,    .parserRst,    .outputRst,
        .inputDone,   .parserDone,   .outputDone,
        .inputBlock,  .parserBlock,  .outputBlock
    );

    LengthOrchestrator inputLenMgr(.clk, .web(inputDone), 
        .din(inputInLen),  .dout1(parserInLen), .dout2(),
        .selW(inputBlock), .selR1(parserBlock), .selR2()
    );
    
    LengthOrchestrator strLenMgr(.clk, .web(parserDone), 
        .din(parserStrLen), .dout1(outputStrLen), .dout2(),
        .selW(parserBlock), .selR1(outputBlock),  .selR2()
    );
    
    LengthOrchestrator layLenMgr(.clk, .web(parserDone), 
        .din(parserLayLen), .dout1(outputLayLen), .dout2(),
        .selW(parserBlock), .selR1(outputBlock),  .selR2()
    );



endmodule
