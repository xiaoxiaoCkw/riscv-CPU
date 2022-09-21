module NPC(
    input  [1:0]  npc_op_i,
    input  [31:0] pc_i,
    input  [31:0] imm_i,
    input  [31:0] ra_i,
    output [31:0] pc4_o,
    output reg [31:0] npc_o
);

parameter PC4 = 2'b00,
           RA = 2'b01,
           IMM = 2'b10;

assign pc4_o = pc_i + 4;

always @(*) begin
    case(npc_op_i)
        PC4: npc_o = pc_i + 4;
        RA: npc_o = ra_i + imm_i;
        IMM: npc_o = pc_i + imm_i;
        default: npc_o = 32'b0;
    endcase
end

endmodule
