module branch(
    input [31:0] data1,
    input [31:0] data2,
    output reg [2:0] branch_result
);

reg [31:0] res;

always @(*) begin
    res = data1 - data2;
    // data1 = data2
    if (res == 0) begin
        branch_result = 3'b001;
    end
    // data1 < data2
    else if ($signed(res) < 0) begin
        branch_result = 3'b010;
    end
    // data1 > data2
    else begin
        branch_result = 3'b100;
    end  
end

endmodule
