`timescale 1ns / 1ps

package Core;
    typedef logic [7:0]  UTF8_Char;
    typedef logic [63:0] JsonTapeElement;
    typedef logic [55:0] TapeIndex;
    
    parameter int MaxInputLength   = 4096;
    parameter int StringTapeLength = 4096; // a full block ram
    parameter int StructTapeLength = 512;  // max value without expanding into 4 block rams
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
            numeric     : return signedInt;
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
            "0" : return "\0"; // dunno if this is actually standard
            "\\": return "\\";
            "\"": return "\"";
            "/" : return "/" ;
            "b" : return 8'h8;
            "f" : return 8'hC;
            "n" : return 8'hA;
            "t" : return 8'h9;
            "r" : return 8'hD;
            default: return 8'h0;
        endcase
    endfunction
    
endpackage
