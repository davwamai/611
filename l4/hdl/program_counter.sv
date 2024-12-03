module program_counter(
    input logic clk,
    input logic rst_n,
    output logic [31:0] instruction_EX
);

    logic [11:0] PC_FETCH;
    logic [31:0] inst_ram [0:4095];

    initial $readmemh("testing.rom", inst_ram);

    // program counter logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            PC_FETCH <= 12'd0;
        end else begin
            PC_FETCH <= PC_FETCH + 1'b1;
        end
    end

    // instruction fetch logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            instruction_EX <= 32'd0;
        end else begin
            instruction_EX <= inst_ram[PC_FETCH];
        end
    end

endmodule
