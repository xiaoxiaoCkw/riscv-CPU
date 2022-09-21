module Data_Hazard_Detection (
    // ID
    input [4:0] ID_rs1,
    input [4:0] ID_rs2,
    input [31:0] ID_data1, // rs1 data
    input [31:0] ID_data2, // rs2 data / imm
    input [31:0] ID_rD2, // rs2 data
    input ID_rf1, // rs1 read flag
    input ID_rf2, // rs2 read flag
    input ID_store, // ID stage store instruction flag
    // EX
    input [31:0] EX_wd,
    input [4:0] EX_rd,
    input EX_we,
    input EX_load, // EX stage load instruction flag
    // MEM
    input [31:0] MEM_wd,
    input [4:0] MEM_rd,
    input MEM_we,
    // WB
    input [4:0] WB_rd,
    input [31:0] WB_wd,
    input WB_we,
    output stop,
    output reg [31:0] forward_data1,
    output reg [31:0] forward_data2,
    output reg [31:0] forward_rD2
);

reg rs1_load_use_flag;
reg rs2_load_use_flag;

wire EX_rs1_load_use_hazard = EX_load && EX_we && (EX_rd != 5'b0) && (EX_rd == ID_rs1) && ID_rf1;
wire EX_rs2_load_use_hazard = EX_load && EX_we && (EX_rd != 5'b0) && (EX_rd == ID_rs2) && ID_rf2;

wire rs1_id_ex_hazard = EX_we && !EX_load && (EX_rd != 5'b0) && (EX_rd == ID_rs1) && ID_rf1;
wire rs2_id_ex_hazard = EX_we && !EX_load && (EX_rd != 5'b0) && (EX_rd == ID_rs2) && ID_rf2;

wire rs1_id_mem_hazard = MEM_we && (MEM_rd != 5'b0) && (MEM_rd == ID_rs1) && ID_rf1;
wire rs2_id_mem_hazard = MEM_we && (MEM_rd != 5'b0) && (MEM_rd == ID_rs2) && ID_rf2;

wire rs1_id_wb_hazard = WB_we && (WB_rd != 5'b0) && (WB_rd == ID_rs1) && ID_rf1;
wire rs2_id_wb_hazard = WB_we && (WB_rd != 5'b0) && (WB_rd == ID_rs2) && ID_rf2;

// assign forward_data1 = EX_rs1_load_use_hazard ? 32'b0  :
//                        rs1_id_ex_hazard       ? EX_wd  :
//                        rs1_id_mem_hazard      ? MEM_wd :
//                        rs1_id_wb_hazard       ? WB_wd  :
//                                                 ID_data1;

// assign forward_data2 = EX_rs2_load_use_hazard ? 32'b0  :
//                        rs2_id_ex_hazard       ? EX_wd  :
//                        rs2_id_mem_hazard      ? MEM_wd :
//                        rs2_id_wb_hazard       ? WB_wd  :
//                                                 ID_data2;

// forward_data1
always @(*) begin
    if (EX_rs1_load_use_hazard) begin
        rs1_load_use_flag = 1'b1;
        forward_data1 = 32'b0;
    end
    else if (rs1_load_use_flag) begin
        forward_data1 = rs1_id_mem_hazard      ? MEM_wd :
                        rs1_id_ex_hazard       ? EX_wd  :
                        rs1_id_wb_hazard       ? WB_wd  :
                                                ID_data1;
        rs1_load_use_flag = 1'b0;
    end
    else begin
        rs1_load_use_flag = 1'b0;
        forward_data1 = rs1_id_ex_hazard       ? EX_wd  :
                        rs1_id_mem_hazard      ? MEM_wd :
                        rs1_id_wb_hazard       ? WB_wd  :
                                                ID_data1;
    end
end

// forward_data2 and forward_rD2
always @(*) begin
    if (EX_rs2_load_use_hazard) begin
        rs2_load_use_flag = 1'b1;
        forward_data2 = 32'b0;
        forward_rD2 = 32'b0;
    end
    else if (rs2_load_use_flag) begin
        forward_data2 = rs2_id_mem_hazard      ? MEM_wd :
                        rs2_id_ex_hazard       ? EX_wd  :
                        rs2_id_wb_hazard       ? WB_wd  :
                                                ID_data2;
        forward_rD2 = rs2_id_mem_hazard      ? MEM_wd :
                      rs2_id_ex_hazard       ? EX_wd  :
                      rs2_id_wb_hazard       ? WB_wd  :
                                               ID_rD2;
        rs2_load_use_flag = 1'b0;
    end
    else if (ID_store) begin
        rs2_load_use_flag = 1'b0;
        forward_data2 = ID_data2;
        forward_rD2 = rs2_id_ex_hazard       ? EX_wd  :
                      rs2_id_mem_hazard      ? MEM_wd :
                      rs2_id_wb_hazard       ? WB_wd  :
                                               ID_rD2;
    end
    else begin
        rs2_load_use_flag = 1'b0;
        forward_data2 = rs2_id_ex_hazard       ? EX_wd  :
                        rs2_id_mem_hazard      ? MEM_wd :
                        rs2_id_wb_hazard       ? WB_wd  :
                                                ID_data2;
        forward_rD2 = rs2_id_ex_hazard       ? EX_wd  :
                      rs2_id_mem_hazard      ? MEM_wd :
                      rs2_id_wb_hazard       ? WB_wd  :
                                               ID_rD2;
    end
end

// forward_rD2
//always @(*) begin
//    if (EX_rs2_load_use_hazard) begin
//        rs2_load_use_flag = 1'b1;
//        forward_rD2 = 32'b0;
//    end
//    else if (rs2_load_use_flag) begin
//        forward_rD2 = rs2_id_mem_hazard      ? MEM_wd :
//                      rs2_id_ex_hazard       ? EX_wd  :
//                      rs2_id_wb_hazard       ? WB_wd  :
//                                               ID_rD2;
//        rs2_load_use_flag = 1'b0;
//    end
//    else begin
//        forward_rD2 = rs2_id_ex_hazard       ? EX_wd  :
//                      rs2_id_mem_hazard      ? MEM_wd :
//                      rs2_id_wb_hazard       ? WB_wd  :
//                                               ID_rD2;
//    end
//end

assign stop = EX_rs1_load_use_hazard || EX_rs2_load_use_hazard;

endmodule