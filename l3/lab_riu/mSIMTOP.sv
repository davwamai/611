`timescale 1ns / 1ps

module sim_top;

  logic clk;
  logic rst_n;
  logic [31:0] io0_in;
  logic [31:0] io2_out;

  logic [6:0] HEX0;
  logic [6:0] HEX1;
  logic [6:0] HEX2;
  logic [6:0] HEX3;
  logic [6:0] HEX4;
  logic [6:0] HEX5;
  logic [6:0] HEX6;
  logic [6:0] HEX7;

  hexdriver hd0 (.val(io2_out[3:0]), .HEX(HEX0));
  hexdriver hd1 (.val(io2_out[7:4]), .HEX(HEX1));
  hexdriver hd2 (.val(io2_out[11:8]), .HEX(HEX2));
  hexdriver hd3 (.val(io2_out[15:12]), .HEX(HEX3));
  hexdriver hd4 (.val(io2_out[19:16]), .HEX(HEX4));
  hexdriver hd5 (.val(io2_out[23:20]), .HEX(HEX5));
  hexdriver hd6 (.val(io2_out[27:24]), .HEX(HEX6));
  hexdriver hd7 (.val(io2_out[31:28]), .HEX(HEX7));

  cpu dut (
    .clk(clk),
    .rst_n(rst_n),
    .io0_in(io0_in),
    .io2_out(io2_out)
  );

  // 20ns period (50MHz clock)
  always #10 clk = ~clk;

  initial begin
    clk = 0;
    rst_n = 0;
    io0_in = 32'd12345;

    #20;
    rst_n = 1;

    #2550;
    $display("Register 6: %8h", dut.rf_inst.mem[6]);

    $finish;
  end
