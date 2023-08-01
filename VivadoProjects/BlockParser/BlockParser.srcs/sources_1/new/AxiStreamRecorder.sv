`timescale 1ns / 1ps

module AxiStreamRecorder import Ram::*;  #(WORDSIZE=8, NUMWORDS=1, type WriteType=StringBlockRamWrite) (
        output WriteType ramWrite, 
        input logic clk, enable, rst, 
        output logic[$bits(ramWrite.addra)-1:0] transferLen,
        // AXI signals
        output logic TREADY, 
        input logic [WORDSIZE-1:0] [NUMWORDS-1:0] TDATA,
        input logic TLAST, TVALID, TRESET
    );
    
    
    logic reset, writeData, wasLast;
    
    assign reset = rst && !TRESET; // can the controller cause a reset, independent of global reset? I dunno.  Better to be safe tho.
    assign writeData = TVALID && TREADY;  
    assign TREADY = enable && !reset && !wasLast; 
            
    GenericBramRecorder #(.WORDSIZE(WORDSIZE), .NUMWORDS(NUMWORDS), .WriteType(WriteType)) reader (
        .clk, .enable(writeData), .rst(reset), .data(TDATA), .ramWrite
    );  
        
    always_ff @(posedge clk) begin
        if(reset) begin
            transferLen <= '0;  
        end
        else if (enable) begin
            if(TLAST && writeData) begin
                wasLast <= '1;
            end
            if(writeData) transferLen <= transferLen +1;
        end
    end
endmodule
