`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2023 05:16:29 PM
// Design Name: 
// Module Name: StringTapeAccumulator
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


module StringTapeAccumulator
    import Core::UTF8_Char, Core::TapeIndex, Core::StringTapeLength;
    (
        input UTF8_Char nextStringByte,
        input characterEscaped,
        output TapeIndex startIndex,
        input clk, rst, enable,
        output hash
    );

typedef logic [23:0] StringLength;
StringLength strLen;
TapeIndex curIndex, addressA, addressB;
logic [1:0] cyclesDisabled;
UTF8_Char byteA, byteB;



TapeBlockRam #(.WORDSIZE(8),.NUMWORDS(StringTapeLength), .ADDRWIDTH(14)) ram (
    .clk(clk), .ena('1), .enb('1), 
    .wea(enable || ! cyclesDisabled[1]), .web(enable || !cyclesDisabled[1]), // we gotta write 5 bytes after string ends
    .addra(addressA), .addrb(addressB),
    .dia(byteA), .dib(byteB), .hash(hash)
);

always_comb begin
    // setting these to X might make my circuit more efficent (if vivado is cool),
    // and should show me any bugs nice and clearly
    byteA = 'x;
    byteB = 'x;
    addressA = 'x;
    addressB = 'x;
    if(enable) begin
        byteA = nextStringByte;
        addressA = curIndex;
        //enabling the second write at all times *might* worsen power consumption.  more study needed
        // however, doing this enables a 2-cycle post-write period; which is needed for minified empty strings 
        addressB = startIndex + 3;
        byteB =  '0; // we don't support a full 32 bit string
    end else begin
        case(cyclesDisabled)
            0 : begin
                addressA = curIndex;
                byteA = '0;
                addressB = startIndex + 2;
                byteB = {strLen[23:16]};
            end    
            1 : begin
                addressA = startIndex + 1;
                byteA = {strLen[15: 8]};
                
                addressB = startIndex;
                byteB = {strLen[ 7: 0]};
            end
        endcase;
    end
end


// could use optimization i'm sure
always_ff @(posedge clk ) begin
    if(rst) begin
        //foreach(tape[i]) tape[i] = '0;
        curIndex <= 4'd4;
        cyclesDisabled <= '1;
        startIndex <= '0;
        strLen <= 0;
    end else if (enable) begin
        cyclesDisabled <= '0;
        // only write quotes or backslashes if theyre escaped
        if(!((nextStringByte=="\"") || (nextStringByte=="\\")) || characterEscaped ) begin
            curIndex <= curIndex + 1;
            strLen <= strLen +1;
        end
    end else begin
        if(cyclesDisabled < 3)begin
            cyclesDisabled <= cyclesDisabled +1;
        end
        case (cyclesDisabled)
            0: curIndex <= curIndex +1;
            1: begin
                   startIndex <= curIndex;
                   curIndex <= curIndex + 4;
                   strLen <= 0;
               end
        endcase
        
        
    end
end

    



endmodule
