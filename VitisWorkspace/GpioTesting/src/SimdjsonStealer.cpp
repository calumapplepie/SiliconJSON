#include "SimdjsonStealer.h"
#include "ConfigParam.h"

using namespace simdjson;

dom::parser jsonParser;
dom::document doc;

void init_simdjson(){
	doc.allocate(STRING_TAPE_LEN+LAYOUT_TAPE_LEN);
}

void parse_simdjson(char* inputChars){
	// NOTE: will trigger a reallocation AND require a strlen() evaulation
	// OPTIMIZE BEFORE BENCHMARKING
	jsonParser.parse_into_document(doc, inputChars, strlen(inputChars));
}

int verify(char* stringTape, uint64_t* layoutTape){
	// code stolen almost verbatim from simdjson.h
		uint32_t string_length;
		uint32_t string_buf_pos =0;
		size_t tape_idx = 0;
		uint64_t tape_val = doc.tape[tape_idx];
		// tape_idx++;

		int retval = 0;

		// get length of array (yes we trust this data)
		size_t how_many = 0;
		how_many = size_t(tape_val & internal::JSON_VALUE_MASK);

		if(how_many > LAYOUT_TAPE_LEN){
			return 999;
		}

		for (; tape_idx < how_many; tape_idx++) {
			uint64_t curLayoutElement = doc.tape[tape_idx];
			if(curLayoutElement != layoutTape[tape_idx]){
				retval++;
				printf("Mismatch at %d: expected %x, got %x", tape_idx, curLayoutElement, layoutTape[tape_idx]);
			}

			// limit string tape overflow severity
			if(string_buf_pos > STRING_TAPE_LEN){
				return 9999;
			}

			// check string tape
			const char elementType = uint8_t(curLayoutElement >> 56);
			if (elementType == '"'){
				// grab the payload
				const uint64_t stringPos = curLayoutElement & 0x00FFFFFF;
				// now we get to some stuff I took from dump_raw_json again
				// but not quite, remember we still want hex
				std::memcpy(&string_length, doc.string_buf.get() + stringPos, sizeof(uint32_t));

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
						retval++;
					}

				}

			}

		}
	return retval;
}
