`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2023 01:03:21 PM
// Design Name: 
// Module Name: OutputRouter
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


module OutputRouter import Ram::*, Core::InputIndex;(
        input  wire clk, enb, rst,
        output wire done,
        input  wire [3:0] blockSel,

        output StructBlockRamWrite layWrite, output StringBlockRamWrite strWrite,
        input  StructBlockRamRead  layRead,  input  StringBlockRamRead  strRead,
        input  InputIndex layLen, strLen,

        input  wire streamReset, streamReady,
        output wire [63:0] streamData, [3:0] streamDest, 
        output wire streamValid, streamLast
    );

    logic strEnable, strRst, strDone;
    logic layEnable, layRst, layDone;

    // we have string and struct s, they take turns
    logic[63:0] strStreamData,    layStreamData;
    logic       strStreamValid,   layStreamValid;
    logic       strStreamLast,    layStreamLast;

    assign strRst = rst;
    assign layRst = rst;

    // its a little fsm!
    typedef enum {WRITE_STR, WRITE_LAY, DONE, ERROR} state_t;
    state_t curState, nextState;
    
    always_ff @(posedge clk)begin
        if(rst) curState <= WRITE_STR;
        else if (enb) curState <= nextState;
    end
    
    always_comb begin
        case(curState)
            WRITE_STR: nextState = strDone ? WRITE_LAY : WRITE_STR;
            WRITE_LAY: nextState = layDone ? DONE      : WRITE_LAY;
            DONE:      nextState = DONE;// once we're done, we stay done
            default:   nextState = ERROR;
        endcase
    end

    always_comb begin
        streamData  = 'x;
        streamValid = '0;
        streamLast  = 'x;
        strEnable = '0; layEnable = '0;
        done = '0;
        case(curState) 
            WRITE_STR: begin
                streamData  = strStreamData;
                streamValid = strStreamValid;
                streamLast  = strStreamLast;
                streamDest  = blockSel;
                strEnable   = enb;
            end
            WRITE_LAY: begin
                streamData  = layStreamData;
                streamValid = layStreamValid;
                streamLast  = layStreamLast;
                streamDest  = blockSel + 4'd8;
                layEnable   = enb;
            end
            DONE: begin
                done = '1;
            end
        endcase
    end

    AxiStreamReader #(.NUMWORDS(8)) str (
        .clk, .enable(strEnable), .rst(strRst), .done(strDone),
        .ramWrite(strWrite), .ramRead(strRead), 
        .transferLen(strLen),
        .TREADY(streamReady), .TRESET(streamReset),
        .TDATA(strStreamData), .TVALID(strStreamValid), .TLAST(layStreamLast)
    );
    
    AxiStreamReader #(.WORDSIZE(64), .WriteType(StructBlockRamWrite), .ReadType(StructBlockRamRead)) lay (
        .clk, .enable(layEnable), .rst(layRst), .done(layDone),
        .ramWrite(layWrite),  .ramRead(layRead), 
        .transferLen(layLen),
        .TREADY(streamReady), .TRESET(streamReset),
        .TDATA(layStreamData), .TVALID(layStreamValid), .TLAST(layStreamLast)
    );
endmodule
