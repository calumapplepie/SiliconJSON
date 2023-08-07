`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2023 01:03:21 PM
// Design Name: 
// Module Name: OutputRouter
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


module OutputRouter import Ram::*, Core::InputIndex;(
        input  wire clk, enb, rst,
        output wire done,
        input  wire outputStreamReset, outputStreamReady,
        output wire [63:0] outputStreamData, [3:0] outputStreamDest, 
        output wire outputStreamValid, outputStreamLast
    );

    logic outputStrEnable, outputStrRst, outputStrDone;
    logic outputLayEnable, outputLayRst, outputLayDone;

    assign outputStrRst = rst;
    assign outputLayRst = rst;

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
        .transferLen(outputStrLen),
        .TREADY(outputStreamReady), .TRESET(outputStreamReset),
        .TDATA(outputStrStreamData), .TVALID(outputStrStreamValid), .TLAST(outputLayStreamLast)
    );
    
    AxiStreamReader #(.WORDSIZE(64), .WriteType(StructBlockRamWrite), .ReadType(StructBlockRamRead)) outputLay (
        .clk, .enable(outputLayEnable), .rst(outputLayRst), .done(outputLayDone),
        .ramWrite(outputLayWrite),  .ramRead(outputLayRead), 
        .transferLen(outputLayLen),
        .TREADY(outputStreamReady), .TRESET(outputStreamReset),
        .TDATA(outputLayStreamData), .TVALID(outputLayStreamValid), .TLAST(outputLayStreamLast)
    );
endmodule
