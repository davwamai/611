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

  final begin
      // testcase bin2dec
      $display("D5: %8d", dut.cpu_inst.rf_inst.mem[21]);
      $display("D4: %8d", dut.cpu_inst.rf_inst.mem[20]);
      $display("D3: %8d", dut.cpu_inst.rf_inst.mem[19]);
      $display("D2: %8d", dut.cpu_inst.rf_inst.mem[18]);
      $display("D1: %8d", dut.cpu_inst.rf_inst.mem[9]);
      $display("D0: %8d", dut.cpu_inst.rf_inst.mem[8]);

      // testcase all_instructions
      $display("x1: %8d", dut.cpu_inst.rf_inst.mem[1]);
      $display("x2: %8d", dut.cpu_inst.rf_inst.mem[2]);
      $display("x3: %8d", dut.cpu_inst.rf_inst.mem[3]);
      $display("x4: %8d", dut.cpu_inst.rf_inst.mem[4]);
      $display("x5: %8d", dut.cpu_inst.rf_inst.mem[5]);
      $display("x6: %8d", dut.cpu_inst.rf_inst.mem[6]);
      $display("x7: %8d", dut.cpu_inst.rf_inst.mem[7]);
      $display("x8: %8d", dut.cpu_inst.rf_inst.mem[8]);
      $display("x9: %8d", dut.cpu_inst.rf_inst.mem[9]);
      $display("x10: %8d", dut.cpu_inst.rf_inst.mem[10]);
      $display("x11: %8d", dut.cpu_inst.rf_inst.mem[11]);
      $display("x12: %8d", dut.cpu_inst.rf_inst.mem[12]);
      $display("x13: %8d", dut.cpu_inst.rf_inst.mem[13]);
      $display("x14: %8d", dut.cpu_inst.rf_inst.mem[14]);
      $display("x15: %8d", dut.cpu_inst.rf_inst.mem[15]);
      $display("x16: %8d", dut.cpu_inst.rf_inst.mem[16]);
      $display("x17: %8d", dut.cpu_inst.rf_inst.mem[17]);
      $display("x18: %8d", dut.cpu_inst.rf_inst.mem[18]);
      $display("x19: %8d", dut.cpu_inst.rf_inst.mem[19]);
      $display("x20: %8d", dut.cpu_inst.rf_inst.mem[20]);
      $display("x21: %8d", dut.cpu_inst.rf_inst.mem[21]);
  end

endmodule

