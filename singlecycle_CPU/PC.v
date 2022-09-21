module PC (
    input             clk_i,
    input             rst_n,
    input      [31:0] npc_i,
    output reg [31:0] pc_o
);

always @(posedge clk_i or negedge rst_n) begin
    if (~rst_n) begin
        pc_o <= -4; // -4?
    end
    else begin
        pc_o <= npc_i;
    end
end

endmodule

