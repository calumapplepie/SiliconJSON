`timescale 1ns / 1ps

module moduleName #(
    bits
) (
    input clk, rst, enable,
    output [0:bits-1] count
);

    always @(posedge clk ) begin
        if (rst){
            count = 0;
        }
        else if (enable){
            count++; //assume no overflow
        }
        
    end
    
endmodule