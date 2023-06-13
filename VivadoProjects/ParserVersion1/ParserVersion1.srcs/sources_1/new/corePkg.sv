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
                                quote, colon, comma, minusSign,
                                whitespace, numeric, controlChar, asciiAlphabetical, 
                                UTF_8, noType} CharType;
    
    function CharType classifyChar (UTF8_Char in);
        case(in)
            "{" : return braceOpen;
            "}" : return braceClose;
            "[" : return bracketOpen;
            "]" : return bracketClose;
            "\"": return quote;
            ":" : return colon;
            "," : return comma;
            "\\": return backslash;
            "-" : return minusSign;

            " ","\t", 8'0A, 8'0D : return whitespace;
            // using do-not-care values to make matching easier
            8'b00110???, 8'b0011100? : return numeric;
            // permitted whitespace already grabbed
            8'b000?????, 8'h7F: return controlChar;
            8'b0??????? : return asciiAlphabetical;

            // do not yet play with unicode
            default: return notype;
        endcase

    endfunction

endpackage
typedef CharClassification::CharType JsonCharType;

package ElementClassification;
    typedef enum logic [3:0] {objOpen, objClose, arrayOpen, arrayClose, 
                                str, number, true, false, null, noType
                                } ElementType;
    function ElementType charToElementType(JsonCharType charType)
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
    

endpackage

typedef ElementClassification::ElementType JsonElementType;
