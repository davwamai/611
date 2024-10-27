/* Copyright 2020 Jason Bakos, Philip Conrad, Charles Daniels */

/* Top-level module for CSCE611 RISC-V CPU, for running under simulation.  In
 * this case, the I/Os and clock are driven by the simulator. */

module simtop2;

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

    // Pulse reset (active low)
    initial begin
        KEY <= 4'he;
        #10;
        KEY <= 4'hf;
    end

    // Drive clock
    always begin
        clk <= 1'b0; #5;
        clk <= 1'b1; #5;
    end

    // Initialize switches
    initial begin
        SW = 18'd123456;
    end

    // Define expected register values
    logic [31:0] expected_regs [0:31];
    int i;

    initial begin
        // Initialize all expected register values to zero
        for (i = 0; i < 32; i = i + 1) begin
            expected_regs[i] = 32'd0;
        end
        // Set expected values
        expected_regs[21] = 6;
        expected_regs[20] = 5;
        expected_regs[19] = 4;
        expected_regs[18] = 3;
        expected_regs[9]  = 2;
        expected_regs[8]  = 1;
    end

    // Variables for checking
    int errors;
    int reg_indices [0:5];

    initial begin
        #100000;
        $display("------ Simulation complete. ------");
        errors = 0;

        // Initialize reg_indices
        reg_indices[0] = 8;
        reg_indices[1] = 9;
        reg_indices[2] = 18;
        reg_indices[3] = 19;
        reg_indices[4] = 20;
        reg_indices[5] = 21;

        for (i = 0; i < 6; i = i + 1) begin
            int idx;
            idx = reg_indices[i];
            if (dut.cpu_inst.rf_inst.mem[idx] !== expected_regs[idx]) begin
                $display("ERROR: Register x%0d mismatch. Expected: %0d, Got: %0d",
                         idx, expected_regs[idx], dut.cpu_inst.rf_inst.mem[idx]);
                errors = errors + 1;
            end else begin
                $display("Register x%0d OK. Value: %0d", idx, dut.cpu_inst.rf_inst.mem[idx]);
            end
        end

        if (errors == 0) begin
            $display("TEST PASSED: All register values are correct.");
        end else begin
            $display("TEST FAILED: %0d errors detected.", errors);
            $stop; // Stop simulation on failure
        end

        $finish; // End the simulation
    end
endmodule
