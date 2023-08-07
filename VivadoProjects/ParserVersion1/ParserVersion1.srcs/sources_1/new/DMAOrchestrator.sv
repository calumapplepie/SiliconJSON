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
    typedef enum {START, READ_INPUT, PARSE, OUTPUT, ERROR} state_t;
    state_t curState, nextState;
    
    always_ff @(posedge clk)begin
        if(rst) curState <= START;
        else if (enb) curState <= nextState;
    end
    
    always_comb begin
        case(curState) 
            START:      nextState = READ_INPUT;
            READ_INPUT: nextState = inputDone     ? PARSE   : READ_INPUT;
            PARSE:      nextState = parserDone    ? OUTPUT  : PARSE;
            OUTPUT:     nextState = outputDone    ? START   : OUTPUT;
            default:    nextState = ERROR;
        endcase
        
    end
    
    always_comb begin
        if(curState == START) begin // just reset 'em all here
            {inputRst,parserRst,outputRst} = '1; 
        end
        else {inputRst,parserRst,outputRst} = '0;
        
        // set enables to 0, then raise them as desired
         {inputEnable, parserEnable, outputEnable} ='0;
         case(curState) 
            READ_INPUT: inputEnable     = '1;
            PARSE:      parserEnable    = '1;
            OUTPUT:     outputEnable    = '1;
            // no need for default, all outputs always driven
         endcase
    
    end
endmodule
