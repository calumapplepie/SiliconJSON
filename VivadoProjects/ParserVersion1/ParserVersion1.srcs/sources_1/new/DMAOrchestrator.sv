`timescale 1ns / 1ps

module DMAOrchestrator( input logic clk, rst, enb,
    output logic       inputEnable, parserEnable, outputEnable,
    output logic       inputRst,    parserRst,    outputRst,
    input  logic       inputDone,   parserDone,   outputDone,  
    output logic [3:0] inputBlock,  parserBlock,  outputBlock
    );
endmodule
