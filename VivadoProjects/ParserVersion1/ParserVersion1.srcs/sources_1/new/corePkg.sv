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
class JsonCharType;
    typedef enum logic [3:0] {braceOpen, braceClose, bracketOpen, bracketClose, 
                                quote, colon, comma, minusSign,
                                whitespace, numeric, controlChar, asciiAlphabetical, 
                                UTF_8, noType} CharType;
    CharType typeID;
    function new (UTF8_Char in);
        case(in)
            "{" : typeID = braceOpen;
            "}" : typeID = braceClose;
            "[" : typeID = bracketOpen;
            "]" : typeID = bracketClose;
            "\"": typeID = quote;
            ":" : typeID = colon;
            "," : typeID = comma;
            "\\": typeID = backslash;
            "-" : typeID = minusSign;

            " ","\t", 8'0A, 8'0D : typeID = whitespace;
            // using do-not-care values to make matching easier
            8'b00110???, 8'b0011100? : typeID = numeric;
            // permitted whitespace already grabbed
            8'b000?????, 8'h7F: typeID = controlChar;
            8'b0??????? : typeID = asciiAlphabetical;

            // do not yet play with unicode
            default: typeID = notype;
        endcase

    endfunction

endclass


class JsonElementType;
    typedef enum logic [3:0] {objOpen, objClose, arrayOpen, arrayClose, str, number, true, false, null, noType} ElementType;
    ElementType typeID;


endclass
