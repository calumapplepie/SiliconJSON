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
    InputBlockRamWrite  inputInWrite, stage1InWrite, stage2InWrite;
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
    
    
    BramOrchestrator #(.NUMWORDS(Core::MaxInputLength), .WriteType(InputBlockRamWrite), .ReadType(InputBlockRamRead)) inputBrams ( .clk,
        .write1(inputInWrite),  .write2(stage1InWrite), .write3(stage2InWrite),
        .read1(),               .read2(stage1InRead),   .read3(stage2InRead),
        .sel1('0),              .sel2('0),              .sel3('0),
        .enb1(inputEnable),     .enb2(stage1Enable),    .enb3(stage2Enable)
    );
    
    BramOrchestrator #(.NUMWORDS(Core::StructTapeLength*2), .WriteType(IndexBlockRamWrite), .ReadType(IndexBlockRamRead)) indexBrams ( .clk,
        .write1(stage1DexWrite),.write2(stage2DexWrite),.write3(),
        .read1(),               .read2(stage2DexRead),  .read3(),
        .sel1('0),              .sel2('0),              .sel3('1),
        .enb1(stage1Enable),    .enb2(stage2Enable),    .enb3('0)
    );
    
    BramOrchestrator #(.NUMWORDS(Core::StringTapeLength), .WriteType(StringBlockRamWrite), .ReadType(StringBlockRamRead), .DO_REG(0)) stringBrams( .clk,
        .write1(stage2StrWrite),    .write2(outputStrWrite),.write3(),
        .read1(),                   .read2(outputStrRead),  .read3(),
        .sel1('0),                  .sel2('0),              .sel3('1),
        .enb1(stage2Enable),        .enb2(outputStrEnable), .enb3('0)
    );
    
    BramOrchestrator #(.NUMWORDS(Core::StructTapeLength), .WriteType(StructBlockRamWrite), .ReadType(StructBlockRamRead), .DO_REG(0)) layoutBrams( .clk,
        .write1(stage2LayWrite),    .write2(outputLayWrite),.write3(),
        .read1(),                   .read2(outputLayRead),  .read3(),
        .sel1('0),                  .sel2('0),              .sel3('1),
        .enb1(stage2Enable),        .enb2(outputLayEnable), .enb3('0)
    );
        
    AxiStreamRecorder #(.NUMWORDS(8)) inputStage (
        .clk, .enable(inputEnable), .rst(inputRst), .done(inputDone),
        .ramWrite(inputInWrite), .transferLen(), // todo: make use of txfr len
        .TREADY(inputStreamReady), .TDATA(inputStreamData), 
        .TVALID(inputStreamValid), .TLAST(inputStreamLast), .TRESET(inputStreamReset)    
    );
    
    StageOneParser stage1 (
        .clk, .enb(stage1Enable), .rst(stage1Rst), .done(stage1Done),
        .readChars(stage1InRead), .indexOut(stage1DexWrite), .inputControl(stage1InWrite)
    );
    
    StageTwoParser stage2();
    
    // we have string and struct outputs, they take turns
    logic[63:0] outputStrStreamData,    outputLayStreamData;
    logic       outputStrStreamValid,   outputLayStreamValid;
    logic       outputStrStreamLast,    outputLayStreamLast;
    
    assign outputStreamData  = outputStrEnable ? outputStrStreamData  : 'z;
    assign outputStreamData  = outputLayEnable ? outputLayStreamData  : 'z;
    
    assign outputStreamValid = outputStrEnable ? outputStrStreamValid : 'z;
    assign outputStreamValid = outputLayEnable ? outputLayStreamValid : 'z;
    
    assign outputStreamLast  = outputStrEnable ? outputStrStreamLast  : 'z;
    assign outputStreamLast  = outputLayEnable ? outputLayStreamLast  : 'z;
    
    AxiStreamReader #(.NUMWORDS(8)) outputStr (
        .clk, .enable(outputStrEnable), .rst(outputStrRst), .done(outputStrDone),
        .ramWrite(outputStrWrite), .ramRead(outputStrRead), 
        .transferLen(), // todo!
        .TREADY(outputStreamReady), .TRESET(outputStreamReset),
        .TDATA(outputStrStreamData), .TVALID(outputStrStreamValid), .TLAST(outputLayStreamLast)
    );
    
    AxiStreamReader #(.WORDSIZE(64), .WriteType(StructBlockRamWrite), .ReadType(StructBlockRamRead)) outputLay (
        .clk, .enable(outputLayEnable), .rst(outputLayRst), .done(outputLayDone),
        .ramWrite(outputLayWrite),  .ramRead(outputLayRead), 
        .transferLen(), // todo!
        .TREADY(outputStreamReady), .TRESET(outputStreamReset),
        .TDATA(outputLayStreamData), .TVALID(outputLayStreamValid), .TLAST(outputLayStreamLast)
    );
    
    
    
endmodule
