`timescale 1ns / 1ps

module moduleName #(
    bitWidth
) (
    input clk, rst, enable,
    output [0:bitWidth-1] count
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