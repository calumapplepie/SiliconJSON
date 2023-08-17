#ifndef JSONDOC_H_
#define JSONDOC_H_ 1

#include <string>

class JsonDoc {
public:
	int   getUnparsedLen();
	char* getUnparsedBuffer();


private:
	std::string unparsed;
};
#endif /* JSONDOC_H_ */

