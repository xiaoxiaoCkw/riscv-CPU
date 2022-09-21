module DRAM(
    input clk_i,
//    input rst_n,
    input [31:0] addr,
    input Wen,
    input [31:0] datain,
    input [23:0] device_sw,
    output reg [31:0] device_led,
    output reg [31:0] dataout
);

wire [31:0] dm_data;

// 拨码开关
always @(*) begin
    if (addr == 32'hFFFF_F070) begin
        dataout <= {{8{1'b0}},device_sw};
    end
    else begin
        dataout <= dm_data;
    end
end

// 数码管
always @(posedge clk_i) begin
    if (addr == 32'hFFFF_F000 && Wen) begin
        device_led <= datain;
    end
    else begin
        device_led <= device_led;
    end
end


// 64KB DRAM
wire [31:0] waddr_tmp = addr - 16'h4000;

dram U_dram (
    .clk    (clk_i),            // input wire clka
    .a      (waddr_tmp[15:2]),     // input wire [13:0] addra
    .spo    (dm_data),        // output wire [31:0] douta
    .we     (Wen),          // input wire [0:0] wea
    .d      (datain)         // input wire [31:0] dina
);

endmodule
