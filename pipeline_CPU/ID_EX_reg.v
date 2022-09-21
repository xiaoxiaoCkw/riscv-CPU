module ID_EX_reg (
    input clk,
    input rst_n,
    input stop,
    input ID_load_i,
    input [1:0] ID_WdSel_i,
    input ID_DMwe_i,
    input [2:0] ID_ALUop_i,
    input ID_RFwe_i,
    input [31:0] ID_pc4_i,
    input [31:0] ID_data1_i,
    input [31:0] ID_data2_i,
    input [31:0] ID_imm_i,
    input [31:0] ID_rd2_i,
    input [4:0] ID_rd_i,
    input [31:0] ID_inst_i,
    output reg EX_load_o,
    output reg [1:0] EX_WdSel_o,
    output reg EX_DMwe_o,
    output reg [2:0] EX_ALUop_o,
    output reg EX_RFwe_o,
    output reg [31:0] EX_pc4_o,
    output reg [31:0] EX_ALUa_o,
    output reg [31:0] EX_ALUb_o,
    output reg [31:0] EX_imm_o,
    output reg [31:0] EX_rd2_o,
    output reg [4:0] EX_rd_o,
    output reg [31:0] EX_inst_o,
    output reg ID_stop_o
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        EX_load_o <= 1'b0;
        EX_WdSel_o <= 2'b0;
        EX_DMwe_o <= 1'b0;
        EX_ALUop_o <= 3'b0;
        EX_RFwe_o <= 1'b0;
        EX_pc4_o <= 32'b0;
        EX_ALUa_o <= 32'b0;
        EX_ALUb_o <= 32'b0;
        EX_imm_o <= 32'b0;
        EX_rd2_o <= 32'b0;
        EX_rd_o <= 5'b0;
        EX_inst_o <= 32'b0;
        ID_stop_o <= 1'b0;
    end
    else if (stop) begin
        EX_load_o <= ID_load_i; // When stop, DO NOT store load flag!!! Or the pipeine will stall forever...
        EX_WdSel_o <= EX_WdSel_o;
        EX_DMwe_o <= EX_DMwe_o;
        EX_ALUop_o <= EX_ALUop_o;
        EX_RFwe_o <= EX_RFwe_o;
        EX_pc4_o <= EX_pc4_o;
        EX_ALUa_o <= EX_ALUa_o;
        EX_ALUb_o <= EX_ALUb_o;
        EX_imm_o <= EX_imm_o;
        EX_rd2_o <= EX_rd2_o;
        EX_rd_o <= EX_rd_o;
        EX_inst_o <= EX_inst_o;
        ID_stop_o <= 1'b1;
    end
    else begin
        EX_load_o <= ID_load_i;
        EX_WdSel_o <= ID_WdSel_i;
        EX_DMwe_o <= ID_DMwe_i;
        EX_ALUop_o <= ID_ALUop_i;
        EX_RFwe_o <= ID_RFwe_i;
        EX_pc4_o <= ID_pc4_i;
        EX_ALUa_o <= ID_data1_i;
        EX_ALUb_o <= ID_data2_i;
        EX_imm_o <= ID_imm_i;
        EX_rd2_o <= ID_rd2_i;
        EX_rd_o <= ID_rd_i;
        EX_inst_o <= ID_inst_i;
        ID_stop_o <= 1'b0;
    end
end

endmodule