`timescale 1ns / 1ps

module ElementTypeToTapeType(
    input JsonElementType target,
    output UTF8_Char output
);
    // note: making 'element type' a class would be a more elegant solution
    // reduce namespace collisions, etc.
    // that's a later consideration, lets get this thing working first
    always_comb begin
        unique case (target)
            root       : output <= "r";
            objOpen    : output <= "{";
            objClose   : output <= "}";
            arrayOpen  : output <= "[";
            arrayClose : output <= "]";
            str        : output <= "\"";
            noType     : output <= "\0";
        endcase
    end
endmodule

