module EX_MEM_reg (
    input clk,
    input rst_n,
    input stop,
    input [1:0] EX_WdSel_i,
    input EX_DMwe_i,
    input EX_RFwe_i,
    input [31:0] EX_pc4_i,
    input [31:0] EX_ALUc_i,
    input [31:0] EX_imm_i,
    input [31:0] EX_rd2_i,
    input [4:0] EX_rd_i,
    input [31:0] EX_inst_i,
    input EX_IDstop_i,
    output reg [1:0] MEM_WdSel_o,
    output reg MEM_DMwe_o,
    output reg MEM_RFwe_o,
    output reg [31:0] MEM_pc4_o,
    output reg [31:0] MEM_ALUc_o,
    output reg [31:0] MEM_imm_o,
    output reg [31:0] MEM_rd2_o,
    output reg [4:0] MEM_rd_o,
    output reg [31:0] MEM_inst_o,
    output reg MEM_IDstop_o
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        MEM_WdSel_o <= 2'b0;
        MEM_DMwe_o <= 1'b0;
        MEM_RFwe_o <= 1'b0;
        MEM_pc4_o <= 32'b0;
        MEM_ALUc_o <= 32'b0;
        MEM_imm_o <= 32'b0;
        MEM_rd2_o <= 32'b0;
        MEM_rd_o <= 5'b0;
        MEM_inst_o <= 32'b0;
        MEM_IDstop_o <= 1'b0;
    end
    else if (stop) begin
        MEM_WdSel_o <= MEM_WdSel_o;
        MEM_DMwe_o <= MEM_DMwe_o;
        MEM_RFwe_o <= MEM_RFwe_o;
        MEM_pc4_o <= MEM_pc4_o;
        MEM_ALUc_o <= MEM_ALUc_o;
        MEM_imm_o <= MEM_imm_o;
        MEM_rd2_o <= MEM_rd2_o;
        MEM_rd_o <= MEM_rd_o;
        MEM_inst_o <= MEM_inst_o;
        MEM_IDstop_o <= MEM_IDstop_o;
    end
    else begin
        MEM_WdSel_o <= EX_WdSel_i;
        MEM_DMwe_o <= EX_DMwe_i;
        MEM_RFwe_o <= EX_RFwe_i;
        MEM_pc4_o <= EX_pc4_i;
        MEM_ALUc_o <= EX_ALUc_i;
        MEM_imm_o <= EX_imm_i;
        MEM_rd2_o <= EX_rd2_i;
        MEM_rd_o <= EX_rd_i;
        MEM_inst_o <= EX_inst_i;
        MEM_IDstop_o <= EX_IDstop_i;
    end
end

endmodule