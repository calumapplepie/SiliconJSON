`timescale 1ns / 1ps

module AxiStreamRecorder import Ram::*;  #(WORDSIZE=8, NUMWORDS=1, type WriteType=InputBlockRamWrite) (
        output WriteType ramWrite, 
        input logic clk, enable, rst, 
        output logic[$bits(ramWrite.addra)-1:0] transferLen,
        // AXI signals
        output logic TREADY, done,
        input logic [WORDSIZE-1:0] [NUMWORDS-1:0] TDATA,
        input logic TLAST, TVALID, TRESET
    );
    
    
    logic reset, writeData, wasLast;
    
    assign done = TLAST && writeData; // after the first clock edge with TLAST high, we can do ANYTHING; the data is already latched in ram
    
    assign reset = rst && !TRESET; // can the controller cause a reset, independent of global reset? I dunno.  Better to be safe tho.
    assign writeData = TVALID && TREADY;  // true if a write will occur on the next clock edge
    assign TREADY = enable && !reset && !wasLast;  // we're always ready to receive a read when enabled, unless we're already done
            
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
            if(writeData) transferLen <= transferLen +NUMWORDS;
        end
    end
endmodule
