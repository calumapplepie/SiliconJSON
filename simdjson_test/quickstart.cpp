#include <iostream>
#include "simdjson.h"
using namespace simdjson;

// Config Parameters

#define TARGET_FILE_NAME "../JsonTestFiles/001_most_simple_test.json"
#define INCLUDE_LINE_BREAKS 1

// Rest of the code should work without modifications

void simdjson::dom::ScrewYouIWantTheTape(dom::element toStealFrom, std::ostream outputHerePlz){
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
		outputHerePlz << std::hex << document->tape[tape_idx];

		#ifdef INCLUDE_LINE_BREAKS 
			outputHerePlz <<std::endl;
		#endif 
		
	}

}

int main(void) {
    dom::parser parser;
    dom::element json = parser.load(TARGET_FILE_NAME );
    dom::ScrewYouIWantTheTape(json, std::cout);
    //json.dump_raw_tape(std::cout);
}