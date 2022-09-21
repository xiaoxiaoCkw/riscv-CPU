module MEM_WB_reg (
    input clk,
    input rst_n,
    input stop,
    input [1:0] MEM_WdSel_i,
    input MEM_RFwe_i,
    input [31:0] MEM_pc4_i,
    input [31:0] MEM_ALUc_i,
    input [31:0] MEM_DMdata_i,
    input [31:0] MEM_imm_i,
    input [4:0] MEM_rd_i,
    input [31:0] MEM_inst_i,
    input MEM_IDstop_i,
    output reg [1:0] WB_WdSel_o,
    output reg WB_RFwe_o,
    output reg [31:0] WB_pc4_o,
    output reg [31:0] WB_ALUc_o,
    output reg [31:0] WB_DMdata_o,
    output reg [31:0] WB_imm_o,
    output reg [4:0] WB_rd_o,
    output reg [31:0] WB_inst_o,
    output reg WB_IDstop_o
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        WB_WdSel_o <= 2'b0;
        WB_RFwe_o <= 1'b0;
        WB_pc4_o <= 32'b0;
        WB_ALUc_o <= 32'b0;
        WB_DMdata_o <= 32'b0; 
        WB_imm_o <= 32'b0;
        WB_rd_o <= 5'b0;
        WB_inst_o <= 32'b0;
        WB_IDstop_o <= 1'b0;
    end
    else if (stop) begin
        WB_WdSel_o <= WB_WdSel_o;
        WB_RFwe_o <= WB_RFwe_o;
        WB_pc4_o <= WB_pc4_o;
        WB_ALUc_o <= WB_ALUc_o;
        WB_DMdata_o <= WB_DMdata_o;
        WB_imm_o <= WB_imm_o;
        WB_rd_o <= WB_rd_o;
        WB_inst_o <= WB_inst_o;
        WB_IDstop_o <= WB_IDstop_o;
    end
    else begin
        WB_WdSel_o <= MEM_WdSel_i;
        WB_RFwe_o <= MEM_RFwe_i;
        WB_pc4_o <= MEM_pc4_i;
        WB_ALUc_o <= MEM_ALUc_i;
        WB_DMdata_o <= MEM_DMdata_i;
        WB_imm_o <= MEM_imm_i;
        WB_rd_o <= MEM_rd_i;
        WB_inst_o <= MEM_inst_i;
        WB_IDstop_o <= MEM_IDstop_i;
    end
end

endmodule