module CTRL(
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    input [2:0] branch_result,
    output reg [1:0] NPC_op,
    output reg RF_we,
    output reg [1:0] Wd_sel,
    output reg [2:0] ALU_op,
    output reg ALUb_sel,
    output reg [2:0] SEXT_op,
    output reg DM_we,
    output reg ID_rf1, // ID stage rs1 read flag
    output reg ID_rf2, // ID stage rs2 read flag
    output reg load,
    output reg store,
    output reg [2:0] Btype,
    output reg Ijalr,
    output reg Jtype
);

parameter OPC_RTYPE = 'b0110011,
          OPC_ITYPE = 'b0010011,
          OPC_ITYPE_LW = 'b0000011,
          OPC_ITYPE_JALR = 'b1100111,
          OPC_STYPE = 'b0100011,
          OPC_JTYPE = 'b1101111,
          OPC_BTYPE = 'b1100011,
          OPC_UTYPE = 'b0110111,
          
          F3_ADD_OR_SUB = 'b000,
          F3_AND = 'b111,
          F3_OR = 'b110,
          F3_XOR = 'b100,
          F3_SLL = 'b001,
          F3_SR = 'b101, 
          F3_JALR = 'b000,
          F3_BEQ = 'b000,
          F3_BNE = 'b001,
          F3_BLT = 'b100,
          F3_BGE = 'b101,
          
          F7_DEFAULT = 'b0000000,
          F7_SUB_OR_ARITH = 'b0100000,
          
          BRANCH_EQ = 'b001,
          BRANCH_LT = 'b010,
          BRANCH_GT = 'b100,
          
          NPC_PC4 = 'b00,
          NPC_RA = 'b01,
          NPC_IMM = 'b10,
          
          WD_ALUC = 'b00,
          WD_DM = 'b01,
          WD_PC4 = 'b10,
          WD_SEXT = 'b11,
          
          ALU_ADD = 'b000,
          ALU_SUB = 'b001,
          ALU_AND = 'b010,
          ALU_OR = 'b011,
          ALU_XOR = 'b100,
          ALU_SLL = 'b101,
          ALU_SRL = 'b110,
          ALU_SRA = 'b111,
          
          SEXT_ITYPE = 'b000,
          SEXT_STYPE = 'b001,
          SEXT_BTYPE = 'b010,
          SEXT_UTYPE = 'b011,
          SEXT_JTYPE = 'b100;

// NPC_op
always @(*) begin
    // JALR: imm + rs1
    if (opcode == OPC_ITYPE_JALR && funct3 == F3_JALR) begin
        NPC_op = NPC_RA;
    end
    // JAL: PC + imm
    else if (opcode == OPC_JTYPE) begin
        NPC_op = NPC_IMM;
    end
    // B-type: according to branch result
    else if (opcode == OPC_BTYPE) begin
        case(funct3)
            F3_BEQ: NPC_op = (branch_result == BRANCH_EQ) ? NPC_IMM : NPC_PC4;
            F3_BNE: NPC_op = (branch_result != BRANCH_EQ) ? NPC_IMM : NPC_PC4;
            F3_BLT: NPC_op = (branch_result == BRANCH_LT) ? NPC_IMM : NPC_PC4;
            F3_BGE: NPC_op = (branch_result == BRANCH_GT || branch_result == BRANCH_EQ) ? NPC_IMM : NPC_PC4;
            default: NPC_op = NPC_PC4;
        endcase
    end
    else begin
        NPC_op = NPC_PC4;
    end
end

// RF_we
always @(*) begin
    if (opcode == OPC_RTYPE || opcode == OPC_ITYPE || opcode == OPC_ITYPE_LW || opcode == OPC_ITYPE_JALR || opcode == OPC_UTYPE || opcode == OPC_JTYPE) begin
        RF_we = 1'b1;
    end
    else begin
        RF_we = 1'b0;
    end
end

// Wd_sel
always @(*) begin
    // R-type and I-type (not include lw or jalr): rd = alu_c
    if (opcode == OPC_RTYPE || opcode == OPC_ITYPE) begin
        Wd_sel = WD_ALUC;
    end
    // lw: rd = DRAM data
    else if (opcode == OPC_ITYPE_LW) begin
        Wd_sel = WD_DM;
    end
    // jalr and jal: rd = PC + 4
    else if (opcode == OPC_ITYPE_JALR || opcode == OPC_JTYPE) begin
        Wd_sel = WD_PC4;
    end
    // U-type: rd = imm
    else if (opcode == OPC_UTYPE) begin
        Wd_sel = WD_SEXT;
    end
    else begin
        Wd_sel = WD_ALUC;
    end
end

