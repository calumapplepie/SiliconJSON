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

    logic       inputEnable, parserEnable, outputStrEnable, outputLayEnable;
    logic       inputRst,    parserRst,    outputStrRst,    outputLayRst;
    logic       inputDone,   parserDone,   outputStrDone,   outputLayDone;    
    logic [3:0] inputBlock,  parserBlock,  outputBlock;



endmodule
