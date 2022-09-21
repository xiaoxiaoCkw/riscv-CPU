module led_display(
    input clk   ,
	input rst_n ,
	(* DONT_TOUCH = "1" *) input [31:0] display_number,
	output led0_en,
	output led1_en,
	output led2_en,
	output led3_en,
	output led4_en,
	output led5_en,
	output led6_en,
	output led7_en,
	output reg led_ca,
	output reg led_cb,
    output reg led_cc,
	output reg led_cd,
	output reg led_ce,
	output reg led_cf,
	output reg led_cg,
	output led_dp 
);

reg [7:0] led_en;
reg [24:0] cnt2ms;

assign led0_en = led_en[0];
assign led1_en = led_en[1];
assign led2_en = led_en[2];
assign led3_en = led_en[3];
assign led4_en = led_en[4];
assign led5_en = led_en[5];
assign led6_en = led_en[6];
assign led7_en = led_en[7];

assign led_dp = 1'b1;

always @(posedge clk or negedge rst_n) begin
	if(~rst_n)		cnt2ms <= 25'b0;
	else if(cnt2ms == 200_000-1)	cnt2ms <= 25'b0;
	else cnt2ms <= cnt2ms + 25'b1;
end

always @(posedge clk or negedge rst_n) begin
	if(~rst_n) led_en <= 8'b1111_1111;
	else if(cnt2ms == 200_000-1) begin
		if(led_en == 8'b1111_1111)	led_en <= 8'b1111_1110;
		else	led_en <= {led_en[6:0], led_en[7]};
	end
end

always @(posedge clk) begin
	case(led_en)
		8'b1111_1110: begin
			 case(display_number[3:0])
			     4'b0000: begin // 0
			        led_ca <= 1'b0;
                    led_cb <= 1'b0;
                    led_cc <= 1'b0;
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b1;
                 end
                 4'b0001: begin // 1
                    led_ca <= 1'b1; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b1;
                    led_cg <= 1'b1;
                 end
                 4'b0010: begin // 2
                    led_ca <= 1'b0;
                    led_cb <= 1'b0;
                    led_cc <= 1'b1;
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b0011: begin // 3
                    led_ca <= 1'b0;
                    led_cb <= 1'b0;
                    led_cc <= 1'b0;
                    led_cd <= 1'b0;
                    led_ce <= 1'b1;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b0100: begin // 4
                    led_ca <= 1'b1; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b0101: begin // 5
                    led_ca <= 1'b0;
                    led_cb <= 1'b1;
                    led_cc <= 1'b0;
                    led_cd <= 1'b0;
                    led_ce <= 1'b1;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b0110: begin // 6
                    led_ca <= 1'b0; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b0111: begin // 7
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b1;
                    led_cg <= 1'b1;
                 end
                 4'b1000: begin // 8
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1001: begin // 9
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1010: begin // a
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1011: begin // b
                    led_ca <= 1'b1; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1100: begin // c
                    led_ca <= 1'b1; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b1; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b1101: begin // d
                    led_ca <= 1'b1; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b1110: begin // e
                    led_ca <= 1'b0; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b1; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1111: begin // f
                    led_ca <= 1'b0; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b1; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 default: begin
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
             endcase
		end
		8'b1111_1101: begin 
		     case(display_number[7:4])
			     4'b0000: begin // 0
			        led_ca <= 1'b0;
                    led_cb <= 1'b0;
                    led_cc <= 1'b0;
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b1;
                 end
                 4'b0001: begin // 1
                    led_ca <= 1'b1; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b1;
                    led_cg <= 1'b1;
                 end
                 4'b0010: begin // 2
                    led_ca <= 1'b0;
                    led_cb <= 1'b0;
                    led_cc <= 1'b1;
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b0011: begin // 3
                    led_ca <= 1'b0;
                    led_cb <= 1'b0;
                    led_cc <= 1'b0;
                    led_cd <= 1'b0;
                    led_ce <= 1'b1;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b0100: begin // 4
                    led_ca <= 1'b1; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b0101: begin // 5
                    led_ca <= 1'b0;
                    led_cb <= 1'b1;
                    led_cc <= 1'b0;
                    led_cd <= 1'b0;
                    led_ce <= 1'b1;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b0110: begin // 6
                    led_ca <= 1'b0; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b0111: begin // 7
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b1;
                    led_cg <= 1'b1;
                 end
                 4'b1000: begin // 8
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1001: begin // 9
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1010: begin // a
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1011: begin // b
                    led_ca <= 1'b1; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1100: begin // c
                    led_ca <= 1'b1; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b1; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b1101: begin // d
                    led_ca <= 1'b1; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b1110: begin // e
                    led_ca <= 1'b0; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b1; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1111: begin // f
                    led_ca <= 1'b0; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b1; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 default: begin
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
             endcase
		end
		8'b1111_1011: begin
			 case(display_number[11:8])
			     4'b0000: begin // 0
			        led_ca <= 1'b0;
                    led_cb <= 1'b0;
                    led_cc <= 1'b0;
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b1;
                 end
                 4'b0001: begin // 1
                    led_ca <= 1'b1; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b1;
                    led_cg <= 1'b1;
                 end
                 4'b0010: begin // 2
                    led_ca <= 1'b0;
                    led_cb <= 1'b0;
                    led_cc <= 1'b1;
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b0011: begin // 3
                    led_ca <= 1'b0;
                    led_cb <= 1'b0;
                    led_cc <= 1'b0;
                    led_cd <= 1'b0;
                    led_ce <= 1'b1;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b0100: begin // 4
                    led_ca <= 1'b1; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b0101: begin // 5
                    led_ca <= 1'b0;
                    led_cb <= 1'b1;
                    led_cc <= 1'b0;
                    led_cd <= 1'b0;
                    led_ce <= 1'b1;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b0110: begin // 6
                    led_ca <= 1'b0; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b0111: begin // 7
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b1;
                    led_cg <= 1'b1;
                 end
                 4'b1000: begin // 8
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1001: begin // 9
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1010: begin // a
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1011: begin // b
                    led_ca <= 1'b1; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1100: begin // c
                    led_ca <= 1'b1; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b1; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b1101: begin // d
                    led_ca <= 1'b1; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b1110: begin // e
                    led_ca <= 1'b0; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b1; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1111: begin // f
                    led_ca <= 1'b0; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b1; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 default: begin
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
             endcase
		end
		8'b1111_0111: begin 
			 case(display_number[15:12])
			     4'b0000: begin // 0
			        led_ca <= 1'b0;
                    led_cb <= 1'b0;
                    led_cc <= 1'b0;
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b1;
                 end
                 4'b0001: begin // 1
                    led_ca <= 1'b1; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b1;
                    led_cg <= 1'b1;
                 end
                 4'b0010: begin // 2
                    led_ca <= 1'b0;
                    led_cb <= 1'b0;
                    led_cc <= 1'b1;
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b0011: begin // 3
                    led_ca <= 1'b0;
                    led_cb <= 1'b0;
                    led_cc <= 1'b0;
                    led_cd <= 1'b0;
                    led_ce <= 1'b1;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b0100: begin // 4
                    led_ca <= 1'b1; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b0101: begin // 5
                    led_ca <= 1'b0;
                    led_cb <= 1'b1;
                    led_cc <= 1'b0;
                    led_cd <= 1'b0;
                    led_ce <= 1'b1;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b0110: begin // 6
                    led_ca <= 1'b0; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b0111: begin // 7
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b1;
                    led_cg <= 1'b1;
                 end
                 4'b1000: begin // 8
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1001: begin // 9
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1010: begin // a
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1011: begin // b
                    led_ca <= 1'b1; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1100: begin // c
                    led_ca <= 1'b1; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b1; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b1101: begin // d
                    led_ca <= 1'b1; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b1110: begin // e
                    led_ca <= 1'b0; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b1; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1111: begin // f
                    led_ca <= 1'b0; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b1; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 default: begin
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
             endcase
		end
		8'b1110_1111: begin 
		     case(display_number[19:16])
			     4'b0000: begin // 0
			        led_ca <= 1'b0;
                    led_cb <= 1'b0;
                    led_cc <= 1'b0;
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b1;
                 end
                 4'b0001: begin // 1
                    led_ca <= 1'b1; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b1;
                    led_cg <= 1'b1;
                 end
                 4'b0010: begin // 2
                    led_ca <= 1'b0;
                    led_cb <= 1'b0;
                    led_cc <= 1'b1;
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b0011: begin // 3
                    led_ca <= 1'b0;
                    led_cb <= 1'b0;
                    led_cc <= 1'b0;
                    led_cd <= 1'b0;
                    led_ce <= 1'b1;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b0100: begin // 4
                    led_ca <= 1'b1; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b0101: begin // 5
                    led_ca <= 1'b0;
                    led_cb <= 1'b1;
                    led_cc <= 1'b0;
                    led_cd <= 1'b0;
                    led_ce <= 1'b1;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b0110: begin // 6
                    led_ca <= 1'b0; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b0111: begin // 7
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b1;
                    led_cg <= 1'b1;
                 end
                 4'b1000: begin // 8
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1001: begin // 9
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1010: begin // a
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1011: begin // b
                    led_ca <= 1'b1; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1100: begin // c
                    led_ca <= 1'b1; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b1; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b1101: begin // d
                    led_ca <= 1'b1; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b1110: begin // e
                    led_ca <= 1'b0; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b1; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1111: begin // f
                    led_ca <= 1'b0; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b1; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 default: begin
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
             endcase
		end
		8'b1101_1111: begin 
		 	 case(display_number[23:20])
			     4'b0000: begin // 0
			        led_ca <= 1'b0;
                    led_cb <= 1'b0;
                    led_cc <= 1'b0;
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b1;
                 end
                 4'b0001: begin // 1
                    led_ca <= 1'b1; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b1;
                    led_cg <= 1'b1;
                 end
                 4'b0010: begin // 2
                    led_ca <= 1'b0;
                    led_cb <= 1'b0;
                    led_cc <= 1'b1;
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b0011: begin // 3
                    led_ca <= 1'b0;
                    led_cb <= 1'b0;
                    led_cc <= 1'b0;
                    led_cd <= 1'b0;
                    led_ce <= 1'b1;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b0100: begin // 4
                    led_ca <= 1'b1; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b0101: begin // 5
                    led_ca <= 1'b0;
                    led_cb <= 1'b1;
                    led_cc <= 1'b0;
                    led_cd <= 1'b0;
                    led_ce <= 1'b1;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b0110: begin // 6
                    led_ca <= 1'b0; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b0111: begin // 7
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b1;
                    led_cg <= 1'b1;
                 end
                 4'b1000: begin // 8
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1001: begin // 9
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b1;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1010: begin // a
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1011: begin // b
                    led_ca <= 1'b1; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1100: begin // c
                    led_ca <= 1'b1; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b1; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b1101: begin // d
                    led_ca <= 1'b1; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b1;
                    led_cg <= 1'b0;
                 end
                 4'b1110: begin // e
                    led_ca <= 1'b0; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b1; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 4'b1111: begin // f
                    led_ca <= 1'b0; 
                    led_cb <= 1'b1;
                    led_cc <= 1'b1; 
                    led_cd <= 1'b1;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
                 default: begin
                    led_ca <= 1'b0; 
                    led_cb <= 1'b0;
                    led_cc <= 1'b0; 
                    led_cd <= 1'b0;
                    led_ce <= 1'b0;
                    led_cf <= 1'b0;
                    led_cg <= 1'b0;
                 end
             endcase
		end
		8'b1011_1111: begin
            led_ca <= 1'b0;
            led_cb <= 1'b1;
            led_cc <= 1'b0;
            led_cd <= 1'b0;
            led_ce <= 1'b1;
            led_cf <= 1'b0;
            led_cg <= 1'b0;
//			  case(display_number[27:24])
//			      4'b0000: begin // 0
//			         led_ca <= 1'b0;
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b0;
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b1;
//                  end
//                  4'b0001: begin // 1
//                     led_ca <= 1'b1; 
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b0; 
//                     led_cd <= 1'b1;
//                     led_ce <= 1'b1;
//                     led_cf <= 1'b1;
//                     led_cg <= 1'b1;
//                  end
//                  4'b0010: begin // 2
//                     led_ca <= 1'b0;
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b1;
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b1;
//                     led_cg <= 1'b0;
//                  end
//                  4'b0011: begin // 3
//                     led_ca <= 1'b0;
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b0;
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b1;
//                     led_cf <= 1'b1;
//                     led_cg <= 1'b0;
//                  end
//                  4'b0100: begin // 4
//                     led_ca <= 1'b1; 
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b0; 
//                     led_cd <= 1'b1;
//                     led_ce <= 1'b1;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b0;
//                  end
//                  4'b0101: begin // 5
//                     led_ca <= 1'b0;
//                     led_cb <= 1'b1;
//                     led_cc <= 1'b0;
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b1;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b0;
//                  end
//                  4'b0110: begin // 6
//                     led_ca <= 1'b0; 
//                     led_cb <= 1'b1;
//                     led_cc <= 1'b0; 
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b0;
//                  end
//                  4'b0111: begin // 7
//                     led_ca <= 1'b0; 
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b0; 
//                     led_cd <= 1'b1;
//                     led_ce <= 1'b1;
//                     led_cf <= 1'b1;
//                     led_cg <= 1'b1;
//                  end
//                  4'b1000: begin // 8
//                     led_ca <= 1'b0; 
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b0; 
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b0;
//                  end
//                  4'b1001: begin // 9
//                     led_ca <= 1'b0; 
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b0; 
//                     led_cd <= 1'b1;
//                     led_ce <= 1'b1;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b0;
//                  end
//                  4'b1010: begin // a
//                     led_ca <= 1'b0; 
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b0; 
//                     led_cd <= 1'b1;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b0;
//                  end
//                  4'b1011: begin // b
//                     led_ca <= 1'b1; 
//                     led_cb <= 1'b1;
//                     led_cc <= 1'b0; 
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b0;
//                  end
//                  4'b1100: begin // c
//                     led_ca <= 1'b1; 
//                     led_cb <= 1'b1;
//                     led_cc <= 1'b1; 
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b1;
//                     led_cg <= 1'b0;
//                  end
//                  4'b1101: begin // d
//                     led_ca <= 1'b1; 
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b0; 
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b1;
//                     led_cg <= 1'b0;
//                  end
//                  4'b1110: begin // e
//                     led_ca <= 1'b0; 
//                     led_cb <= 1'b1;
//                     led_cc <= 1'b1; 
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b0;
//                  end
//                  4'b1111: begin // f
//                     led_ca <= 1'b0; 
//                     led_cb <= 1'b1;
//                     led_cc <= 1'b1; 
//                     led_cd <= 1'b1;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b0;
//                  end
//                  default: begin
//                     led_ca <= 1'b0; 
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b0; 
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b0;
//                  end
//              endcase				
		end
		8'b0111_1111: begin 
            led_ca <= 1'b0;
            led_cb <= 1'b0;
            led_cc <= 1'b1;
            led_cd <= 1'b0;
            led_ce <= 1'b0;
            led_cf <= 1'b1;
            led_cg <= 1'b0;
//		      case(display_number[31:28])
//			      4'b0000: begin // 0
//			         led_ca <= 1'b0;
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b0;
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b1;
//                  end
//                  4'b0001: begin // 1
//                     led_ca <= 1'b1; 
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b0; 
//                     led_cd <= 1'b1;
//                     led_ce <= 1'b1;
//                     led_cf <= 1'b1;
//                     led_cg <= 1'b1;
//                  end
//                  4'b0010: begin // 2
//                     led_ca <= 1'b0;
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b1;
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b1;
//                     led_cg <= 1'b0;
//                  end
//                  4'b0011: begin // 3
//                     led_ca <= 1'b0;
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b0;
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b1;
//                     led_cf <= 1'b1;
//                     led_cg <= 1'b0;
//                  end
//                  4'b0100: begin // 4
//                     led_ca <= 1'b1; 
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b0; 
//                     led_cd <= 1'b1;
//                     led_ce <= 1'b1;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b0;
//                  end
//                  4'b0101: begin // 5
//                     led_ca <= 1'b0;
//                     led_cb <= 1'b1;
//                     led_cc <= 1'b0;
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b1;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b0;
//                  end
//                  4'b0110: begin // 6
//                     led_ca <= 1'b0; 
//                     led_cb <= 1'b1;
//                     led_cc <= 1'b0; 
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b0;
//                  end
//                  4'b0111: begin // 7
//                     led_ca <= 1'b0; 
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b0; 
//                     led_cd <= 1'b1;
//                     led_ce <= 1'b1;
//                     led_cf <= 1'b1;
//                     led_cg <= 1'b1;
//                  end
//                  4'b1000: begin // 8
//                     led_ca <= 1'b0; 
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b0; 
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b0;
//                  end
//                  4'b1001: begin // 9
//                     led_ca <= 1'b0; 
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b0; 
//                     led_cd <= 1'b1;
//                     led_ce <= 1'b1;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b0;
//                  end
//                  4'b1010: begin // a
//                     led_ca <= 1'b0; 
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b0; 
//                     led_cd <= 1'b1;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b0;
//                  end
//                  4'b1011: begin // b
//                     led_ca <= 1'b1; 
//                     led_cb <= 1'b1;
//                     led_cc <= 1'b0; 
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b0;
//                  end
//                  4'b1100: begin // c
//                     led_ca <= 1'b1; 
//                     led_cb <= 1'b1;
//                     led_cc <= 1'b1; 
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b1;
//                     led_cg <= 1'b0;
//                  end
//                  4'b1101: begin // d
//                     led_ca <= 1'b1; 
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b0; 
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b1;
//                     led_cg <= 1'b0;
//                  end
//                  4'b1110: begin // e
//                     led_ca <= 1'b0; 
//                     led_cb <= 1'b1;
//                     led_cc <= 1'b1; 
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b0;
//                  end
//                  4'b1111: begin // f
//                     led_ca <= 1'b0; 
//                     led_cb <= 1'b1;
//                     led_cc <= 1'b1; 
//                     led_cd <= 1'b1;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b0;
//                  end
//                  default: begin
//                     led_ca <= 1'b0; 
//                     led_cb <= 1'b0;
//                     led_cc <= 1'b0; 
//                     led_cd <= 1'b0;
//                     led_ce <= 1'b0;
//                     led_cf <= 1'b0;
//                     led_cg <= 1'b0;
//                  end
//              endcase
		end
		default: begin
		     led_ca <= 1'b0; 
             led_cb <= 1'b0;
             led_cc <= 1'b0; 
             led_cd <= 1'b0;
             led_ce <= 1'b0;
             led_cf <= 1'b0;
             led_cg <= 1'b0;
		end
	endcase
end

endmodule