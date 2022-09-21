module RF (
    input clk,
    input rst_n,
    input RF_we,
    input  [4:0]  rR1,
    input  [4:0]  rR2,
    input  [4:0]  wR,
    input  [31:0] wD,
    output [31:0] rD1,
    output [31:0] rD2,
    output [31:0] reg19
);

reg [31:0] RegFile[31:0];

// Synchronous write
integer i;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < 32; i = i + 1) begin
            RegFile[i] <= 32'b0;
        end
    end
    else begin
        if (RF_we && wR != 5'b0) begin
            RegFile[wR] <= wD;
        end
    end
end

// Asynchronous read
assign rD1 = RegFile[rR1];
assign rD2 = RegFile[rR2];

assign reg19 = RegFile[19];

endmodule