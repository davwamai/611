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

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz clock

    initial begin
        KEY = 4'b1110; // Assert reset
        #20;
        KEY = 4'b1111; // Deassert reset
    end

    // Initialize switches
    initial SW = 18'd123456;

    // Define expected register values
    logic [31:0] expected_regs [0:31];
    initial begin
        // Initialize all expected register values to zero
        for (int i = 0; i < 32; i++) begin
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

    // Wait for program completion and check results
    initial begin
        // Wait for the program to complete
        wait (dut.cpu_inst.rf_inst.mem[8] === 4'b1);
        #10;
        check_results();
        $finish;
    end

    // Task to check results
    task check_results;
        int errors = 0;
        begin
            int reg_indices[] = '{8, 9, 18, 19, 20, 21};
            foreach (reg_indices[i]) begin
                int idx = reg_indices[i];
                if (dut.cpu_inst.rf_inst.mem[idx] !== expected_regs[idx]) begin
                    $display("ERROR: Register x%0d mismatch. Expected: %0d, Got: %0d", 
                             idx, expected_regs[idx], dut.cpu_inst.rf_inst.mem[idx]);
                    errors++;
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
        end
    endtask

endmodule

