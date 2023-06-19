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

    assign Bcd::BcdDigit curDigit = charToBcd(curChar);

    logic numSign, exponentSign;
    logic [63:0] parsedNumSegments [2:0];
    wire [2:0] selectedArray;    
    
    BcdAccumulator accum(
        .accumulatedBufferData(parsedNumSegments), 
        .selectedArray, .curDigit,
        .clk, .enb, .rst 
    );
    
    typedef enum logic[5:0] {
        //StartNum, // needed to make verification work, since a 0 is only permitted if next char is .
        IntParse,
        DecimalParse,
        ExponentParse,
        Error
    } state_t;
    state_t curState;
    state_t nextState;
    
    //next state logic!
    always_comb begin
        import Bcd::*;
        case(curState)
            IntParse: case(curDigit)
                
                default: curDigit;
            endcase
            default: nextState = Error;
        endcase
    end

    always_ff @( clk ) begin
        if(rst) begin
            curState <= StartNum;
            numSign <= '0;
            exponentSign <= '0;
        end
    end
    
    
    
endmodule
