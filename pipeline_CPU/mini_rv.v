module mini_rv(
    input clk,
    input rst_n,
    output [31:0] display_number
);

wire locked;
wire cpu_clk;

wire [31:0] inst;

wire [31:0] DM_data;

wire EX_IDstop;
wire MEM_IDstop;
wire WB_IDstop;

wire stop;

wire [31:0] pc;
wire [31:0] pc_new;
wire [31:0] pc4 = pc_new + 4;

wire [31:0] ID_pc;
wire [31:0] ID_pc4;
wire [31:0] ID_inst;

wire [1:0] NPC_op;
wire [31:0] NPC_npc_tmp; // npc not including (pc + 4)
wire NPCSel = NPC_op[0] | NPC_op[1];
wire [31:0] NPC_npc = NPCSel ? NPC_npc_tmp : pc4;

wire [31:0] npc = stop ? pc_new : NPC_npc;

wire [2:0] branch_result;
wire RF_we;
wire [1:0] Wd_sel;
wire [2:0] ALU_op;
wire ALUb_sel;
wire [2:0] SEXT_op;
wire DM_we;
wire ID_rf1;
wire ID_rf2;
wire load;
wire store;
wire [2:0] Btype;
wire Ijalr;
wire Jtype;

wire [31:0] imm;

wire [31:0] rD1;
wire [31:0] rD2;
wire [31:0] data2 = ALUb_sel ? imm : rD2;

wire EX_load;
wire [1:0] EX_WdSel;
wire EX_DMwe;
wire [2:0] EX_ALUop;
wire EX_RFwe;
wire [31:0] EX_pc4;
wire [31:0] EX_ALUa;
wire [31:0] EX_ALUb;
wire [31:0] EX_imm;
wire [31:0] EX_rd2;
wire [4:0] EX_rd;
wire [31:0] EX_inst;

wire [31:0] ALU_c;

wire [1:0] MEM_WdSel;
wire MEM_DMwe;
wire MEM_RFwe;
wire [31:0] MEM_pc4;
wire [31:0] MEM_ALUc;
wire [31:0] MEM_imm;
wire [31:0] MEM_rd2;
wire [4:0] MEM_rd;
wire [31:0] MEM_inst;

wire [1:0] WB_WdSel;
wire WB_RFwe;
wire [31:0] WB_pc4;
wire [31:0] WB_ALUc;
wire [31:0] WB_DMdata;
wire [31:0] WB_imm;
wire [4:0] WB_rd;
wire [31:0] WB_inst;

wire [31:0] forward_data1;
wire [31:0] forward_data2;
wire [31:0] forward_rD2;

