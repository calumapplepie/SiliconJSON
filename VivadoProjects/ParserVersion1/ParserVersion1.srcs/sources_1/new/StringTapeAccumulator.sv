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
        output TapeIndex startIndex,
        input clk, rst, enable
    );

typedef logic [31:0] StringLength;
StringLength strLen;
TapeIndex curIndex, editIndex, addressA, addressB;
logic [1:0] cyclesDisabled;
UTF8_Char byteA, byteB;



TapeBlockRam #(.WORDSIZE(8),.NUMWORDS(StringTapeLength)) ram (
    .clk(clk), .ena('1), .enb('1), 
    .wea(enable || cyclesDisabled != 3), .web(!enable && cyclesDisabled != 3), // we gotta write 5 bytes after string ends
    .addra(addressA), .addrb(addressB),
    .dia(byteA), .dib(byteB)
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
    end else begin
        case(cyclesDisabled)
            0 : begin
                addressA = curIndex;
                byteA = '0;
                addressB = editIndex;
                byteB = {strLen[ 7: 0]}; end
            1 : begin
                addressA = editIndex + 1;
                byteA = {strLen[15: 8]};
                addressB = editIndex + 2;
                byteB = {strLen[23:16]};
            end
            2 : begin
                addressA = editIndex + 1; //repeat to avoid problems
                byteA = {strLen[15: 8]};
                addressB = editIndex + 3;
                byteB =  {strLen[31:24]};
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
        editIndex <= startIndex;
        curIndex <= curIndex + 1;
        strLen <= strLen +1;
    end else begin
        if(cyclesDisabled < 3)begin
            cyclesDisabled <= cyclesDisabled +1;
        end
        case (cyclesDisabled)
            0: curIndex <= curIndex +1;
            1: startIndex <= curIndex;
            2: begin
                curIndex <= curIndex + 4;
                strLen <= 0;
            end
        endcase
        
        
    end
end

    



endmodule
