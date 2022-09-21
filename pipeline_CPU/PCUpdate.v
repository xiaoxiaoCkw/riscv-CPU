module PCUpdate (
    input [31:0] pc_i,
    input [31:0] npc,
    input [2:0] Btype,
    input [2:0] branch_result,
    input Ijalr,
    input Jtype,
    output reg [31:0] pc_o
);

parameter BRANCH_EQ = 'b001,
          BRANCH_LT = 'b010,
          BRANCH_GT = 'b100;

// reg jump_flag; // If last instruction has jumped(B-type, I-jalr or J-type), flag = 1. Or flag = 0.

always @(*) begin
    case (Btype)
        3'b000: begin // not B-type
            if (Ijalr || Jtype) begin
                pc_o = npc;
                // jump_flag = 1'b1;
            end
            // else if (jump_flag) begin
            //     // if (pc_i == 32'h00000008) begin
            //     //     pc_o = pc_i;
            //     //     jump_flag = 1'b0;
            //     // end
            //     // else begin
            //     pc_o = pc_i + 4;
            //     jump_flag = 1'b0;
            //     // end
            // end
            else begin
                pc_o = pc_i;
                // jump_flag = 1'b0;
            end
        end
        3'b100: begin // beq
            if (branch_result == BRANCH_EQ) begin
                pc_o = npc;
                // jump_flag = 1'b1;
            end
            else begin
                // if (jump_flag) begin
                //     // pc_o = pc_i + 4;
                //     pc_o = pc_i;
                //     jump_flag = 1'b0;
                // end
                // else begin
                    pc_o = pc_i;
                    // jump_flag = 1'b0;
                // end
            end
        end
        3'b101: begin //bne
            if (branch_result != BRANCH_EQ) begin
                pc_o = npc;
                // jump_flag = 1'b1;
            end
            else begin
                // if (jump_flag) begin
                //     pc_o = pc_i + 4;
                //     jump_flag = 1'b0;
                // end
                // else begin
                    pc_o = pc_i;
                    // jump_flag = 1'b0;
                // end
            end
        end
        3'b110: begin //blt
            if (branch_result == BRANCH_LT) begin
                pc_o = npc;
                // jump_flag = 1'b1;
            end
            else begin
                // if (jump_flag) begin
                //     pc_o = pc_i + 4;
                //     jump_flag = 1'b0;
                // end
                // else begin
                    pc_o = pc_i;
                    // jump_flag = 1'b0;
                // end
            end
        end
        3'b111: begin // bge
            if (branch_result == BRANCH_EQ || branch_result == BRANCH_GT) begin
                pc_o = npc;
                // jump_flag = 1'b1;
            end
            else begin
                // if (jump_flag) begin
                //     pc_o = pc_i + 4;
                //     jump_flag = 1'b0;
                // end
                // else begin
                    pc_o = pc_i;
                    // jump_flag = 1'b0;
                // end
            end
        end
        default: begin
            // if (jump_flag) begin
            //     pc_o = pc_i + 4;
            //     jump_flag = 1'b0;
            // end
            // else begin
                pc_o = pc_i;
                // jump_flag = 1'b0;
            // end
        end
    endcase
end

endmodule