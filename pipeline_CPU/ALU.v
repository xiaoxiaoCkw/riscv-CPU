module ALU(
    input      [31:0] alu_a,
    input      [31:0] alu_b,
    input      [2:0]  ALU_op,
    output reg [31:0] alu_c
);

parameter ADD = 3'b000, 
          SUB = 3'b001, 
          AND = 3'b010, 
          OR  = 3'b011, 
          XOR = 3'b100, 
          SLL = 3'b101, 
          SRL = 3'b110, 
          SRA = 3'b111;

reg [31:0] alu_b_current;
          
always @(*) begin
    // ALU operations
    case(ALU_op)
        ADD: alu_c = $signed(alu_a) + $signed(alu_b);
        SUB: alu_c = $signed(alu_a) - $signed(alu_b);
        AND: alu_c = alu_a & alu_b;
        OR : alu_c = alu_a | alu_b;
        XOR: alu_c = alu_a ^ alu_b;
        // **Shift up to 32 bits!!!**
        SLL: alu_c = $signed(alu_a) << alu_b[4:0];
        SRL: alu_c = $signed(alu_a) >> alu_b[4:0];
        SRA: alu_c = $signed(alu_a) >>> alu_b[4:0];
        default: alu_c = 32'b0;
    endcase
end

endmodule