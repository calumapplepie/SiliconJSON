`timescale 1ns / 1ps

module DMAOrchestrator( input logic clk, rst, enb,
    output logic       inputEnable, parserEnable, outputEnable,
    output logic       inputRst,    parserRst,    outputRst,
    input  logic       inputDone,   parserDone,   outputDone,  
    output logic [3:0] inputBlock,  parserBlock,  outputBlock
    );

    // NOTE: currently we keep it stupid simple, stupid
    // design v1: non-parallel FSM
    // will need to revise to make it drive select inputs and run stages in parallel
    typedef enum {START, READ_INPUT, STAGE1, STAGE2, OUTPUT_STR, OUTPUT_LAY, ERROR} state_t;
    state_t curState, nextState;
    
    always_ff @(posedge clk)begin
        if(rst) curState <= START;
        else if (enb) curState <= nextState;
    end
    
    always_comb begin
        case(curState) 
            START:      nextState = READ_INPUT;
            READ_INPUT: nextState = inputDone     ? STAGE1     : READ_INPUT;
            STAGE1:     nextState = stage1Done    ? STAGE2     : STAGE1;
            STAGE2:     nextState = stage2Done    ? OUTPUT_STR : STAGE2;
            OUTPUT_STR: nextState = outputStrDone ? OUTPUT_LAY : OUTPUT_STR;
            OUTPUT_LAY: nextState = outputLayDone ? START      : OUTPUT_LAY;
            default:    nextState = ERROR;
        endcase
        
    end
    
    always_comb begin
        if(curState == START) begin // just reset 'em all here
            {inputRst,stage1Rst,stage2Rst,outputStrRst,outputLayRst} = '1; 
        end
        else {inputRst,stage1Rst,stage2Rst,outputStrRst,outputLayRst} = '0;
        
        // set enables to 0, then raise them as desired
         {inputEnable, stage1Enable, stage2Enable, outputStrEnable, outputLayEnable} ='0;
         case(curState) 
            READ_INPUT: inputEnable     = '1;
            STAGE1:     stage1Enable    = '1;
            STAGE2:     stage2Enable    = '1;
            OUTPUT_STR: outputStrEnable = '1;
            OUTPUT_LAY: outputLayEnable = '1;
            // no need for default, all outputs always driven
         endcase
    
    end
endmodule
