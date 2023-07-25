module StringMaskMaker import Block::*; (input BitBlock quotes, input logic prev_in_string, output BitBlock stringChars, output logic next_in_string);
    // they call this the "prefix xor".  it flips on the bits in the string, and off bits outside of it.
    genvar i;
    for(i = 0; i < BlockSizeBits; i++) begin
        assign stringChars[i] =  ^quotes[i:0] ^ prev_in_string;
    end
    assign next_in_string = stringChars[BlockSizeBits-1];
    
    
endmodule 