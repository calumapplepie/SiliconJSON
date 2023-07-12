Hello and welcome to my 2023 summer reasearch project!

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
