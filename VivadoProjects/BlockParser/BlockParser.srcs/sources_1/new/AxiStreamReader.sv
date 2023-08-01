`timescale 1ns / 1ps

// encapsulates a BRAM reader to provide stream-reading powers

// DESIGN NOTE: BlockRamSharer MUST be enabled and connected to this module DURING a clock edge when reset is asserted
// yes that adds complexity, but I think it's a clever optimization which saves us a cycle of latency (wasted throughput) on the likley-critical path (bram reading start)
// admittedly we could also get that benefit other ways, and simplify this conceptually, though probably not logically

// ALSO NOTE: Does not do TDEST or TID handling.  It could tho.  I'm considering making TID randomly generated... a local param with $random()... or maybe make
// it increment on resets...  thoughts for later
module AxiStreamReader import Ram::*;  #(WORDSIZE=8, NUMWORDS=1, type WriteType=StringBlockRamWrite, type ReadType=StringBlockRamRead) (
        output WriteType ramWrite, 
        input ReadType ramRead,
        input logic clk, enable, rst, 
        input logic[$bits(ramWrite.addra)-1:0] transferLen,
        // AXI signals
        input logic TREADY, TRESET, 
        output logic [WORDSIZE-1:0] [NUMWORDS-1:0] TDATA,
        // Todo: TKEEP support (may not be worth it)
        output logic [WORDSIZE*NUMWORDS/8-1:0] TKEEP, // note: all ones except for when TLAST is asserted.  Xylinx doesn't sopport other things, see PG022
        output logic TLAST, TVALID
    );
    
    logic reset, updateOutput, wasReset, wasLast;
    
    assign reset = rst && !TRESET; // can the controller cause a reset, independent of global reset? I dunno.  Better to be safe tho.
    assign updateOutput = reset || TVALID && TREADY;  // (note that reset + enable causes the bram to emit ram[0])
    assign TVALID = enable && !wasReset && !reset && !wasLast; 
    assign TLAST = ramWrite.addra > transferLen - NUMWORDS;
    
    // todo: tkeep support
    assign TKEEP = '1;
    
    // handy for simulation verification
    int CycleNum;

    
    GenericBramReader #(.WORDSIZE(WORDSIZE), .NUMWORDS(NUMWORDS), .WriteType(WriteType), .ReadType(ReadType), .STARTDEX(NUMWORDS)) reader (
        .clk, .enable(updateOutput), .rst(reset), .data(TDATA), .ramWrite, .ramRead
    );  
        
    always_ff @(posedge clk) begin
        if(reset) begin
            wasReset <= '1;   
            wasLast  <= '0;   
            CycleNum <= '0;  
        end
        else if (enable) begin
            if(wasReset) begin // we just reset
                wasReset <= '0;
            end
            if(TLAST && TREADY) begin
                wasLast <= '1;
            end
            if(updateOutput) CycleNum <= CycleNum +1;
        end
    end
    
endmodule
