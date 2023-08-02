`timescale 1ns / 1ps

module BlockParserTop import Ram::*, Block::*; (
        input  wire clk,
        input  wire [63:0] inputStreamData, [3:0] inputStreamDest,
        input  wire inputStreamValid, inputStreamLast, inputStreamReset,
        output wire inputStreamReady,
        input  wire outputStreamReset, outputStreamReady,
        output wire [63:0] outputStreamData, [3:0] outputStreamDest, 
        output wire outputStreamValid, outputStreamLast
    );  
    // declare the various memory interfaces
    InputBlockRamWrite  inputInWrite, stage1InWrite, stage2InRead;
    InputBlockRamRead   stage1InRead, stage2InRead;
    
    IndexBlockRamWrite stage1DexWrite, stage2DexWrite;
    IndexBlockRamRead  stage2DexRead;
    
    StringBlockRamWrite stage2StrWrite, outputStrWrite;
    StringBlockRamRead  outputStrRead;
    
    StructBlockRamWrite stage2LayWrite, outputLayWrite;
    StructBlockRamRead  outputLayRead;
    
    // stage-by-stage enables, resets, and completes
    logic inputEnable, stage1Enable, stage2Enable, outputStrEnable, outputLayEnable;
    logic inputRst,    stage1Rst,    stage2Rst,    outputStrRst,    outputLayRst;
    logic inputDone,   stage1Done,   stage2Done,   outputStrDone,   outputLayDone;    
            
    
    
    StageOrchestrator stage_mgr  ();
    
    BramOrchestrator  inputBrams ();
    BramOrchestrator  indexBrams ();
    BramOrchestrator  stringBrams();
    BramOrchestrator  layoutBrams ();
        
    AxiStreamRecorder #(.NUMWORDS(8)) inputStage (
        .clk, .enb(inputEnable), .rst(inputRst),
        .ramWrite(inputInWrite), .transferLen(), // todo: make use of txfr len
        .TREADY(inputStreamReady), .TDATA(inputStreamData), 
        .TVALID(inputStreamValid), .TLAST(inputStreamLast), .TRESET(inputStreamReset)    
    );
    
    StageOneParser stage1 (
        .clk, .enb(stage1Enable), .rst(stage1Rst),
        .readChars(stage1InRead), .indexOut(stage1DexWrite), .inputControl(stage1InWrite)
    );
    
    StageTwoParser stage2();
    
    // we have string and struct outputs, they take turns
    logic[63:0] outputStrStreamData,    outputLayStreamData;
    logic       outputStrStreamValid,   outputLayStreamValid;
    logic       outputStrStreamLast,    outputLayStreamLast;
    
    
    AxiStreamReader #(.NUMWORDS(8)) outputStr (
        .clk, .enb(outputStrEnable), .rst(outputStrRst),
        .ramWrite(outputStrWrite), .ramRead(outputStrRead), 
        .transferLen(), // todo!
        .TREADY(outputStreamReady), .TRESET(outputStreamReset),
        .TDATA(outputStrStreamData), .TVALID(outputStrStreamValid), .TLAST(outputLayStreamLast)
    );
    
    AxiStreamReader #(.WORDSIZE(64), .WriteType(StructBlockRamWrite), .ReadType(StructBlockRamRead)) outputLay (
        .clk, .enb(outputLayEnable), .rst(outputLayRst),
        .ramWrite(outputLayWrite),  .ramRead(outputLayRead), 
        .transferLen(), // todo!
        .TREADY(outputStreamReady), .TRESET(outputStreamReset),
        .TDATA(outputLayStreamData), .TVALID(outputLayStreamValid), .TLAST(outputLayStreamLast)
    );
    
    
    
endmodule
