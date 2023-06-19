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
        input Bcd::BcdDigit curDigit, 
        input logic[2:0] selectedArray,// one-hot encoding plz
        input clk, rst, enb,
        output logic[63:0] accumulatedBufferData [2:0],
        output [4:0] numDigits [2:0]
        
    );
    
    // fancy schmany instance array
    BaseTenBinaryAccumulator  bufferHandler[2:0](
        .clk(clk), .rst(rst), .enb(selectedArray &  {3{enb}}), .numberOut(accumulatedBufferData), .nextIn(curDigit)
    );
    BinaryCounter #(.BITWIDTH(5)) numberOfDigits[2:0](
        .clk, .rst, .enable(selectedArray & {3{enb}}), .count(digitsAccumulated) 
    );
            
endmodule
