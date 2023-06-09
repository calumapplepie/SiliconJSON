`timescale 1ns / 1ps

module ElementTypeToTapeType(
    input JsonElementType target,
    output UTF8_Char out
);
    // note: making 'element type' a class would be a more elegant solution
    // reduce namespace collisions, etc.
    // that's a later consideration, lets get this thing working first
    always_comb begin
        case (target)
            root       : out <= "r";
            objOpen    : out <= "{";
            objClose   : out <= "}";
            arrayOpen  : out <= "[";
            arrayClose : out <= "]";
            str        : out <= "\"";
            default    : out <= "\0";
        endcase
    end
endmodule

