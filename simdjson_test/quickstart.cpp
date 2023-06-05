#include <iostream>
#include "simdjson.h"
using namespace simdjson;
std::vector<uint64_t> simdjson::dom::ScrewYouIWantTheTape(dom::element toStealFrom){
	std::cout << toStealFrom.tape.doc->tape[1];
	std::vector<uint64_t> bob;
	bob.push_back(10);
	return bob;
}

int main(void) {
    dom::parser parser;
    dom::element json = parser.load("twitter.json");
    dom::ScrewYouIWantTheTape(json);
    //json.dump_raw_tape(std::cout);
}