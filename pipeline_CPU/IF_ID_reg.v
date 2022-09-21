module IF_ID_reg (
    input clk,
    input rst_n,
    input stop,
    input [31:0] IF_pc_i,
    input [31:0] IF_pc4_i,
    input [31:0] IF_inst_i,
    output reg [31:0] ID_pc_o,
    output reg [31:0] ID_pc4_o,
    output reg [31:0] ID_inst_o
);

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ID_pc_o <= 32'b0;
        ID_pc4_o <= 32'b0;
        ID_inst_o <= 32'b0;
    end
    else if (stop) begin
        ID_pc_o <= ID_pc_o;
        ID_pc4_o <= ID_pc4_o;
        ID_inst_o <= ID_inst_o;
    end
    else begin
        ID_pc_o <= IF_pc_i;
        ID_pc4_o <= IF_pc4_i;
        ID_inst_o <= IF_inst_i;
    end
end

endmodule