// ALU_op
always @(*) begin
    case(opcode)
        OPC_RTYPE: begin
            case(funct3)
                F3_ADD_OR_SUB: begin
                    if (funct7 == F7_DEFAULT) begin
                        ALU_op = ALU_ADD;
                    end
                    else if (funct7 == F7_SUB_OR_ARITH) begin
                        ALU_op = ALU_SUB;
                    end
                    else begin
                        ALU_op = 3'b000;
                    end
                end
                F3_AND: ALU_op = ALU_AND;
                F3_OR: ALU_op = ALU_OR;
                F3_XOR: ALU_op = ALU_XOR;
                F3_SLL: ALU_op = ALU_SLL;
                F3_SR: begin
                    if (funct7 == F7_DEFAULT) begin
                        ALU_op = ALU_SRL;
                    end
                    else if (funct7 == F7_SUB_OR_ARITH) begin
                        ALU_op = ALU_SRA;
                    end
                    else begin
                        ALU_op = 3'b000;
                    end
                end
                default: ALU_op = 3'b000;
            endcase
        end
        OPC_ITYPE: begin
            case(funct3)
                F3_ADD_OR_SUB: ALU_op = ALU_ADD;
                F3_AND: ALU_op = ALU_AND;
                F3_OR: ALU_op = ALU_OR;
                F3_XOR: ALU_op = ALU_XOR;
                F3_SLL: ALU_op = ALU_SLL;
                F3_SR: begin
                    if (funct7 == F7_DEFAULT) begin
                        ALU_op = ALU_SRL;
                    end
                    else if (funct7 == F7_SUB_OR_ARITH) begin
                        ALU_op = ALU_SRA;
                    end
                    else begin
                        ALU_op = 3'b000;
                    end
                end
                default: ALU_op = 3'b000;
            endcase
        end
        OPC_ITYPE_LW: ALU_op = ALU_ADD;
        OPC_STYPE: ALU_op = ALU_ADD;
        // OPC_BTYPE: ALU_op = ALU_SUB; **branch ahead**
        default: ALU_op = 3'b000;
    endcase
end

// ALUb_sel
always @(*) begin
    if (opcode == OPC_RTYPE || opcode == OPC_BTYPE) begin
        ALUb_sel = 1'b0;
    end
    else begin
        ALUb_sel = 1'b1;
    end
end

// SEXT_op
always @(*) begin
    case(opcode)
        OPC_ITYPE: SEXT_op = SEXT_ITYPE;
        OPC_STYPE: SEXT_op = SEXT_STYPE;
        OPC_BTYPE: SEXT_op = SEXT_BTYPE;
        OPC_UTYPE: SEXT_op = SEXT_UTYPE;
        OPC_JTYPE: SEXT_op = SEXT_JTYPE;
        default: SEXT_op = 3'b000;
    endcase
end

// DM_we
always @(*) begin
    if (opcode == OPC_STYPE) begin
        DM_we = 1'b1;
    end
    else begin
        DM_we = 1'b0;
    end
end

// ID_rf1
always @(*) begin
    if (opcode == OPC_RTYPE || opcode == OPC_ITYPE || opcode == OPC_ITYPE_LW ||opcode == OPC_ITYPE_JALR || opcode == OPC_STYPE || opcode == OPC_BTYPE) begin
        ID_rf1 = 1'b1;
    end
    else begin
        ID_rf1 = 1'b0;
    end
end

// ID_rf2
always @(*) begin
    if (opcode == OPC_RTYPE || opcode == OPC_STYPE || opcode == OPC_BTYPE) begin
        ID_rf2 = 1'b1;
    end
    else begin
        ID_rf2 = 1'b0;
    end
end

// load
always @(*) begin
    if (opcode == OPC_ITYPE_LW) begin
        load = 1'b1;
    end
    else begin
        load = 1'b0;
    end
end

// store
always @(*) begin
    if (opcode == OPC_STYPE) begin
        store = 1'b1;
    end
    else begin
        store = 1'b0;
    end
end

// Btype
always @(*) begin
    if (opcode == OPC_BTYPE) begin
        case(funct3)
            F3_BEQ: Btype = 3'b100;
            F3_BNE: Btype = 3'b101;
            F3_BLT: Btype = 3'b110;
            F3_BGE: Btype = 3'b111;
            default: Btype = 3'b000;
        endcase
    end
    else begin
        Btype = 3'b000;
    end
end

// jump
always @(*) begin
    if (opcode == OPC_ITYPE_JALR) begin
        Ijalr = 1'b1;
    end
    else begin
        Ijalr = 1'b0;
    end
end

// Jtype
always @(*) begin
    if (opcode == OPC_JTYPE) begin
        Jtype = 1'b1;
    end
    else begin
        Jtype = 1'b0;
    end
end

endmodule