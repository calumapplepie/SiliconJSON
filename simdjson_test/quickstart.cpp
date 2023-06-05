#include <iostream>
#include "simdjson.h"
using namespace simdjson;

#define TARGET_FILE_NAME "twitter.json"

void simdjson::dom::ScrewYouIWantTheTape(dom::element toStealFrom){
	auto tape = toStealFrom.tape.doc;
	
	// code stolen almost verbatim from simdjson.h
	uint32_t string_length;
  	size_t tape_idx = 0;
 	uint64_t tape_val = tape->tape[tape_idx];
 	uint8_t type = uint8_t(tape_val >> 56);
	// tape_idx++;
  	size_t how_many = 0;
  	if (type == 'r') {
    		how_many = size_t(tape_val & internal::JSON_VALUE_MASK);
  	}
	else{
		std::cout << "wtf you had one job! gimme a valid json document";
		std::abort();
	}
	
	// now write the string
	for (; tape_idx < how_many; tape_idx++) {
		std::cout << std::hex << tape->tape[tape_idx];
	}

}

int main(void) {
    dom::parser parser;
    dom::element json = parser.load(TARGET_FILE_NAME);
    dom::ScrewYouIWantTheTape(json);
    //json.dump_raw_tape(std::cout);
}