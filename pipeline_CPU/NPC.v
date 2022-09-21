module NPC (
    input [1:0] NPC_op,
    input [31:0] pc,
    input [31:0] imm,
    input [31:0] ra,
    output reg [31:0] npc
);

parameter PC4 = 2'b00,
          RA  = 2'b01,
          IMM = 2'b10;

always @(*) begin
    case (NPC_op)
        PC4: npc = pc + 4;
        RA: npc = ra + imm;
        IMM: npc = pc + imm;
        default: npc = 32'b0;
    endcase
end

endmodule