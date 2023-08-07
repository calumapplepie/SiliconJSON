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

        output StructBlockRamWrite layWrite, output StringBlockRamWrite strWrite,
        input  StructBlockRamRead  layRead,  input  StringBlockRamRead  strRead,
        input  InputIndex layLen, strLen,

        input  wire streamReset, streamReady,
        output wire [63:0] streamData, [3:0] streamDest, 
        output wire streamValid, streamLast
    );

    logic strEnable, strRst, strDone;
    logic layEnable, layRst, layDone;

    assign strRst = rst;
    assign layRst = rst;

    // we have string and struct s, they take turns
    logic[63:0] strStreamData,    layStreamData;
    logic       strStreamValid,   layStreamValid;
    logic       strStreamLast,    layStreamLast;
    
    assign streamData  = strEnable ? strStreamData  : 'z;
    assign streamData  = layEnable ? layStreamData  : 'z;
    
    assign streamValid = strEnable ? strStreamValid : 'z;
    assign streamValid = layEnable ? layStreamValid : 'z;
    
    assign streamLast  = strEnable ? strStreamLast  : 'z;
    assign streamLast  = layEnable ? layStreamLast  : 'z;
    
    AxiStreamReader #(.NUMWORDS(8)) str (
        .clk, .enable(strEnable), .rst(strRst), .done(strDone),
        .ramWrite(strWrite), .ramRead(strRead), 
        .transferLen(strLen),
        .TREADY(streamReady), .TRESET(streamReset),
        .TDATA(strStreamData), .TVALID(strStreamValid), .TLAST(layStreamLast)
    );
    
    AxiStreamReader #(.WORDSIZE(64), .WriteType(StructBlockRamWrite), .ReadType(StructBlockRamRead)) lay (
        .clk, .enable(layEnable), .rst(layRst), .done(layDone),
        .ramWrite(layWrite),  .ramRead(layRead), 
        .transferLen(layLen),
        .TREADY(streamReady), .TRESET(streamReset),
        .TDATA(layStreamData), .TVALID(layStreamValid), .TLAST(layStreamLast)
    );
endmodule
