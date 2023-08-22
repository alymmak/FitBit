`timescale 1ns / 1ps

module Top(CLK, START, MODE, RESET, SI, an, sseg, dp);
input CLK, RESET, START; 
input [1:0] MODE; 
output [3:0] an;
output [6:0] sseg;
output dp;

wire[3:0] step_out0;
wire[3:0] step_out1;
wire[3:0] step_out2;
wire[3:0] step_out3;

output wire SI;

wire [31:0] amtSteps;
wire [31:0] steps;
wire fitbit_clock;
wire slow_clock;
wire two_clock;
wire pulse;
wire[6:0] in0;
wire[6:0] in1, in2, in3;

//module stepcounter(CLK, PULSE, RESET, step_out0, step_out1, step_out2, step_out3, SI, dis_out0, dis_out1, dis_out2, dis_out3, step32_out)

clock_fitbit c1(CLK, fitbit_clock);
generate_pulses c2(CLK, fitbit_clock, START, RESET, pulse, amtSteps, steps, MODE);
twosec_clk c15(CLK, two_clock);
onesec_clk c16(CLK, one_clock);
stepcounter c3(fitbit_clock, two_clock, pulse, RESET, step_out0, step_out1, step_out2, step_out3, SI, START, amtSteps);

// step counter
hexto7segment c4 (.x(step_out0), .r(in0));
hexto7segment c5 (.x(step_out1), .r(in1));
hexto7segment c6 (.x(step_out2), .r(in2));
hexto7segment c7 (.x(step_out3), .r(in3));

// display to board
clock_display c14(CLK, slow_clock);

display_board c17(slow_clock, in0, in1, in2, in3, an, sseg, dp);

endmodule
