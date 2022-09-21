module SEXT(
    input      [24:0] inst_i,
    input      [2:0]  sext_op,
    output reg [31:0] imm
);

parameter SEXT_I_TYPE = 'b000,
          SEXT_S_TYPE = 'b001,
          SEXT_B_TYPE = 'b010,
          SEXT_U_TYPE = 'b011,
          SEXT_J_TYPE = 'b100;

always @(*) begin
    case(sext_op)
        SEXT_I_TYPE: imm = {{20{inst_i[24]}}, inst_i[24:13]};
        SEXT_S_TYPE: imm = {{20{inst_i[24]}}, inst_i[24:18], inst_i[4:0]};
        SEXT_B_TYPE: imm = {{19{inst_i[24]}}, inst_i[24], inst_i[0], inst_i[23:18], inst_i[4:1], 1'b0};
        SEXT_U_TYPE: imm = {inst_i[24:5], {12{1'b0}}};
        SEXT_J_TYPE: imm = {{11{inst_i[24]}}, inst_i[24], inst_i[12:5], inst_i[13], inst_i[23:14], 1'b0};
        default: imm = 32'b0;
    endcase
end

endmodule
