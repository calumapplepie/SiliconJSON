#ifndef JSONDOC_H_
#define JSONDOC_H_ 1

#include <memory>
#include <string>
#include <cstdint>

class JsonDoc {
public:
	JsonDoc(std::string in);

	const int   getUnparsedLen(){return unparsed.length();};
	const char* getUnparsedBuffer(){return unparsed.c_str();};

	// todo: encapsulate these
	void setCharBuffer(uint8_t* chars, uint16_t len){
		str_buf = chars;
		str_buf_len = len;
	};
	void setLayoutBuffer(uint64_t* lay, uint16_t len){
		lay_buf = lay;
		lay_buf_len = len;
	};


private:
	// currently, a doc is inextricably tied with its string
	// for future, make this non-const
	const std::string unparsed;
	// use the same memory buffer storage technique as simdjson
	// it's probably pretty efficent
	std::unique_ptr<uint8_t[]>  str_buf;
	uint16_t str_buf_len;
	std::unique_ptr<uint64_t[]> lay_buf;
	uint16_t lay_buf_len;
};

#endif /* JSONDOC_H_ */

