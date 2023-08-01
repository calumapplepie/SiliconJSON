`timescale 1ns / 1ps

module SinglePulser_Wrapper(
        input wire clk, din, output wire d_pulse
    );
    SinglePulser Pulsey (clk, din, d_pulse);
endmodule
