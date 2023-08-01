`timescale 1ns / 1ps

module OutputBlockMaker(
        input clk, enable, rst, [7:0] curByte,
        output logic [31:0] byteBlock
    );
    logic [1:0] curBlock;
    
    always_ff @(posedge clk) begin 
        case(curBlock)
            0: byteBlock[7:0]   <= curByte;
            1: byteBlock[15:8]  <= curByte;
            2: byteBlock[23:16] <= curByte;
            3: byteBlock[31:24] <= curByte;
        endcase 
    end
        
    always_ff @(posedge clk) begin  
        if(rst) curBlock <= '1;
        else if(enable) begin
            curBlock <= curBlock +1;
        end
        
    end;
    
endmodule
