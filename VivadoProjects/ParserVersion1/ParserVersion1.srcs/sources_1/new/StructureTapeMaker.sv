`timescale 1ns / 1ps

module StructureTapeMaker import Core::*;(
        input ElementType elementType, input TapeIndex stringTapeIndex,
        output JsonTapeElement nextElement
    );
    logic [55:0] payload;
    wire [7:0]  prefix;
    
    assign nextElement = {prefix, payload};
    
    // we literally only handle strings right now
    assign prefix = Core::elementTypeToTapeChar(elementType);
    
    always_comb begin
        case (elementType)
            str :                           payload = stringTapeIndex;
            objOpen, objClose:              payload = '0;
            arrayOpen, arrayClose:          payload = '0;
            trueVal, falseVal, nullVal:     payload = '0;
            unsignedInt, signedInt, double: payload = '0; 
            default: payload = 56'hBADBADBADBADD;
        endcase
    end
endmodule
