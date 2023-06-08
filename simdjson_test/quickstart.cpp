#include <iostream>
#include "simdjson.h"
#include <filesystem>
#include <fstream>

using namespace simdjson;

// Config Parameters

const std::string target_file_dir =  "../JsonTestFiles/";
#define INCLUDE_LINE_BREAKS 1

// Rest of the code should work without modifications

void simdjson::dom::ScrewYouIWantTheTape(
		const dom::element toStealFrom, std::ostream &structureTape, std::ostream &stringTape
	){
	// sneak in and steal the document
	auto document = toStealFrom.tape.doc;
	
	// code stolen almost verbatim from simdjson.h
	uint32_t string_length;
  	size_t tape_idx = 0;
 	uint64_t tape_val = document->tape[tape_idx];
 	uint8_t type = uint8_t(tape_val >> 56);
	// tape_idx++;

	// get length of array (yes we trust this data)
  	size_t how_many = 0;
  	if (type == 'r') {
    		how_many = size_t(tape_val & internal::JSON_VALUE_MASK);
  	}
	else{
		std::cout << "wtf you had one job! gimme a valid json document";
		std::abort();
	}
	
	// now write the tape out to a string
	for (; tape_idx < how_many; tape_idx++) {
		const uint64_t curElement =  document->tape[tape_idx];
		structureTape << std::hex << curElement;

		#ifdef INCLUDE_LINE_BREAKS 
			structureTape <<std::endl;
		#endif

		// check if string element
		const char elementType = curElement >> 56;
		if (elementType == '"'){
			// grab the payload
			const uint64_t stringPos = curElement & 0x00FFFFFF;
			// now we get to some stuff I took from dump_raw_json again
			// but not quite, remember we still want hex
			uint32_t string_length;
			std::memcpy(&string_length, document->string_buf.get() + stringPos, sizeof(uint32_t));

			// having done that nifty trick, we now go back to my code
			// we need to include both the null ending byte and the size bytes.
			// the only reason we don't just print out the whole tape... is because...
			// wait they probably store an index to the last tape element somewhere...
			for(uint32_t i = stringPos; i < stringPos + string_length + 5; i++){
				stringTape << std::hex << document->string_buf[i];
			}
			
			

		}
	}

}

int main(void) {
    dom::parser parser;
	std::filesystem::path dir{target_file_dir};
	
	for (auto const& file : std::filesystem::directory_iterator{dir}){
		if(!file.is_regular_file()){
			std::cout << "please ensure directory is only standard files, only a flat structure is supported";
			std::abort();
		}
		if(file.path().extension() != ".json"){
			// ignore, its not a target
			continue;
		}
    	dom::element json = parser.load(file.path().string());

		auto hexPathStruct = file.path();
		hexPathStruct.replace_extension("struct.hex");
		auto hexPathString = file.path();
		hexPathString.replace_extension("string.hex");

		std::ofstream hexOutStruct{hexPathStruct, std::ios_base::trunc} ;
		std::ofstream hexOutString{hexPathString, std::ios_base::trunc} ;

    	dom::ScrewYouIWantTheTape(json, hexOutStruct, hexOutString);
	}
	
    //json.dump_raw_tape(std::cout);
}