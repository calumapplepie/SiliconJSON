`timescale 1ns / 1ps

module BlockParserTop(
        input  wire clk,
        input  wire [63:0] inputStreamData, [3:0] inputStreamTdest,
        input  wire inputStreamTvalid, inputStreamTlast, inputStreamReset,
        output wire inputStreamReady,
        input  wire outputStreamReset, outputStreamReady,
        output wire [63:0] outputStreamData, [3:0] outputStreamTdest, 
        output wire outputStreamValid, outputStreamLast
    );
    AxiStreamRecorder #(.NUMWORDS(8)) INPUT ();
    
endmodule
