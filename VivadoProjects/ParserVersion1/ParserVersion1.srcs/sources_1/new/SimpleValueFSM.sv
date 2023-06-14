`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/14/2023 03:08:51 PM
// Design Name: 
// Module Name: SimpleValueFSM
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

// not actually an FSM
module SimpleValueFSM import Core::UTF8_Char, Core::ElementType, Core::trueVal, Core::falseVal, Core::nullVal, Core::noType; (
        input UTF8_Char curChar,
        output scanComplete,
        output ElementType scannedElement, 
        input clk, enb, rst
    );
    logic [2:0] bytesRead;
    UTF8_Char [0:4] charsSoFar;
    
    assign scanComplete = scannedElement != noType || bytesRead > 5;
    
    always_comb case(charsSoFar)
           {"true",8'd0} : scannedElement = trueVal;
           "false"    : scannedElement = falseVal;
           {"null",8'd0} : scannedElement = nullVal;
           default: scannedElement = noType;
    endcase
    
    always_ff @(posedge clk) begin
        if(rst || !enb) begin
            bytesRead <= 3'd1;
            charsSoFar <= '0;
            // ensure we have the first byte prepped, in case it starts a simple value
            // fsm won't tell us untill one clock cycle later
            charsSoFar[0] <= curChar;
        end else begin
            charsSoFar[bytesRead] = curChar;
            bytesRead++;
        end 
    end
    
    
endmodule
