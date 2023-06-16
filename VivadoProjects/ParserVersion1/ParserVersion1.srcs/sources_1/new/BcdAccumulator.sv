`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2023 02:39:08 PM
// Design Name: 
// Module Name: BcdAccumulator
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


module BcdAccumulator import Bcd::*; (
        input Core::UTF8_Char curChar, 
        input logic[2:0] selectedArray,// one-hot encoding plz
        input clk, rst, enb,
        output logic[63:0] accumulatedBufferData [2:0]
    );
    BcdDigit[20:0] buffers [2:0];
    BcdDigit nextDigit;
    assign nextDigit = CharToBcd(curChar);
    
    // fancy schmany instance array
    ShiftRegister #(.WORDSIZE(4), .NUMWORDS(20))  bufferHandler[2:0](
        .clk(clk), .rst(rst), .enb(selectedArray), .arrayOut(buffers), .nextIn(nextDigit)
    );
    
    // note: may be more optimal to multiply-add as we go, rather than converting an array
    // in fact it most definitely will be
    // ... oops, guess that wasted a chunk of time
    assign accumulatedBufferData[0] = BcdArrayToBinary(buffers[0]);
    assign accumulatedBufferData[1] = BcdArrayToBinary(buffers[1]);
    assign accumulatedBufferData[2] = BcdArrayToBinary(buffers[2]);
        
endmodule
