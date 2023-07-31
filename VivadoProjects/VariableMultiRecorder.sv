module VariableMultiRecorder #(BITWIDTH = 8, type WriteType) (
        input [BITWIDTH-1:0][3:0] inputVals, input [3:0] valids, input clk, rst, enb, 
        output WriteType ramOut
    );

    logic [$bits(ramOut.addra)-1:0] baseAddress;
    BitmapOneCounter (.in(valids), .numOnes)

    always_comb begin
        ramOut.dia[BITWIDTH-1:0] = inputVals[0];
        ramOut.dia[BITWIDTH*2-1:BITWIDTH] = inputVals[1];
        ramOut.dib[BITWIDTH-1:0] = inputVals[2];
        ramOut.dib[BITWIDTH*2-1:BITWIDTH] = inputVals[3];
        ramOut.addra = baseAddress;
        ramOut.addrb = baseAddress + 2;
        ramOut.ena = enb && (&valids[1:0]); 
        ramOut.enb = enb && (&valids[3:2]); // disable if no write occurs to save some power (i think)
        ramOut.wea = '1; ramOut.web = '1;
    end

    always_ff @(posedge clk)begin
        if(rst) baseAddress <= '0;
        else if(enb) begin
            baseAddress += numOnes; // increase by however many valid vals we just wrote
        end
    end


endmodule
