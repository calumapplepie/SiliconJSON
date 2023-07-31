- Have modules for each stage of parsing
- Read data from PS, stage 1 parse, stage 2 parse, write data into cpu
- Each stage processes it's input out of a block ram and sends the result into a block ram
- We have a little scheduler module that tries to ensure all our stages are full
- Can increase number of instances of each stage to avoid bottlenecks

- Separate validation stage(s)? do no validation? hard to decide

- Stage 1 is straightforward; just copy what SIMD Json does
- Stage 2 is harder
    - Optimally, we need to have each element type get it's own handler, and then run
    several handlers in parallel.
    - SIMD Json is designed to allow this very easily; stage 1 spits out all the indicies
    where soemthing interesting is
    - String handling gets a pile of special cases; we want to do a LOT of rapid copying in the
    simple case of no escaped items, but we need to handle two types of escapes (single char like \r 
    and unicode like \u02fe)
    - Floats are bleh bleh bleh
    
    - Each handler should be able to run more or less in parralell with each other
    - We use asymetric BRAMs to store the results of 2+ handlers at once

    - separte string handler into two chunks: claimer (makes struct tape element) and writer
    (does the actual copying)
    - There's no obligation under SIMDJSON's tape format for all string chunks to be contigous; should
    we exploit?  doing so would let us run several string parsers at once... cost of memory efficency tho...
        - non-contigous means we can determine the number of string tape elements a given string will require
        ahead of time, so we can copy 2 strings over at once
        - can't do more than 2, RAMs are dual-port, and asymetry only lets us do multiple words at once
        - can maybe calculate good length estimate by looking at the bitmaps? what does simdjson do?
