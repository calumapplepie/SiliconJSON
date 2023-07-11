#include <iostream>
#include "simdjson.h"
#include <filesystem>
#include <fstream>
#include <set>

using namespace simdjson;

// Config Parameters

const std::string target_file_dir =  "../JsonTestFiles/";
#undef  INCLUDE_LINE_BREAKS  	// Include some line breaks in strategic locations
#undef  INCLUDE_COMMAS 			// Seperate words with commas and spaces
#define	FORMAT_SYSV_LITERALS 1  // Format as a list of system-verilog literals 
#undef  FORMAT_C_LITERALS       // Format as a list of C literals
#undef  FORMAT_READMEMH 		// Format as a $readmemh() compatable file

// Rest of the code should work without modifications

#ifdef FORMAT_READMEMH
#define INCLUDE_LINE_BREAKS 1
#endif
#ifdef FORMAT_SYSV_LITERALS
#define INCLUDE_COMMAS 		1
#endif
#ifdef FORMAT_C_LITERALS
#define INCLUDE_COMMAS		1
#endif


namespace simdjson {
namespace dom {
	void ScrewYouIWantTheTape(
			const dom::element toStealFrom, std::ostream &structureTape, std::ostream &stringTape
		){
		// sneak in and steal the document
		auto document = toStealFrom.tape.doc;
		
		// code stolen almost verbatim from simdjson.h
		uint32_t string_length;
		uint32_t string_buf_pos =0;
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
			#ifdef FORMAT_SYSV_LITERALS
					structureTape << "64'h";
			#endif
			#ifdef FORMAT_C_LITERALS
					structureTape << "0x";
			#endif

			const uint64_t curElement =  document->tape[tape_idx];
			structureTape << std::hex << curElement;

			#ifdef INCLUDE_COMMAS
				structureTape << ", ";
			#endif
			#ifdef INCLUDE_LINE_BREAKS 
				structureTape <<std::endl;
			#endif

			// check if string element
			const char elementType = uint8_t(curElement >> 56);
			if (elementType == '"'){
				// grab the payload
				const uint64_t stringPos = curElement & 0x00FFFFFF;
				// now we get to some stuff I took from dump_raw_json again
				// but not quite, remember we still want hex
				std::memcpy(&string_length, document->string_buf.get() + stringPos, sizeof(uint32_t));

				// having done that nifty trick, we now go back to my code
				// we need to include both the null ending byte and the size bytes.
				// the only reason we don't just print out the whole tape... is because...
				// as far as i can tell, they throw away the length of the buffer when
				// they're done parsing.
				if(string_buf_pos != stringPos){
					std::cout << "ERROR! String buffer position not as expected" <<std::endl;
				}

				for(string_buf_pos = stringPos; string_buf_pos < stringPos + string_length + 5; string_buf_pos++){
					#ifdef FORMAT_SYSV_LITERALS
					stringTape << "8'h";
					#endif
					#ifdef FORMAT_C_LITERALS
					stringTape << "0x";
					#endif


					// that little plus promotes it to a real number!
					stringTape << std::hex << +(document->string_buf[string_buf_pos]);
					
					#ifdef INCLUDE_COMMAS
					stringTape << ", ";
					#endif
					#ifdef FORMAT_READMEMH
					// the verilog memory read function we use requires each number to be whitespace-separated
					stringTape << std::endl;
					#endif
				}
				
				#ifdef INCLUDE_LINE_BREAKS 
				#ifndef FORMAT_READMEMH
					stringTape <<std::endl;
				#endif
				#endif

			}
		}

	}
}}

int main(void) {
    dom::parser parser;
	std::filesystem::path dir{target_file_dir};
	std::set<std::string> baseNamesStorage;
	
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
		baseNamesStorage.insert(file.path().stem().string());

		auto hexPathStruct = file.path();
		hexPathStruct.replace_extension("struct.hex");
		auto hexPathString = file.path();
		hexPathString.replace_extension("string.hex");
		auto minifiedPath  = file.path();
		minifiedPath.replace_extension(".minjson");

		std::ofstream hexOutStruct{hexPathStruct, std::ios_base::trunc} ;
		std::ofstream hexOutString{hexPathString, std::ios_base::trunc} ;
		std::ofstream minifiedOut {minifiedPath,  std::ios_base::trunc} ;

		minifiedOut << minify(json) << std::endl;

    	dom::ScrewYouIWantTheTape(json, hexOutStruct, hexOutString);

		hexOutString.close();
		hexOutStruct.close();
		minifiedOut.close();
		
	}

	std::ofstream basenamesOut{dir / "basenames.txt", std::ios_base::trunc};
	for (auto const& str : baseNamesStorage){
		basenamesOut << str << std::endl;
	}
	basenamesOut.close();
    //json.dump_raw_tape(std::cout);
}