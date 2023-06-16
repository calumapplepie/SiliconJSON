`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/14/2023 05:33:54 PM
// Design Name: 
// Module Name: NumberParsingFSM
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


module NumberParsingFSM import Core::UTF8_Char, Core::ElementType;(
        input UTF8_Char curChar,
        input clk, rst, enb,
        output complete,
        output [63:0] number, output ElementType numberType
    );

    logic numSign, exponentSign;
    logic [3:0] integralSegment    [20:0];
    logic [3:0] decimalSegment     [20:0];
    logic [3:0] exponentialSegment [5:0];
    
    typedef enum logic[5:0] {
        StartNum,
        IntParse,
        DecimalParse,
        ExponentParse,
        Error
    } state_t;
    state_t curState;
    state_t nextState;
    
    //next state logic!
    always_comb begin
        case(curState)

            default: nextState = Error;
        endcase
    end

    always_ff @( clk ) begin
        if(rst) begin
            curState <= StartNum;
            integralSegment <= '0;
            decimalSegment <= '0;
            exponentialSegment <= '0;
            sign <= '0;
        end
    end
    
    
    
endmodule
