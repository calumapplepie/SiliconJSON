`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2023 07:51:13 PM
// Design Name: 
// Module Name: VivadoDidYouBreakClog2
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


module VivadoDidYouBreakClog2();
    integer i;
    initial begin
        for(i = 0; i<4098; i++)begin
            $display("clog2(%d) = %d", i, $clog2(i)-1);
        end 
    end

endmodule
