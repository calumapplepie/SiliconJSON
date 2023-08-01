`timescale 1ns / 1ps


module NestingObjectTracker import Core::CharType, Core::comma, ParserPkg::*; (
        input clk, rst, enb,
        input ParserState curState, input CharType curCharType,
        output logic inArray, prevArrayStatus, atDocRoot,
        output logic [23:0] keyValuePairsSoFar
    );
    
    logic [17:0] lastObjKeyValuePairs;
    logic [16:0] nextKeyValuePairs;
    logic [9:0] curDepth;
    
    BlockRamStack stack (
        .clk, .enb, .rst, 
        .pushEnable(curState == StartObject || curState == StartArray), 
        .popTrigger(curState == EndObject   || curState == EndArray),  
        .popData(lastObjKeyValuePairs), .pushData({inArray, keyValuePairsSoFar[16:0]}),
        .curDepth
    );
    
    // zero excess bits
    assign keyValuePairsSoFar[23:17] = '0;
    
    // our previous array status (needed externally, sometimes)
    assign prevArrayStatus = lastObjKeyValuePairs[17];
    
    // if we're at the root of the documet
    assign atDocRoot = (curDepth == 1) && (curState == EndObject);
        
     // key-value pair logic
    always_comb begin
        // default to not changing
        nextKeyValuePairs = keyValuePairsSoFar;
        // we assume nobody goes over 2^16 key value pairs with our parser
        // that saves us a lot of energy
        case(curState)
            StartKey    : nextKeyValuePairs = keyValuePairsSoFar+1;
            StartObject : nextKeyValuePairs = '0;
            StartArray  : nextKeyValuePairs = 17'd1;
            EndObject, EndArray   : nextKeyValuePairs = lastObjKeyValuePairs[16:0];
        endcase
        // handle the array member counting
        if(curCharType == comma && !(curState inside {ReadString, StartString, EndArray}) && inArray)
            nextKeyValuePairs += 1;
        // On the cycle after array exit, inArray is true, and we'll likely run into a comma.
        // if we're in an object now, we can't increment keyValuePairs; if we're in an array, we must
        if(curCharType == comma && curState inside {EndArray, EndObject} && prevArrayStatus)
            nextKeyValuePairs += 1;
    end
    
    always_ff @(posedge clk) begin
        if(rst)       keyValuePairsSoFar[16:0] <= '0;
        else if(enb)  keyValuePairsSoFar[16:0] <= nextKeyValuePairs; 
    end
        
    // inArray logic
    always_ff @(posedge clk) begin
        if(rst) inArray <= '0;
        else if (enb) case(curState)
            StartObject           : inArray <= '0;
            StartArray            : inArray <= '1;
            EndObject, EndArray   : inArray <= prevArrayStatus;
        endcase
    end
    
endmodule
