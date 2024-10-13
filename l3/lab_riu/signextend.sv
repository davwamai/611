module signextend (
    input  logic [31:0] in,
    input  logic [1:0]  imm_src,
    output logic [31:0] imm_ext
);

    always_comb begin
        case (imm_src)
            2'b00: imm_ext = {{20{in[31]}}, in[31:20]};           // Immediate from instruction[31:20]
            2'b01: imm_ext = {{20{in[31]}}, in[31:25], in[11:7]}; // Immediate from instruction[31:25] and instruction[11:7]
            default: imm_ext = 32'h00000000;                      // Default case
        endcase
    end

endmodule
