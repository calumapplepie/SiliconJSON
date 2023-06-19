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

    assign curDigit = Bcd::charToBcd(curChar);
    assign enableAccumulator = curDigit <= 4'd9;

    logic numSign, exponentSign;
    logic [63:0] parsedNumSegments [2:0];
    logic [2:0] selectedArray;    
    
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
        // note: comma and whitespace handling in main FSM
        case(curState)
            StartNum: case(curDigit)
                zero:    nextState = StartDecimal; //technically 0e6 is a valid JSON number.  0.1e6 isn't
                exp, period, plus, error: nextState = Error;
                default: nextState = IntParse;
            endcase
            
            IntParse: case(curDigit)
                period:             nextState = DecimalParse;
                exp:                nextState = StartExponent;
                plus, minus, error: nextState = Error;
                default:            nextState = IntParse;
            endcase

            // special state for when we go straight here from StartNum
            StartDecimal: nextState = (curDigit == period) ? DecimalParse : Error;

            DecimalParse: case(curDigit)
                plus, minus, period, error: nextState = Error;
                exp:                        nextState = StartExponent;
                default:                    nextState = DecimalParse;
            endcase

            StartExponent: nextState = (curDigit == error || curDigit == period || curDigit == exp) ? Error : ExponentParse;
            ExponentParse: case(curDigit)
                plus, minus, period, error, exp: nextState = Error;
                default: nextState = ExponentParse;
            endcase

            default: nextState = Error;
        endcase
    end
    
    always_comb begin
        case(curState)
            StartNum, IntParse          : selectedArray = 3'b001;
            StartDecimal, DecimalParse  : selectedArray = 3'b010;
            StartExponent, ExponentParse: selectedArray = 3'b100;
            default                     : selectedArray = 3'b000;         
        endcase
    end
    

    always_ff @( clk ) begin
        if(rst) begin
            curState <= StartNum;
            numSign <= '1;
            exponentSign <= '1;
        end
        if (enb) begin
            curState <= nextState;
            if (curState == StartNum      && curDigit == Bcd::minus) numSign = '0;
            if (curState == StartExponent && curDigit == Bcd::minus) numSign = '0;        
        end
        

    end
    
    
    
endmodule
