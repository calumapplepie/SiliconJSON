## Summary

We need to communicate between the processing system (PS) and the programabble logic (PL).
The interfaces to accomplish this are various AXI things, and pressure us to behave somewhat
differently than we currently do.

## Facts

AXI-Stream is the highest throughput option; it works best for a continuous stream of data.
Using it to bring in the unparsed JSON is a no-brainer.

The ideal system for the string and struct tapes are both unclear, and may be different.  
Both tapes are primarily linear, but require periodic random writes 
to earlier portions of the data stream, and the structure tape has a bit of weirdness with numbers

String secondary writes can be limited to one per cycle if we can do a 32 bit write to the start
of each string

Use of the IP Integrator, which may be very important to getting working communication
between PL and PS, will likley require restructuring our existing module hierarchy. 

## Solution Ideas

### Option: Transfer Live

Use a combination of IP Integrator pieces to DMA parsed JSON into the PS as it is created.

While superficially the most obvious, there are a ton of complications:  
- We only sometimes write one word per cycle; often we write two, or zero
    - Thus, we'd probably need a multi-channel solution, but... that gets freakishly messy
- The size and position of said extra writes varies
- Xylinx's DMA IP's get very complicated very quickly
- The port interface (ie, API) of the DMA engines is different from the BRAM's that we're working
with already

### Option: Accumulate in BRAM

Instead of live motion into and out of the PL, perhaps a better system is for the PS to load
the unparsed data into BRAMs, the PL to parse it into other BRAMs, and then move it into the PL
all at once.  This makes any future PCIe support easier, and keeps our AXI writes simple.

This will still require hierarchy changes: we need to access the BRAMs at a higher level
than previously, and that may not be easily supported in Vivado synthesis.

Additionally, we will want a 'switching' system, where we switch between different BRAMs
so that we can be copying data out of one while another has data copied in.  Perhaps 3 sets? 4?

Maybe pull the BRAMs out into the TapeWriter module?  Or rework the BRAM verilog to use more of
the hardware capabilities?

## To Do

We will quite possibly require a custom AXI-Stream implementation for either solution.
AXI-Stream is... not a trivial protocol.
