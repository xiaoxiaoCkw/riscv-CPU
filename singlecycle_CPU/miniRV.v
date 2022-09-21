module miniRV(
    input clk_i,
    input rst_n,
    input [23:0] device_sw,
//    output [31:0] device_led
    output [31:0] display_number
//    input [31:0] instruction,
//    input [31:0] dm_data,
//    output [31:0] pc_o,
//    output DM_we,
//    output [31:0] wr_addr,
//    output [31:0] wr_data,
//    output wb_ena,
//    output [4:0] wb_reg,
//    output [31:0] wb_value
);

wire cpuclk;
wire locked;
wire [31:0] instruction;
wire [31:0] pc_o;
wire [1:0] NPC_op;
wire [31:0] npc_o;
wire [31:0] pc4_o;
wire [31:0] imm;
wire [31:0] wD;
wire [31:0] wR;
wire [31:0] rD1;
wire [31:0] rD2;
wire [31:0] alu_b;
wire [2:0] ALU_op;
wire [31:0] alu_c;
wire [2:0] branch_result;
wire RF_we;
wire [2:0] SEXT_op;
wire [31:0] dm_data;
wire DM_we;
wire [1:0] Wd_sel;
wire ALUb_sel;

//wire [31:0] tmp;
//wire [31:0] tmp_data;

assign wD = (Wd_sel == 2'b00) ? alu_c : ((Wd_sel == 2'b01) ? dm_data : ((Wd_sel == 2'b10) ? pc4_o : imm));
assign alu_b = (ALUb_sel) ? imm : rD2;

//assign display_number = (instruction[6:0] == 7'b0100011) ? rD2 : 32'b0;
//assign dm_data = (instruction[6:0] == 7'b0000011) ? {{8{1'b0}},device_sw} : tmp_data;
//assign wr_addr = alu_c;
//assign wr_data = rD2;
//assign wb_ena = RF_we;
//assign wb_value = wD;

cpuclk U_cpuclk (
    .clk_in1    (clk_i),
    .clk_out1   (cpuclk),
    .locked     (locked)
);

CTRL u_CTRL (
    .opcode     (instruction[6:0]),
    .funct3     (instruction[14:12]),
    .funct7     (instruction[31:25]),
    .branch     (branch_result),
    .NPC_op     (NPC_op),
    .RF_we      (RF_we),
    .Wd_sel     (Wd_sel),
    .ALU_op     (ALU_op),
    .ALUb_sel   (ALUb_sel),
    .SEXT_op    (SEXT_op),
    .DM_we      (DM_we)
);

PC u_PC (
    .clk_i      (cpuclk),
    .rst_n      (rst_n),
    .npc_i      (npc_o),
    .pc_o       (pc_o)
);

NPC u_NPC (
    .npc_op_i   (NPC_op),
    .pc_i       (pc_o),
    .imm_i      (imm),
    .ra_i       (rD1),
    .pc4_o      (pc4_o),
    .npc_o      (npc_o)
);

// 64KB IROMS
prgrom U0_irom (
    .a          (pc_o[15:2]),   // input wire [13:0] a
    .spo        (instruction)   // output wire [31:0] spo
);

RF u_RF (
    .clk_i      (cpuclk),
    .rst_n      (rst_n),
    .RF_we_i    (RF_we),
    .inst_i     (instruction),
    .wD_i       (wD),
    .rD1_o      (rD1),
    .rD2_o      (rD2),
    .Reg19      (display_number)
);

ALU u_ALU (
    .alu_a      (rD1),
    .alu_b      (alu_b),
    .alu_op     (ALU_op),
    .alu_c      (alu_c),
    .branch     (branch_result)
);

SEXT u_SEXT (
    .inst_i     (instruction[31:7]),
    .sext_op    (SEXT_op),
    .imm        (imm)
);

wire [31:0] tmp;
DRAM u_DRAM (
    .clk_i      (cpuclk),
//    .rst_n      (rst_n),
    .addr       (alu_c),
    .Wen        (DM_we),
    .datain     (rD2),
    .device_sw  (device_sw),
    .device_led (tmp),
    .dataout    (dm_data)
);

endmodule
