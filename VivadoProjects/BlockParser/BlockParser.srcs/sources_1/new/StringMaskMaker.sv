module StringMaskMaker import Block::*; (
        input clk, rst, enb, 
        input TextBlock chars, 
        output ScannedCharBlock scannedChars);
    BitBlock backslashes, quotes, escapedChars, stringChars;
    
    logic prev_in_string, next_in_string;
    logic prev_escaped,   next_escaped;
    
    always_comb begin
        scannedChars = new(backslashes, quotes, escapedChars, stringChars);
    end
    
    always_ff@(posedge clk) begin
        if(rst)begin
            prev_in_string <= '0;
            prev_escaped   <= '0;
        end else if(enb) begin
            prev_in_string <= next_in_string;
            prev_escaped <= next_escaped;
        end
    end
    
    QuoteFinder classifer       (.chars, .quotes, .backslashes);
    EscapedCharFinder escapee   (.backslashes, .prev_escaped, .escapedChars, .next_escaped);
    
    
    
endmodule