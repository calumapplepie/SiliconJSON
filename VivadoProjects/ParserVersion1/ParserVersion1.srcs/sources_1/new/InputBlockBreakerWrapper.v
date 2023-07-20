module InputBlockBreakerWrapper(input wire [31:0] curCharBlock , wire clk, rst, enableIn,
        output wire enableOut, wire[7:0] curChar);
        
        InputBlockBreaker BREAKY (curCharBlock, clk, rst,enableIn, enableOut, curChar);
        
endmodule