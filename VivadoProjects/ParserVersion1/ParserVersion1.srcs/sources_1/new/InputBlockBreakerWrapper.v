module InputBlockBreakerWrapper(input wire [7:0] [0:3] curCharBlock , wire clk, rst, enableIn,
        output wire enableOut, wire[7:0] curChar);
        
        InputBlockBreaker BREAKY ({curCharBlock[0],curCharBlock[1], curCharBlock[2], curCharBlock[3]}, 
                                        clk, rst,enableIn, enableOut, curChar);
        
endmodule