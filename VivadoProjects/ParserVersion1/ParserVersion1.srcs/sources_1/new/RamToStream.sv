/*
    This module is designed to connect to an external block ram and
    command it to read its data, which it then wraps in the signals to
    form an AXI-4 Stream.
    It assumes the data to be sent starts at address 0 of the block ram
 */

module RamToStream #(ADDR_SIZE=8)(
        input logic [ADDR_SIZE-1:0] endAddr,
        input logic clk, rst, enb,
        // connect this to RAM
        output logic [ADDR_SIZE-1:0] readAddr,
        // striaght from the AMBA AXI spec
        input TREADY, output logic TVALID
    );
    
    // warning: DOES NOT WORK
    // needs key timing fixes to make stream coherent
    // Realized that no, i REALLY SHOULD get a GPIO interface working.
    
    always_ff @(posedge clk) begin
        if(rst) begin
            readAddr <= '0;
            TVALID   <= '0;
        end
        if(enb) begin
            // if we were just reset, we need to wait 1 cycle while the RAM reads the current value
            if(!TVALID && readAddr == '0) TVALID <= '1;
            if(TVALID && TREADY) begin// ie, if we transmit a byte this cycle
                readAddr <= readAddr +1;
            end
        end
        
    end
    
endmodule