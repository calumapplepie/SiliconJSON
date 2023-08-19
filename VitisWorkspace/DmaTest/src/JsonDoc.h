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
	
	// make the relevant dma driver bits friends
	// do we wrap that in a class? nah.... not rn, i'm tired
	friend void setupDocSendBuf(JsonDoc &doc, int channel);
	friend void setupDocRecvBuf(JsonDoc &doc, int channel);

};

#endif /* JSONDOC_H_ */

