`timescale 1ns / 1ps

module sim_top;
    reg clk;
    reg rst_n;
    reg [31:0] io0_in;
    wire [31:0] io2_out;
    
    cpu dut (
        .clk(clk),
        .rst_n(rst_n),
        .io0_in(io0_in),
        .io2_out(io2_out)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        io0_in = 32'd0;
        
        rst_n = 0;
        #20;
        rst_n = 1;
        
        #10;
        io0_in = 32'd42;
        
        #1000;
        $finish;
    end
    
    initial begin
        $monitor("Time: %0t | io2_out: %d", $time, io2_out);
    end
endmodule
