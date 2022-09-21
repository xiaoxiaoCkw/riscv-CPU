module top (
    input  wire clk_i,
    input  wire rst_i,
    input [23:0] device_sw,
    output wire led0_en_o,
    output wire led1_en_o,
    output wire led2_en_o,
    output wire led3_en_o,
    output wire led4_en_o,
    output wire led5_en_o,
    output wire led6_en_o,
    output wire led7_en_o,
    output wire led_ca_o,
    output wire led_cb_o,
    output wire led_cc_o,
    output wire led_cd_o,
    output wire led_ce_o,
    output wire led_cf_o,
    output wire led_cg_o,
    output wire led_dp_o
);

wire rst_n = ~rst_i;
wire [31:0] display_number;

//wire [31:0] sw_test = {{8{1'b0}}, device_sw};

miniRV u_miniRV(
    .clk_i(clk_i),
    .rst_n(rst_n),
    .device_sw(device_sw),
    .display_number(display_number)
);

led_display u_led_display(
    .clk(clk_i),
    .rst_n(rst_n),
    .display_number(display_number),
    .led0_en(led0_en_o),
    .led1_en(led1_en_o),
    .led2_en(led2_en_o),
    .led3_en(led3_en_o),
    .led4_en(led4_en_o),
    .led5_en(led5_en_o),
    .led6_en(led6_en_o),
    .led7_en(led7_en_o),
    .led_ca(led_ca_o),
    .led_cb(led_cb_o),
    .led_cc(led_cc_o),
    .led_cd(led_cd_o),
    .led_ce(led_ce_o),
    .led_cf(led_cf_o),
    .led_cg(led_cg_o),
    .led_dp(led_dp_o)
);


endmodule