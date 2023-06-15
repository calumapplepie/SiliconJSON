`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2023 06:05:57 PM
// Design Name: 
// Module Name: corePkg
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

// global include: added to all files
// reconsider that.  also, lets look at making these classes
typedef logic [7:0] UTF8_Char;
typedef logic [63:0] JsonTapeElement;
typedef logic [55:0] TapeIndex;

parameter int StringTapeLength = 32;
parameter int StructTapeLength = 32;

package CharClassification;
    typedef enum logic [3:0] {braceOpen, braceClose, bracketOpen, bracketClose, 
                                quote, colon, comma, minusSign, backslash,
                                whitespace, numeric, controlChar, asciiAlphabetical, 
                                UTF_8, noType} JsonCharType;
    
    function JsonCharType classifyChar (UTF8_Char in);
        casez(in)
            "{" : return braceOpen;
            "}" : return braceClose;
            "[" : return bracketOpen;
            "]" : return bracketClose;
            "\"": return quote;
            ":" : return colon;
            "," : return comma;
            "\\": return backslash;
            "-" : return minusSign;

            " ","\t", 8'h0A, 8'h0D : return whitespace;
            // using do-not-care values to make matching easier
            8'b00110???, 8'b0011100? : return numeric;
            // permitted whitespace already grabbed
            8'b000?????, 8'h7F: return controlChar;
            8'b0??????? : return asciiAlphabetical;

            // do not yet play with unicode
            default: return noType;
        endcase

    endfunction

endpackage
import CharClassification::JsonCharType;

package ElementClassification;
    typedef enum logic [3:0] {objOpen, objClose, arrayOpen, arrayClose,
                                str, number, jsonTrue, jsonFalse, jsonNull, noType} JsonElementType;

    function JsonElementType charToElementType(JsonCharType charType);
        import CharClassification::*;
        case (charType)
            braceOpen   : return objOpen;
            braceClose  : return objClose;
            bracketOpen : return arrayOpen;
            bracketClose: return arrayClose;
            quote       : return str;
            // others are special
            default     : return ElementClassification::noType;
        endcase
    endfunction
    

endpackage

import ElementClassification::JsonElementType;
