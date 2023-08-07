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
    
    InputIndex inputInLen,    parserInLen;      // lengths of input tapes
    InputIndex parserStrLen,  outputStrLen;     // lengths of string tape
    InputIndex parserLayLen,  outputLayLen;     // lengths of structure tapes

    UTF8_Char curChar;

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

    BramOrchestrator #(.NUMWORDS(Core::MaxInputLength), .WriteType(InputBlockRamWrite), .ReadType(InputBlockRamRead)) inputBrams ( .clk,
        .write1(inputInWrite),  .write2(parserInWrite), .write3(),
        .read1(),               .read2(parserInRead),   .read3(),
        .sel1(inputBlock),      .sel2(parserBlock),     .sel3(),
        .enb1(inputEnable),     .enb2(parserEnable),    .enb3('0)
    );
        
    BramOrchestrator #(.NUMWORDS(Core::StringTapeLength), .WriteType(StringBlockRamWrite), .ReadType(StringBlockRamRead), .DO_REG(0)) stringBrams( .clk,
        .write1(parserStrWrite),    .write2(outputStrWrite),.write3(),
        .read1(),                   .read2(outputStrRead),  .read3(),
        .sel1(parserBlock),         .sel2(outputBlock),     .sel3(),
        .enb1(parserEnable),        .enb2(outputEnable),    .enb3('0)
    );
    
    BramOrchestrator #(.NUMWORDS(Core::StructTapeLength), .WriteType(StructBlockRamWrite), .ReadType(StructBlockRamRead), .DO_REG(0)) layoutBrams( .clk,
        .write1(parserLayWrite),    .write2(outputLayWrite),.write3(),
        .read1(),                   .read2(outputLayRead),  .read3(),
        .sel1(parserBlock),         .sel2(outputBlock),     .sel3(),
        .enb1(parserEnable),        .enb2(outputEnable),    .enb3('0)
    );

    AxiStreamRecorder #(.NUMWORDS(8)) inputStage (
        .clk, .enable(inputEnable), .rst(inputRst), .done(inputDone),
        .ramWrite(inputInWrite), .transferLen(inputInLen),
        .TREADY(inputStreamReady), .TDATA(inputStreamData), 
        .TVALID(inputStreamValid), .TLAST(inputStreamLast), .TRESET(inputStreamReset)    
    );

    GenericBramReader reader(
        .clk, .rst(parserRst), .enable(parserEnable),
        .ramRead(parserInRead), .ramWrite(parserInWrite),
        .data(curChar)    
    );

    ParserTop parser (
        .curChar, .clk, .rst(parserRst), .enable(parserEnable),
        .stringRam(parserStrWrite), .structRam(parserLayWrite), 
        .strTapeLen(parserStrLen),  .layTapeLen(parserLayLen),
        .done(parserDone)
    );

    OutputRouter OUTY (
        .clk, .enb(outputEnable), .rst(outputRst),.done(outputDone),
        .blockSel(outputBlock),

        .layWrite(outputLayWrite), .strWrite(outputStrWrite),
        .layRead(outputLayRead),   .strRead(outputStrRead),
        .layLen(outputLayLen),     .strLen(outputStrLen),

        .streamReset(outputStreamReset), .streamReady(outputStreamReady),
        .streamData(outputStreamData),   .streamDest(outputStreamDest), 
        .streamValid(outputStreamValid), .streamLast(outputStreamLast)
    );

endmodule
