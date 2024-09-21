/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop;

	logic clk;
  logic [17:0] SW;
	logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;

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
		.KEY(),

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

  // period of 10 time units
  initial clk = 0;
  always #5 clk = ~clk; // Toggle every 5 time units

  initial begin
      // Init "switches" to 0
      SW = 18'd0;

      repeat (257) begin
          #10;         // Stall 10 time units
          SW = SW + 1;
      end

      #10 $finish;
  end

  initial begin
      $display("Time\tSW\t\tHEX3 HEX2 HEX1 HEX0");
      $monitor("%0t\t%h\t%h  %h  %h  %h", $time, SW[15:0], HEX3, HEX2, HEX1, HEX0);
  end

endmodule

