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


`define ST_INIT			(3'd0) /* 000 */
`define ST_IDLE			(3'd1) /* 001 */
`define ST_LED0_ON		(3'd2) /* 010 */
`define ST_LED1_ON		(3'd3) /* 011 */
`define ST_LED2_ON		(3'd4) /* 100 */
`define ST_LED3_ON		(3'd5) /* 101 */


module Button
(
// {ALTERA_ARGS_BEGIN} DO NOT REMOVE THIS LINE!

	i_btn,
	i_clk,
	o_led0,
	o_led1,
	o_led2,
	o_led3
// {ALTERA_ARGS_END} DO NOT REMOVE THIS LINE!

);

// {ALTERA_IO_BEGIN} DO NOT REMOVE THIS LINE!
input			i_btn;
input			i_clk;
output			o_led0;
output			o_led1;
output			o_led2;
output			o_led3;

reg r_led0_en;
reg r_led1_en;
reg r_led2_en;
reg r_led3_en;

reg c_led0_en;
reg c_led1_en;
reg c_led2_en;
reg c_led3_en;

reg r_init_ok;
reg r_btn_press;

reg [2:0] r_state;
reg [2:0] c_next_state;

// {ALTERA_IO_END} DO NOT REMOVE THIS LINE!
// {ALTERA_MODULE_BEGIN} DO NOT REMOVE THIS LINE!
initial
begin	
	r_led0_en <= 1'b0;
	r_led1_en <= 1'b0;
	r_led2_en <= 1'b0;
	r_led3_en <= 1'b0;
	
	r_btn_press <= 1'b0;
	
	r_init_ok <= 1'b1;
	r_state <= `ST_INIT;
end

/* BUTTON - FLIP FLOP */
always @ (posedge i_clk)
begin

	// BUTTON PRESSED
	if (~i_btn)
	begin		
		r_btn_press <= 1;		
	end
	
	// NOT PRESSED
	else
	begin		
		r_state <= c_next_state;		
		r_btn_press <= 0;
	end	
end

/* LED - FLIP FLOP */
always @ (posedge i_clk)
begin
	r_led0_en <= c_led0_en;
	r_led1_en <= c_led1_en;
	r_led2_en <= c_led2_en;
	r_led3_en <= c_led3_en;
end


/* Combinational Logic */
always @(*)
begin
	c_led0_en = 0;
	c_led1_en = 0;
	c_led2_en = 0;
	c_led3_en = 0;
	c_next_state = r_state;	
	
	case (r_state)
		`ST_INIT:
		begin
			if (r_init_ok) begin
				c_next_state = `ST_IDLE;
			end			
		end
		
		`ST_IDLE:
		begin
			if (r_btn_press) begin
				c_next_state = `ST_LED0_ON;
			end
			
			else begin
				c_next_state = `ST_IDLE;
			end
		end
		
		`ST_LED0_ON:
		begin
			if (r_btn_press) begin
				c_next_state = `ST_LED1_ON;
			end
			
			else begin
				c_led0_en = 1;
				c_next_state = `ST_LED0_ON;
			end
		end
		`ST_LED1_ON:
		begin
			if (r_btn_press) begin
				c_next_state = `ST_LED2_ON;
			end
			
			else begin
				c_led1_en = 1;
				c_next_state = `ST_LED1_ON;
			end
		end
		`ST_LED2_ON:
		begin
			if (r_btn_press) begin
				c_next_state = `ST_LED3_ON;
			end
			
			else begin
				c_led2_en = 1;
				c_next_state = `ST_LED2_ON;
			end
		end
		`ST_LED3_ON:
		begin
			if (r_btn_press) begin
				c_next_state = `ST_LED0_ON;
			end
			
			else begin
				c_led3_en = 1;
				c_next_state = `ST_LED3_ON;
			end
		end
	endcase
end
/* LED ASSIGN */
assign o_led0 = r_led0_en;
assign o_led1 = r_led1_en;
assign o_led2 = r_led2_en;
assign o_led3 = r_led3_en;
// {ALTERA_MODULE_END} DO NOT REMOVE THIS LINE!
endmodule


