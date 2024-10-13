module controlunit (
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    input logic [11:0] csr,

    output logic alusrc_EX,
    output logic GPIO_we,
    output logic regwrite_EX,
    output logic [1:0] regsel_EX,
    output logic [3:0] aluop_EX
);

    always_comb begin
        // default values for out signals
        aluop_EX     = 4'b0000;
        alusrc_EX    = 1'b0;
        regsel_EX    = 2'b00;
        regwrite_EX  = 1'b0;
        GPIO_we   = 1'b0;

        // based on opcode, funct3, funct7, etc.
        case (opcode)
            7'h33: begin // R-type instructions
                case (funct3)
                    3'b000: begin
                        if (funct7 == 7'h0) begin
                            aluop_EX    = 4'b0011; // ALU operation for ADD
                            alusrc_EX   = 1'b0;
                            regsel_EX   = 2'b10;
                            regwrite_EX = 1'b1;
                            GPIO_we     = 1'b0;
                        end
                        if (funct7 == 7'h20) begin
                            aluop_EX    = 4'b0100; // ALU operation for SUB
                            alusrc_EX   = 1'b0;
                            regsel_EX   = 2'b10;
                            regwrite_EX = 1'b1;
                            GPIO_we  = 1'b0;
                        end
                        if (funct7 == 7'h1) begin
                            aluop_EX    = 4'b0101; // ALU operation for MUL
                            alusrc_EX   = 1'b0;
                            regsel_EX   = 2'b10;
                            regwrite_EX = 1'b1;
                            GPIO_we  = 1'b0;
                        end
                    end
                    3'b010: begin
                        if (funct7 == 7'h0) begin
                            aluop_EX    = 4'b1100; // ALU operation for SLT
                            alusrc_EX   = 1'b0;
                            regsel_EX   = 2'b10;
                            regwrite_EX = 1'b1;
                            GPIO_we  = 1'b0;
                        end
                    end
                    3'b111: begin // AND
                        if (funct7 == 7'h0) begin
                            aluop_EX    = 4'b0000; // ALU operation for AND
                            alusrc_EX   = 1'b0;
                            regsel_EX   = 2'b10;
                            regwrite_EX = 1'b1;
                            GPIO_we  = 1'b0;
                        end
                    end
                    3'b001: begin // SLL
                        if (funct7 == 7'h0) begin
                            aluop_EX    = 4'b1000; // ALU operation for SLL
                            alusrc_EX   = 1'b0;
                            regsel_EX   = 2'b10;
                            regwrite_EX = 1'b1;
                            GPIO_we  = 1'b0;
                        end
                    end
                endcase
            end

            7'h13: begin // I-type instructions
                case (funct3)
                    3'b111: begin // ANDI
                        aluop_EX    = 4'b0000; // ALU operation for ANDI
                        alusrc_EX   = 1'b1;    // Immediate source for ALU
                        regsel_EX   = 2'b10;
                        regwrite_EX = 1'b1;
                        GPIO_we  = 1'b0;
                    end
                    3'b001: begin // SLLI
                        aluop_EX    = 4'b1000; // ALU operation for SLLI
                        alusrc_EX   = 1'b1;    // Immediate source for ALU
                        regsel_EX   = 2'b10;
                        regwrite_EX = 1'b1;
                        GPIO_we  = 1'b0;
                    end
                endcase
            end
            // more cases for other opcodes and funct3 values
        endcase
    end
endmodule
