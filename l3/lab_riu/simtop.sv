/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop;

	logic clk;
	logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	logic [3:0] KEY;
	logic [17:0] SW;

	top dut
	(
		//////////// CLOCK //////////
		.CLOCK_50(clk),
		.CLOCK2_50(),
	    .CLOCK3_50(),

		//////////// LED //////////
		.LEDG(),
		.LEDR(),

		//////////// KEY //////////
		.KEY(KEY),

		//////////// SW //////////
		.SW(SW),

		//////////// SEG7 //////////
		.HEX0(HEX0),
		.HEX1(HEX1),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5),
		.HEX6(HEX6),
		.HEX7(HEX7)
	);

  logic [31:0] io0, io2;

  // pulse reset (active low)
	initial begin
		KEY <= 4'he;
		#10;
		KEY <= 4'hf;
	end
	
	// drive clock
	always begin
		clk <= 1'b0; #5;
		clk <= 1'b1; #5;
	end
	
	// assign simulated switch values
	assign SW = 18'd12345;
  assign io0 = {14'b0, SW};

  hexdriver hd0 (.val(io2[3:0]), .HEX(HEX0));
  hexdriver hd1 (.val(io2[7:4]), .HEX(HEX1));
  hexdriver hd2 (.val(io2[11:8]), .HEX(HEX2));
  hexdriver hd3 (.val(io2[15:12]), .HEX(HEX3));
  hexdriver hd4 (.val(io2[19:16]), .HEX(HEX4));
  hexdriver hd5 (.val(io2[23:20]), .HEX(HEX5));
  hexdriver hd6 (.val(io2[27:24]), .HEX(HEX6));
  hexdriver hd7 (.val(io2[31:28]), .HEX(HEX7));

  cpu cpu_inst(.clk(CLOCK_50), .rst_n(KEY[0]), .io0_in(io0), .io2_out(i02));


endmodule

