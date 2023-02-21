// Copyright (C) 2022  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.

module LED_Blink
(
// {ALTERA_ARGS_BEGIN} DO NOT REMOVE THIS LINE!

	led0,
	led1,
	led2,
	led3,
	clk
// {ALTERA_ARGS_END} DO NOT REMOVE THIS LINE!

);

// {ALTERA_IO_BEGIN} DO NOT REMOVE THIS LINE!
output			led0;
output			led1;
output			led2;
output			led3;
input				clk;
reg [31:0] led0_cnt;
reg [31:0] led1_cnt;
reg [31:0] led2_cnt;
reg [31:0] led3_cnt;
reg led0_status;
reg led1_status;
reg led2_status;
reg led3_status;

// {ALTERA_IO_END} DO NOT REMOVE THIS LINE!
// {ALTERA_MODULE_BEGIN} DO NOT REMOVE THIS LINE!
initial
begin
	led0_cnt <= 32'b0;
	led1_cnt <= 32'b0;
	led2_cnt <= 32'b0;
	led3_cnt <= 32'b0;
	led0_status <= 1'b0;
	led1_status <= 1'b0;
	led2_status <= 1'b0;
	led3_status <= 1'b0;
end

/* LED 0 BLINK*/
always @ (posedge clk) 
begin
	led0_cnt <= led0_cnt + 1'b1;
	if (led0_cnt > 80000000)
	begin
		led0_status <= !led0_status;
		led0_cnt <= 32'b0;		
	end
end

/* LED 1 BLINK*/
always @ (posedge clk) 
begin
	led1_cnt <= led1_cnt + 1'b1;
	if (led1_cnt > 40000000)
	begin
		led1_status <= !led1_status;
		led1_cnt <= 32'b0;		
	end
end

/* LED 2 BLINK*/
always @ (posedge clk) 
begin
	led2_cnt <= led2_cnt + 1'b1;
	if (led2_cnt > 20000000)
	begin
		led2_status <= !led2_status;
		led2_cnt <= 32'b0;		
	end
end

/* LED 3 BLINK*/
always @ (posedge clk) 
begin
	led3_cnt <= led3_cnt + 1'b1;
	if (led3_cnt > 10000000)
	begin
		led3_status <= !led3_status;
		led3_cnt <= 32'b0;		
	end
end

/* LED ASSIGN */
assign led0 = led0_status;
assign led1 = led1_status;
assign led2 = led2_status;
assign led3 = led3_status;
// {ALTERA_MODULE_END} DO NOT REMOVE THIS LINE!
endmodule
