module EscapedCharFinder import Block::*; (
    input BitBlock backslashes, input logic prev_escaped,
    output BitBlock escapedChars, output logic next_escaped);
// based on find_escaped_branchless in json_string_scanner.h
// TODO: see if there is a way to do this without an adder.  I want to say yes.
always_comb begin
    automatic BitBlock backslash, escaped_chars;
    
    // pretend that the first character isn't a backslash if it was escaped by previous block
    backslash = backslashes;
    backslash[0] = backslash[0] & !prev_escaped;
    escaped_chars = {backslash[BlockSizeBits-2:0], prev_escaped}; // they call this follows_escape
end


endmodule