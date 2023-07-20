#include "SimdjsonStealer.h"
#include "ConfigParam.h"

using namespace simdjson;

dom::parser parse;
dom::document doc;

void init(){
	doc.allocate(STRING_TAPE_LENGTH+LAYOUT_TAPE_LENGTH);
}

void parse(char* inputChars){
	// NOTE: will trigger a reallocation AND require a strlen() evaulation
	// OPTIMIZE BEFORE BENCHMARKING
	parse.parseIntoDocument(doc, inputChars, strlen(inputChars));
}

bool verify(char* stringTape, uint64_t* layoutTape){
	// code stolen almost verbatim from simdjson.h
		uint32_t string_length;
		uint32_t string_buf_pos =0;
		size_t tape_idx = 0;
		uint64_t tape_val = toStealFrom.tape[tape_idx];
		// tape_idx++;

		bool retval;

		// get length of array (yes we trust this data)
		size_t how_many = 0;
		how_many = size_t(tape_val & internal::JSON_VALUE_MASK);

		for (; tape_idx < how_many; tape_idx++) {
			uint64_t curLayoutElement = doc.tape[tape_idx];
			if(curLayoutElement != layoutTape[tape_idx]){
				retval = false;
				printf("Mismatch at %d: expected %x, got %x", tape_idx, curLayoutElement, layoutTape[tape_idx]);
			}

			// check string tape
			const char elementType = uint8_t(curElement >> 56);
			if (elementType == '"'){
				// grab the payload
				const uint64_t stringPos = curElement & 0x00FFFFFF;
				// now we get to some stuff I took from dump_raw_json again
				// but not quite, remember we still want hex
				std::memcpy(&string_length, toStealFrom.string_buf.get() + stringPos, sizeof(uint32_t));

				// having done that nifty trick, we now go back to my code
				// we need to include both the null ending byte and the size bytes.
				// the only reason we don't just print out the whole tape... is because...
				// as far as i can tell, they throw away the length of the buffer when
				// they're done parsing.
				if(string_buf_pos != stringPos){
					printf("ERROR! String buffer position not as expected");
				}

				for(string_buf_pos = stringPos; string_buf_pos < stringPos + string_length + 5; string_buf_pos++){
					// that little plus promotes it to a real number!
					char curStringElement = doc.string_buf[string_buf_pos];
					if(curStringElement != stringTape[string_buf_pos]){
						printf("Mismatch at %d: expected %x, got %x", string_buf_pos, curStringElement, stringTape[string_buf_pos]);
					}

				}

			}

		}
}