wire [31:0] wD = (WB_WdSel == 2'b00) ? WB_ALUc   :
                 (WB_WdSel == 2'b01) ? WB_DMdata :
                 (WB_WdSel == 2'b10) ? WB_pc4    :
                                       WB_imm    ;

cpuclk U_cpuclk (
    .clk_in1(clk),
    .locked(locked),
    .clk_out1(cpu_clk)
);

// **IF**
// PC
PC u_PC (
    .clk(cpu_clk),
    .rst_n(rst_n),
    .npc(npc),
    .pc(pc)
);

PCUpdate u_PCUpdate (
    .pc_i(pc),
    .npc(NPC_npc_tmp),
    .Btype(Btype),
    .branch_result(branch_result),
    .Ijalr(Ijalr),
    .Jtype(Jtype),
    .pc_o(pc_new)
);

// IROM
// 64KB IROM
prgrom U0_irom (
    .a      (pc_new[15:2]),   // input wire [13:0] a
    .spo    (inst)            // output wire [31:0] spo
);

// IF/ID reg
IF_ID_reg u_IF_ID_reg (
    .clk(cpu_clk),
    .rst_n(rst_n),
    .stop(stop),
    .IF_pc_i(pc_new),
    .IF_pc4_i(pc4),
    .IF_inst_i(inst),
    .ID_pc_o(ID_pc),
    .ID_pc4_o(ID_pc4),
    .ID_inst_o(ID_inst)
);

// **ID**
// CTRL
CTRL u_CTRL (
    .opcode         (ID_inst[6:0]),
    .funct3         (ID_inst[14:12]),
    .funct7         (ID_inst[31:25]),
    .branch_result  (branch_result),
    .NPC_op         (NPC_op),
    .RF_we          (RF_we),
    .Wd_sel         (Wd_sel),
    .ALU_op         (ALU_op),
    .ALUb_sel       (ALUb_sel),
    .SEXT_op        (SEXT_op),
    .DM_we          (DM_we),
    .ID_rf1         (ID_rf1),
    .ID_rf2         (ID_rf2),
    .load           (load),
    .store          (store),
    .Btype          (Btype),
    .Ijalr          (Ijalr),
    .Jtype          (Jtype)
);

// RF
RF u_RF (
    .clk(cpu_clk),
    .rst_n(rst_n),
    .RF_we(WB_RFwe),
    .rR1(ID_inst[19:15]),
    .rR2(ID_inst[24:20]),
    .wR(WB_rd),
    .wD(wD),
    .rD1(rD1),
    .rD2(rD2),
    .reg19(display_number)
);

// SEXT
SEXT u_SEXT (
    .inst(ID_inst[31:7]),
    .SEXT_op(SEXT_op),
    .imm(imm)
);

// NPC
NPC u_NPC (
    .NPC_op(NPC_op),
    .pc(ID_pc),
    .imm(imm),
    .ra(forward_data1),
    .npc(NPC_npc_tmp)
);

// branch
branch u_branch (
    .data1(forward_data1),
    .data2(forward_rD2),
    .branch_result(branch_result)
);

// ID/EX reg
ID_EX_reg u_ID_EX_reg (
    .clk(cpu_clk),
    .rst_n(rst_n),
    .stop(stop),
    .ID_load_i(load),
    .ID_WdSel_i(Wd_sel),
    .ID_DMwe_i(DM_we),
    .ID_ALUop_i(ALU_op),
    .ID_RFwe_i(RF_we),
    .ID_pc4_i(ID_pc4),
    .ID_data1_i(forward_data1),
    .ID_data2_i(forward_data2),
    .ID_imm_i(imm),
    .ID_rd2_i(forward_rD2),
    .ID_rd_i(ID_inst[11:7]),
    .ID_inst_i(ID_inst),
    .EX_load_o(EX_load),
    .EX_WdSel_o(EX_WdSel),
    .EX_DMwe_o(EX_DMwe),
    .EX_ALUop_o(EX_ALUop),
    .EX_RFwe_o(EX_RFwe),
    .EX_pc4_o(EX_pc4),
    .EX_ALUa_o(EX_ALUa),
    .EX_ALUb_o(EX_ALUb),
    .EX_imm_o(EX_imm),
    .EX_rd2_o(EX_rd2),
    .EX_rd_o(EX_rd),
    .EX_inst_o(EX_inst),
    .ID_stop_o(EX_IDstop)
);

// **EX**
// ALU
ALU u_ALU (
    .alu_a(EX_ALUa),
    .alu_b(EX_ALUb),
    .ALU_op(EX_ALUop),
    .alu_c(ALU_c)
);

wire [31:0] EX_wd = (EX_WdSel == 2'b00) ? ALU_c  :
                    (EX_WdSel == 2'b01) ? 32'b0  :
                    (EX_WdSel == 2'b10) ? EX_pc4 :
                                          EX_imm ;

// EX/MEM reg
EX_MEM_reg u_EX_MEM_reg (
    .clk(cpu_clk),
    .rst_n(rst_n),
    .stop(1'b0),
    .EX_WdSel_i(EX_WdSel),
    .EX_DMwe_i(EX_DMwe),
    .EX_RFwe_i(EX_RFwe),
    .EX_pc4_i(EX_pc4),
    .EX_ALUc_i(ALU_c),
    .EX_imm_i(EX_imm),
    .EX_rd2_i(EX_rd2),
    .EX_rd_i(EX_rd),
    .EX_inst_i(EX_inst),
    .EX_IDstop_i(EX_IDstop),
    .MEM_WdSel_o(MEM_WdSel),
    .MEM_DMwe_o(MEM_DMwe),
    .MEM_RFwe_o(MEM_RFwe),
    .MEM_pc4_o(MEM_pc4),
    .MEM_ALUc_o(MEM_ALUc),
    .MEM_imm_o(MEM_imm),
    .MEM_rd2_o(MEM_rd2),
    .MEM_rd_o(MEM_rd),
    .MEM_inst_o(MEM_inst),
    .MEM_IDstop_o(MEM_IDstop)
);

// **MEM**
// DRAM
// 64KB DRAM
wire [31:0] waddr_tmp = MEM_ALUc - 16'h4000;

dram U_dram (
    .clk    (cpu_clk),            // input wire clka
    .a      (waddr_tmp[15:2]),    // input wire [13:0] addra
    .spo    (DM_data),            // output wire [31:0] douta
    .we     (MEM_DMwe),           // input wire [0:0] wea
    .d      (MEM_rd2)             // input wire [31:0] dina
);

wire [31:0] MEM_wd = (MEM_WdSel == 2'b00) ? MEM_ALUc :
                     (MEM_WdSel == 2'b01) ? DM_data  :
                     (MEM_WdSel == 2'b10) ? MEM_pc4  :
                                            MEM_imm  ;

// MEM/WB reg
MEM_WB_reg u_MEM_WB_reg (
    .clk(cpu_clk),
    .rst_n(rst_n),
    .stop(1'b0),
    .MEM_WdSel_i(MEM_WdSel),
    .MEM_RFwe_i(MEM_RFwe),
    .MEM_pc4_i(MEM_pc4),
    .MEM_ALUc_i(MEM_ALUc),
    .MEM_DMdata_i(DM_data),
    .MEM_imm_i(MEM_imm),
    .MEM_rd_i(MEM_rd),
    .MEM_inst_i(MEM_inst),
    .MEM_IDstop_i(MEM_IDstop),
    .WB_WdSel_o(WB_WdSel),
    .WB_RFwe_o(WB_RFwe),
    .WB_pc4_o(WB_pc4),
    .WB_ALUc_o(WB_ALUc),
    .WB_DMdata_o(WB_DMdata),
    .WB_imm_o(WB_imm),
    .WB_rd_o(WB_rd),
    .WB_inst_o(WB_inst),
    .WB_IDstop_o(WB_IDstop)
);

// Data Hazard Detection Logic
Data_Hazard_Detection u_Data_Hazard_Detection (
    .ID_rs1(ID_inst[19:15]),
    .ID_rs2(ID_inst[24:20]),
    .ID_data1(rD1),
    .ID_data2(data2),
    .ID_rD2(rD2),
    .ID_rf1(ID_rf1),
    .ID_rf2(ID_rf2),
    .ID_store(store),
    .EX_wd(EX_wd),
    .EX_rd(EX_rd),
    .EX_we(EX_RFwe),
    .EX_load(EX_load),
    .MEM_wd(MEM_wd),
    .MEM_rd(MEM_rd),
    .MEM_we(MEM_RFwe),
    .WB_rd(WB_rd),
    .WB_wd(wD),
    .WB_we(WB_RFwe),
    .stop(stop),
    .forward_data1(forward_data1),
    .forward_data2(forward_data2),
    .forward_rD2(forward_rD2)
);

endmodule
