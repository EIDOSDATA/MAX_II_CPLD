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
`define ST_RUN				(3'd2) /* 010 */
`define ST_STOP			(3'd3) /* 011 */

module LED_SHIFT
(
// {ALTERA_ARGS_BEGIN} DO NOT REMOVE THIS LINE!
	i_clk,
	i_btn,
	
	o_g_led,
	o_r_led,
	o_y_led,
	o_t_fnd,
	o_t2_fnd,
	o_m_fnd,
	o_m2_fnd,
	o_s_fnd,
	o_s2_fnd	
// {ALTERA_ARGS_END} DO NOT REMOVE THIS LINE!
);

// {ALTERA_IO_BEGIN} DO NOT REMOVE THIS LINE!
parameter	sys_clk = 1000000;

/* GPIO :: PIN SETTING */
input				i_clk;
input				i_btn;

output [7:0] 	o_g_led;
output [1:0] 	o_r_led;
output [3:0] 	o_y_led;
output [7:0]	o_t_fnd;
output [7:0]	o_t2_fnd;
output [7:0]	o_m_fnd;
output [7:0]	o_m2_fnd;
output [7:0]	o_s_fnd;
output [7:0]	o_s2_fnd;

/* REG :: TIMER CLOCK */
reg [31:0]	r_clk_cnt;

/* REG :: LED LOGIC */
reg [7:0] 	r_g_led_status;
reg [7:0] 	c_g_led_status;
reg r_timer_en;
reg c_timer_en;

/* REG :: STATUS */
reg [2:0] 	r_state;
reg [2:0] 	c_next_state;

/* REG :: STATUS or EVENT CHECK */
reg r_init_ok;
reg r_btn_press;

// {ALTERA_IO_END} DO NOT REMOVE THIS LINE!
// {ALTERA_MODULE_BEGIN} DO NOT REMOVE THIS LINE!
initial
begin
	r_clk_cnt <= 32'b0;			// TIMER CNT INIT
	r_timer_en <= 1'b0;			// TIMER FLAG
	r_g_led_status <= 8'b0; 	// LED STATUS INIT
	
	r_btn_press <= 1'b0;			// BTN INIT
	
	r_init_ok <= 1'b1;			// INIT FLAG
	r_state <= `ST_INIT;			// SET SYSTEM STATUS
end

/* BUTTON - FLIP FLOP */
always @ (posedge i_clk) 
begin
	/* BUTTON PRESSED */
	if (!i_btn)
	begin
		r_btn_press <= 1;
	end
	
	/* NOT PRESSED */
	else
	begin
		r_state <= c_next_state;
		r_btn_press <= 0;
	end	
end

/* TIMER ENABLE CHK */
always @ (posedge i_clk)
begin
	r_timer_en <= c_timer_en;	
end

/* TIMER - FLIP FLOP */
always @ (posedge i_clk)
begin

	if (!r_timer_en)
	begin
		r_clk_cnt <= 0;
	end
	
	else
	begin
		/* CLOCK COUNTING */
		if(r_clk_cnt < 5000000)
		begin
			r_clk_cnt <= r_clk_cnt + 1;
		end		
		/* CLOCK RESET */
		else		
		begin
			r_clk_cnt <= 0;
		end		
	end
end

/* LED SHIFTER - FLIP FLOP */
always @ (posedge i_clk)
begin
	
	if (!r_timer_en)
	begin
		r_g_led_status <= 0;
	end

	else
	begin
		/* CLOCK COUNTING */
		if(r_clk_cnt == 0)
		begin		
			/* LED STATUS INIT */
			if(r_g_led_status == 0)
			begin
				r_g_led_status <= 8'h01;			
			end			
			/* LED SHIFT */
			else
			begin
				r_g_led_status <= r_g_led_status << 1;			
			end			
		end		
	end
end

/* Combinational Logic */
always @(*)
begin
	c_timer_en = 0;	
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
				c_next_state = `ST_RUN;
			end
		end
		
		`ST_RUN:
		begin
			if(r_btn_press) begin
				c_next_state = `ST_STOP;
			end
			
			else begin
				c_timer_en = 1;
				c_next_state = `ST_RUN;
			end
		end
		
		`ST_STOP:
		begin
			if(r_btn_press) begin
				c_next_state = `ST_RUN;
			end
			
			else begin
				c_timer_en = 0;
				c_next_state = `ST_STOP;
			end
		end
	endcase	
end

/* LED ASSIGN */
//assign o_g_led = r_g_led_status;

/* LED - FULL DRIVE */
assign o_g_led = 8'hFF;
assign o_r_led = 2'b11;
assign o_y_led = 4'hF;

/* FND - FULL DRIVE */
assign o_t_fnd = 8'hFF;
assign o_t2_fnd = 8'hFF;
assign o_m_fnd = 8'hFF;
assign o_m2_fnd = 8'hFF;
assign o_s_fnd = 8'hFF;
assign o_s2_fnd = 8'hFF;

// {ALTERA_MODULE_END} DO NOT REMOVE THIS LINE!
endmodule
