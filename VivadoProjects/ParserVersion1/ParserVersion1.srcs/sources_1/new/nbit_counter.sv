`timescale 1ns / 1ps

module moduleName #(
    bitWidth
) (
    input clk, rst, enable,
    output [bitWidth-1:0] count
);

    always @(posedge clk ) begin
        if (rst) begin
            count = 0;
        end else if (enable) begin
            count++; //assume no overflow
        end
        
    end
    
endmodule