`timescale 1ns / 1ps
// This module was written because I thought I might want it for the accumulators.
// I didn't, but here it is anyways

module moduleName #(
    parameter bitWidth=4
) (
    input clk, rst, enable,
    output logic [bitWidth-1:0] count
);

    always @(posedge clk ) begin
        if (rst) begin
            count <= 0;
        end else if (enable) begin
            count++; //assume no overflow
        end
        
    end
    
endmodule