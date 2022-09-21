module SEXT(
    input      [24:0] inst,
    input      [2:0]  SEXT_op,
    output reg [31:0] imm
);

parameter SEXT_ITYPE = 'b000,
          SEXT_STYPE = 'b001,
          SEXT_BTYPE = 'b010,
          SEXT_UTYPE = 'b011,
          SEXT_JTYPE = 'b100;

always @(*) begin
    case(SEXT_op)
        SEXT_ITYPE: imm = {{20{inst[24]}}, inst[24:13]};
        SEXT_STYPE: imm = {{20{inst[24]}}, inst[24:18], inst[4:0]};
        SEXT_BTYPE: imm = {{19{inst[24]}}, inst[24], inst[0], inst[23:18], inst[4:1], 1'b0};
        SEXT_UTYPE: imm = {inst[24:5], {12{1'b0}}};
        SEXT_JTYPE: imm = {{11{inst[24]}}, inst[24], inst[12:5], inst[13], inst[23:14], 1'b0};
        default: imm = 32'b0;
    endcase
end

endmodule
