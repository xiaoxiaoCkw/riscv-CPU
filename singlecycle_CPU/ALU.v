module ALU(
    input      [31:0] alu_a,
    input      [31:0] alu_b,
    input      [2:0]  alu_op,
    output reg [31:0] alu_c,
    output reg [2:0]  branch
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
    // ALU calculate
    case(alu_op)
        ADD: alu_c = $signed(alu_a) + $signed(alu_b);
        SUB: alu_c = $signed(alu_a) - $signed(alu_b);
        AND: alu_c = alu_a & alu_b;
        OR : alu_c = alu_a | alu_b;
        XOR: alu_c = alu_a ^ alu_b;
        SLL: begin
            if ($signed(alu_b) < 0) begin
                alu_b_current = alu_b;
//                while ($signed(alu_b_current) < 0) begin
//                    alu_b_current = $signed(alu_b_current) + 32;
//                end
                alu_b_current = {{27{1'b0}}, alu_b_current[4:0]};
            end
            else begin
                alu_b_current = {{27{1'b0}}, alu_b[4:0]};
            end
            alu_c = $signed(alu_a) << alu_b_current;
        end
        SRL: begin
            if ($signed(alu_b) < 0) begin
                alu_b_current = alu_b;
//                while ($signed(alu_b_current) < 0) begin
//                    alu_b_current = $signed(alu_b_current) + 32;
//                end
                alu_b_current = {{27{1'b0}}, alu_b_current[4:0]};
            end
            else begin
                alu_b_current = {{27{1'b0}}, alu_b[4:0]};
            end
            alu_c = $signed(alu_a) >> alu_b_current;
        end
        SRA: begin
            if ($signed(alu_b) < 0) begin
                alu_b_current = alu_b;
//                while ($signed(alu_b_current) < 0) begin
//                    alu_b_current = $signed(alu_b_current) + 32;
//                end
                alu_b_current = {{27{1'b0}}, alu_b_current[4:0]};
            end
            else begin
                alu_b_current = {{27{1'b0}}, alu_b[4:0]};
            end
            alu_c = $signed(alu_a) >>> alu_b_current;
        end
        default: alu_c = 32'b0;
    endcase
    
    // branch result
    if (alu_op == SUB) begin
        // alu_a = alu_b
        if (alu_c == 0) begin
            branch = 3'b001;
        end
        // alu_a < alu_b
        else if ($signed(alu_c) < 0) begin
            branch = 3'b010;
        end
        // alu_a > alu_b
        else begin
            branch = 3'b100;
        end
    end
end
endmodule
