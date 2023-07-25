module EscapedCharFinder import Block::*; (
    input BitBlock backslashes, input logic prev_escaped,
    output BitBlock escapedChars, output logic next_escaped);
// based on find_escaped_branchless in json_string_scanner.h 
// TODO: see if there is a way to do this without an adder.  I want to say yes.
// alternatively, add a pile of registers to this so that it can be shoved in a DSP.
// the DSP may be overkill, but we've got a ton of them so making use of them is a plus
always_comb begin
    automatic BitBlock backslash, follows_escape, even_bits, odd_starts, even_seq, invert_mask;
    automatic logic[BlockSizeChars:0] even_seq_raw;
    even_bits = {BlockSizeChars/2{2'b01}};
    
    // pretend that the first character isn't a backslash if it was escaped by previous block
    backslash = backslashes;
    backslash[0] = backslash[0] & !prev_escaped;
    // mark all chars that follow a backslash (ie, all possibly escaped chars) (ignoring sequences)
    follows_escape = backslash << 1 | prev_escaped;
    // mark the starts of escape sequences that lie on odd bits
    odd_starts = backslash & ~even_bits & ~follows_escape;
    // This addition causes each backslash corresponding to an odd sequence to be cleared to zero
    // For each odd sequence, the first bit of the sequence is 1+1, which equals 10, setting the carry and clearing that bit of the sequence
    // they handle the excess carry bits by later anding with follows_escape
    even_seq_raw = odd_starts + backslash;
    
    next_escaped = even_seq_raw[BlockSizeChars];
    
    // the invert mask flips our even_bits in specific places to cause the proper chars to be escaped for even-starting sequences
    invert_mask = even_seq_raw<<1;// discards 2 bits
    escapedChars = (even_bits ^ invert_mask) & follows_escape;
    
    
end


endmodule