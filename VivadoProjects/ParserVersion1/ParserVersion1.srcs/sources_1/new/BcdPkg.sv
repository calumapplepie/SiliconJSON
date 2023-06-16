`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2023 02:39:08 PM
// Design Name: 
// Module Name: BcdPkg
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


package Bcd;
    // specifying all possible numeric values in here
    // should make block processing easier in future (?)
    typedef enum logic[3:0] {zero=4'd0, one=4'd1, 
        two=4'd2, three=4'd3, four=4'd4, five=4'd5, 
        six=4'd6, seven=4'd7, eight=4'd8, nine=4'd9,
        comma=4'd10, period=4'd11, exp=4'd12, minus=4'd13,
        plus = 4'd14, error=4'd15} BcdDigit; 
        // may consider different encoding to Optimize (tm)
        
    function BcdDigit charToBcd(Core::UTF8_Char in);
        case(in)
            // ascii numerals are contigous, handle them all at once
            // hopefully synthesis is smart enough not to stick an adder in here when LUTs would do.
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9": return BcdDigit'(in - 8'd60);
            "e", "E" : return exp;
            "," : return comma;
            "." : return period;
            "-" : return minus;
            "+" : return plus;
            default: return error;
        endcase
    endfunction
    
    function logic[63:0] bcdArrayToBinary(BcdDigit array [20:0]);
        // this is a good candidate for optimization!!!
        logic [63:0] retval;
        for (int i = 0; i <= 20; i++) begin
            retval += array[i] * (10**i);
        end
        return retval;
        
    endfunction
endpackage
