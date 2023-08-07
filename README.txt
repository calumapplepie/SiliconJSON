Hello and welcome to my 2023 summer reasearch project!
(sorry if there is a shortage of docs I keep forgetting to add the prep to let others read this)
(also this all needs a proofread)

the goal: make a JSON parser that runs on an fpga (specifically, a Zedboard), which works asynchronously from
the CPU, and reuses the tape format of simdjson so that I a) don't need to make my own and b) get free library support

Our directories: (not in tree format because I couldn't bother to check what that is)
|
|\_ JsonTestFiles: the test files we use for JSON processing.  Based some off my own mind, and some off json.org
|\_ simdjson_test: a C++ program built off the quickstart for simdjson that steals the tape and lets me use it, by filling JsonTestFiles with .hex files with the needed bits
|\_ Packages:  I have no idea when or why this folder wound up in my repo
|\_ VitisWorkspace: where code for the CPU or Processing System of the Zedboard lives: handled by Xylinx Vitis
|\_ VivadoProjects: Projects for Xylinx Vivado
|  |\_ TestZedboard: where some tests for messing around with the Zedboard are.  may be removed by Future Calum
|  |\_ ParserVersion1: a parser that is based on an FSM, parsing one letter at a time.  Now with a block design integrating it into the PS!
|  |\_ BlockPareser:   a parser built on the same principles as simdjson.  WIP.


Some Design notes:
- All resets are synchronous
- Floats currently unsupported
- Integers > 2^63 unsupported
- Strings longer than 2^23 unsupported (duh)
- While classes *could* make some interfaces nicer code-wise, I don't think they'd behave in hardware

Todo: spiel more
Todo: document how to remake Vivado projects from committed git source
Todo: empty strings (need tests too)
Todo: mark up files with license info (CERN-OHL-S-V2+) and authorship credits (all me, except for TapeBlockRam, sort of) [1]
Todo: Make this REUSE compliant, rather than just tossing in a LICENSE.txt


[:1] note: licenseing of said TapeBlockRam file is a bit legally complicated; me saying "hey this is under the GPL now"
might not fly considering that there isn't actually any formal license grant to it on AMD's website.  However,
you can't copyright facts, and my creative expression of that algorithm is a lot prettier than theirs.
