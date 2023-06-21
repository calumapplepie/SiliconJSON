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

package Core;
    typedef logic [7:0] UTF8_Char;
    typedef logic [63:0] JsonTapeElement;
    typedef logic [55:0] TapeIndex;
    
    parameter int StringTapeLength = 256;
    parameter int StructTapeLength = 32;
    typedef enum logic [3:0] {braceOpen, braceClose, bracketOpen, bracketClose, 
                                quote, colon, comma, minusSign, backslash,
                                whitespace, numeric, controlChar, asciiAlphabetical, 
                                UTF_8, unknown} CharType;
    
    function CharType classifyChar (UTF8_Char in);
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
            default: return unknown;
        endcase
    endfunction

    typedef enum logic [3:0] {objOpen, objClose, arrayOpen, arrayClose, 
                                str, number, trueVal, falseVal, nullVal, 
                                unsignedInt, signedInt, double, noType
                                } ElementType;
    function ElementType charToElementType(CharType charType);
        case (charType)
            braceOpen   : return objOpen;
            braceClose  : return objClose;
            bracketOpen : return arrayOpen;
            bracketClose: return arrayClose;
            quote       : return str;
            // others are special
            default     : return noType;
        endcase
    endfunction
    
    function UTF8_Char elementTypeToTapeChar(ElementType elementType);
        case (elementType)
            objOpen    : return "{";
            objClose   : return "}";
            arrayOpen  : return "[";
            arrayClose : return "]";
            str        : return "\"";
            trueVal    : return "t";
            falseVal   : return "f";
            nullVal    : return "n";
            unsignedInt: return "u";
            signedInt  : return "l";
            double     : return "d";
            default    : return "\0";
        endcase
    endfunction

    function UTF8_Char unescapeCharacter(UTF8_Char escapedChar);
        case(escapedChar) 
            "0" : "\0"; // dunno if this is actually standard
            "\\": "\\";
            "\"": "\"";
            "/" : "/" ;
            "b" : 8'h8;
            "f" : 8'hC;
            "n" : 8'hA;
            "t" : 8'h9;
            "r" : 8'hD;
            default: 8'h0;
        endcase
    endfunction
    

endpackage
