#ifndef JSONDOC_H_
#define JSONDOC_H_ 1

#include <string>

class JsonDoc {
public:
	const int   getUnparsedLen(){return unparsed.length();};
	const char* getUnparsedBuffer(){return unparsed.c_str();};


private:
	std::string unparsed;
};
#endif /* JSONDOC_H_ */

