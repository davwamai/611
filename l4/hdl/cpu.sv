module cpu(
    input logic clk,
    input logic rst_n,
    input logic [31:0] io0_in,
    output logic [31:0] io2_out
);

    logic [31:0] instruction_EX, rd1_EX, rd2_EX, m_to_alu_EX;
    logic [31:0] mux310, mux311, mux312, R_EX, s_extend_EX, writedata_WB;
    logic [3:0] aluop_EX;
    logic [4:0] regdest_WB;
    logic [1:0] regsel_EX, regsel_WB;
    logic alusrc_EX, GPIO_we, regwrite_EX, regwrite_WB;

    program_counter pc_inst (
        .clk(clk),
        .rst_n(rst_n),
        .instruction_EX(instruction_EX)
    );

    regfile rf_inst (
        .clk(clk),
        .we(regwrite_WB),
        .readaddr1(instruction_EX[19:15]),
        .readaddr2(instruction_EX[24:20]),
        .writeaddr(regdest_WB),
        .writedata(writedata_WB),
        .readdata1(rd1_EX),
        .readdata2(rd2_EX)
    );

    sign_extend sign_extend_inst (
        .in(instruction_EX[31:20]),
        .out(s_extend_EX)
    );

    mux21 rf_to_alu_mux_inst (
        .a(rd2_EX),
        .b(s_extend_EX),
        .s(alusrc_EX),
        .c(m_to_alu_EX)
    );

    alu alu_inst (
        .A(rd1_EX),
        .B(m_to_alu_EX),
        .op(aluop_EX),
        .R(R_EX),
        .zero()
    );

    controlunit cu_inst (
        .opcode(instruction_EX[6:0]),
        .funct3(instruction_EX[14:12]),
        .funct7(instruction_EX[31:25]),
        .csr(instruction_EX[31:20]),
        .alusrc_EX(alusrc_EX),
        .GPIO_we(GPIO_we),
        .regwrite_EX(regwrite_EX),
        .regsel_EX(regsel_EX),
        .aluop_EX(aluop_EX)
    );

    pipeline_register #(.WIDTH(1)) regwrite_to_we_inst(
        .clk(clk),
        .in(regwrite_EX),
        .out(regwrite_WB)
    );

    pipeline_register #(.WIDTH(2)) regsel_to_mux(
        .clk(clk),
        .in(regsel_EX),
        .out(regsel_WB)
    );

    pipeline_register #(.WIDTH(32)) to_31mux0(
        .clk(clk),
        .in(io0_in),
        .out(mux310)
    );

    pipeline_register #(.WIDTH(32)) to_31mux1(
        .clk(clk),
        .in({instruction_EX[31:12], 12'd0}),
        .out(mux311)
    );

    pipeline_register #(.WIDTH(32)) to_31mux2(
        .clk(clk),
        .in(R_EX),
        .out(mux312)
    );

    pipeline_register #(.WIDTH(5)) regdest_to_regfile_inst(
        .clk(clk),
        .in(instruction_EX[11:7]),
        .out(regdest_WB)
    );

    en_pipeline_register #(.WIDTH(32)) to_GPIO_out(
        .in(rd1_EX),
        .clk(clk),
        .en(GPIO_we),
        .out(io2_out)
    );

    mux31 mux31_inst (
        .a(mux310),
        .b(mux311),
        .c(mux312),
        .s(regsel_WB),
        .o(writedata_WB)
    );

endmodule
