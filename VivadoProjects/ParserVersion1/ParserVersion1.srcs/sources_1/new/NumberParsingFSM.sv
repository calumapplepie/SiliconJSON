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

    Bcd::BcdDigit curDigit;
    logic enableAccumulator;


    assign curDigit = charToBcd(curChar);

    logic numSign, exponentSign;
    logic [63:0] parsedNumSegments [2:0];
    wire [2:0] selectedArray;    
    
    BcdAccumulator accum(
        .accumulatedBufferData(parsedNumSegments), 
        .selectedArray, .curDigit,
        .clk, .enb(enableAccumulator), .rst 
    );
    
    typedef enum logic[5:0] {
        StartNum, 
        IntParse,
        StartDecimal, // only for validation
        DecimalParse,
        StartExponent,
        ExponentParse,
        Error
    } state_t;
    state_t curState;
    state_t nextState;
    
    //next state logic!
    always_comb begin
        import Bcd::*;
        case(curState)
            StartNum: case(curDigit)
                zero:    nextState = StartDecimal; //technically 0e6 is a valid JSON number.  0.1e6 isn't
                exp, period, plus, error: nextState = Error;
                default: 
            endcase
            
            IntParse: case(curDigit)
                period:  nextState = DecimalParse;
                exp:     nextState = startExponent;
                plus, minus, error: nextState = Error;
                default: nextState = IntParse;
            endcase

            StartDecimal: nextState = (curDigit == period) ? DecimalParse : Error;
            default: nextState = Error;
        endcase
    end

    always_ff @( clk ) begin
        if(rst) begin
            curState <= StartNum;
            numSign <= '1;
            exponentSign <= '1;
        end
        if (curState == StartNum && curDigit == minus) numSign = '0;
        if (curState == StartExp && curDigit == minus) numSign = '0;

    end
    
    
    
endmodule
