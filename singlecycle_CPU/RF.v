module RF(
    input         clk_i,
    input         rst_n,
    input         RF_we_i,
    input  [31:0] inst_i,
    input  [31:0] wD_i,
    output [31:0] rD1_o,
    output [31:0] rD2_o,
    output [31:0] Reg19
);

reg [31:0] RegFile[31:0];
wire [4:0] rR1;
wire [4:0] rR2;
wire [4:0] wR;

assign wR = inst_i[11:7];
assign rR1 = inst_i[19:15];
assign rR2 = inst_i[24:20];

// Í¬²½Ð´
integer i;
always @(posedge clk_i or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < 32; i = i + 1) begin
            RegFile[i] <= 32'b0;
        end
    end
    else begin
        if (RF_we_i && wR != 5'b0) begin
            RegFile[wR] <= wD_i;
        end
    end
end

// Òì²½¶Á
assign rD1_o = RegFile[rR1];
assign rD2_o = RegFile[rR2];

assign Reg19 = RegFile[19];

endmodule
