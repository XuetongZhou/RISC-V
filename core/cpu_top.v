`timescale 1ns / 1ps
`include "cpu_define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/02 17:46:41
// Design Name: 
// Module Name: cpu_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cpu_top(
    input clk,
    input rst_,
    input start,
    output error,
    
    //itcm interface
    input itcm_en,
    input[`PC_SIZE-1:0] itcm_addr,
    input[7:0] itcm_data,
    
    //dtcm interface
    input dtcm_en,
    input[`DATA_SIZE-1:0] dtcm_addr,
    input[7:0] dtcm_data,
    
    //CSR interface
    output wb_csr_en,
    output [`CSR_LEN-1:0] wb_csr_addr,
    output [31:0] wb_csr_data,
    
    output [`CSR_LEN-1:0] exe_csr_addr,
    input[31:0] csr_exe_data
    );
    
    
    // ifu <===> itcm
    wire ifu_itcm_en;
    wire[`PC_SIZE-1:0] ifu_itcm_addr;
    wire[31:0] itcm_ifu_data;
    
    // wb <===> dtcm
    wire wb_dtcm_sb_en;
    //wire wb_dtcm_sh_en, wb_dtcm_sw_en;
    wire[`DATA_SIZE-1:0] wb_dtcm_addr;
    wire[7:0] wb_dtcm_sb_data;
    //wire[15:0] wb_dtcm_sh_data;
    //wire[31:0] wb_dtcm_sw_data;
    wire dtcm_en_mux;
    wire[`DATA_SIZE-1:0] dtcm_addr_mux;
    wire[7:0] dtcm_data_mux;
    
    // exe <===> dtcm
    wire[`DATA_SIZE-1:0] exe_dtcm_addr;
    wire[31:0] dtcm_exe_data;
    
    // ifu <===> decode
    wire ifu_decode_start;
    wire[31:0] ifu_decode_instruct;
    wire[`PC_SIZE-1:0] ifu_decode_pc;
    wire[`PC_SIZE-1:0] ifu_decode_pc_next;
    
    // ifu <===> regfile
    wire[`PC_SIZE-1:0] ifu_regfile_addr;
    wire[31:0] regfile_ifu_data;
    
    // ifu <===> wb
    wire wb_ifu_flush_flag;
    wire[`PC_SIZE-1:0] wb_ifu_pc_new;
    
    //decode <===> exe
    wire decode_exe_start;
    wire[`REG_SIZE-1:0] decode_exe_rs1_idx;
    wire[`REG_SIZE-1:0] decode_exe_rs2_idx;
    wire[`REG_SIZE-1:0] decode_exe_rd_idx;
    wire[31:0] decode_exe_imm;
    wire[4:0] decode_exe_shamt;
    wire[`CSR_LEN-1:0] decode_exe_csr_idx;
    wire[31:0] decode_exe_zimm;
    wire[`PC_SIZE-1:0] decode_exe_pc;
    wire[`PC_SIZE-1:0] decode_exe_pc_next;
    
    wire decode_exe_addi_flag;
    wire decode_exe_slli_flag;
    wire decode_exe_slti_flag;
    wire decode_exe_sltiu_flag;
    wire decode_exe_xori_flag;
    wire decode_exe_srli_flag;
    wire decode_exe_srai_flag;
    wire decode_exe_ori_flag;
    wire decode_exe_andi_flag;
    
    wire decode_exe_add_flag;
    wire decode_exe_sub_flag;
    wire decode_exe_sll_flag;
    wire decode_exe_slt_flag;
    wire decode_exe_sltu_flag;
    wire decode_exe_xor_flag;
    wire decode_exe_srl_flag;
    wire decode_exe_sra_flag;
    wire decode_exe_or_flag;
    wire decode_exe_and_flag;
    
    wire decode_exe_jal_flag;
    wire decode_exe_jalr_flag;
    wire decode_exe_beq_flag;
    wire decode_exe_bne_flag;
    wire decode_exe_blt_flag;
    wire decode_exe_bge_flag;
    wire decode_exe_bltu_flag;
    wire decode_exe_bgeu_flag;
    
    wire decode_exe_lui_flag;
    wire decode_exe_auipc_flag;
    
    wire decode_exe_lb_flag;
    wire decode_exe_lh_flag;
    wire decode_exe_lw_flag;
    wire decode_exe_lbu_flag;
    wire decode_exe_lhu_flag;
    wire decode_exe_sb_flag;
    wire decode_exe_sh_flag;
    wire decode_exe_sw_flag;
    
    wire decode_exe_csrrw_flag;
    wire decode_exe_csrrs_flag;
    wire decode_exe_csrrc_flag;
    wire decode_exe_csrrwi_flag;
    wire decode_exe_csrrsi_flag;
    wire decode_exe_csrrci_flag;

    // exe <===> wb
    wire exe_wb_start;
    wire[`REG_SIZE-1:0] exe_wb_rd_idx;
    wire[31:0] exe_wb_rd_data;
    wire[31:0] exe_wb_jump_idx;
    wire[`DATA_SIZE-1:0] exe_wb_save_idx;
    wire[31:0] exe_wb_save_data;
    wire[`CSR_LEN-1:0] exe_wb_csr_idx;
    wire[31:0] exe_wb_csr_data;
    
    wire exe_wb_sb_flag;
    wire exe_wb_sh_flag;
    wire exe_wb_sw_flag;
    
    wire exe_wb_rd_en;
    wire exe_wb_jump_en;
    wire exe_wb_save_en;
    wire exe_wb_csr_en;
    
    wire[`PC_SIZE-1:0] exe_wb_pc_next;
    
    // wb <===> regfile
    wire wb_regfile_en;
    wire[`REG_SIZE-1:0] wb_regfile_addr;
    wire[31:0] wb_regfile_data;
    
    
    itcm itcm0(
    .clk_a(clk),
    .wen_a(itcm_en),
    .addr_a(itcm_addr),
    .in_a(itcm_data),
    
    .ren_b(ifu_itcm_en),
    .addr_b(ifu_itcm_addr),
    .out_b(itcm_ifu_data)
    );
    
    
    assign dtcm_en_mux = dtcm_en | wb_dtcm_sb_en;
    assign dtcm_addr_mux = dtcm_en ? dtcm_addr : wb_dtcm_sb_en ? wb_dtcm_addr : `DATA_SIZE'd0;
    assign dtcm_data_mux = dtcm_en ? dtcm_data : wb_dtcm_sb_en ? wb_dtcm_sb_data : 8'd0;
    
    
    dtcm dtcm0(
    .clk(clk),
    .wen_a(dtcm_en_mux),
    .addr_a(dtcm_addr_mux),
    .in_a(dtcm_data_mux),

    //.sb_en(wb_dtcm_sb_en),
    //.sh_en(wb_dtcm_sh_en),
    //.sw_en(wb_dtcm_sw_en),
    //.addr_b(wb_dtcm_addr),
    //.sb_in(wb_dtcm_sb_data),
    //.sh_in(wb_dtcm_sh_data),
    //.sw_in(wb_dtcm_sw_data),
    
    .addr_c(exe_dtcm_addr),
    .out_c(dtcm_exe_data)
    );
    
    
    /*
    csr csr(
    .clk_a(clk),
    .wen_a(wb_csr_en),
    .addr_a(wb_csr_addr),
    .in_a(wb_csr_data),
    
    .addr_b(exe_csr_addr),
    .out_b(csr_exe_data)
    );
    */
    
    
    regfile regfile(
    .clk_a(clk),
    .wen_a(wb_regfile_en),
    .addr_a(wb_regfile_addr),
    .in_a(wb_regfile_data),
    
    .addr_b(ifu_regfile_addr),
    .out_b(regfile_ifu_data)
    );
    
    
    ifu_unit ifu(
    .clk(clk),
    .rst_(rst_),
    .start(start),
    
    .itcm_ren(ifu_itcm_en),
    .pc(ifu_itcm_addr),
    .instruct_in(itcm_ifu_data),
    
    .decode_start(ifu_decode_start),
    .instruct(ifu_decode_instruct),
    .pc2decode(ifu_decode_pc),
    
    .regfile_data(regfile_ifu_data),
    .regfile_addr(ifu_regfile_addr),
    
    .flush_flag(wb_ifu_flush_flag),
    .pc_new(wb_ifu_pc_new)
    );
    
    
    assign ifu_decode_pc_next = ifu_itcm_addr;
    
    
    decode_unit decoder(
    .clk(clk),
    .rst_(rst_),
    .decode_error(error),
    
    .decode_start(ifu_decode_start),
    .pc_in(ifu_decode_pc),
    .instruct(ifu_decode_instruct),
    .pc_next(ifu_decode_pc_next),
    
    .exe_start(decode_exe_start),
    .rs1_idx(decode_exe_rs1_idx),
    .rs2_idx(decode_exe_rs2_idx),
    .rd_idx(decode_exe_rd_idx),
    .imm(decode_exe_imm),
    .shamt(decode_exe_shamt),
    .csr_idx(decode_exe_csr_idx),
    .zimm(decode_exe_zimm),
    .pc_out(decode_exe_pc),
    .pc_next_out(decode_exe_pc_next),
    
    .addi_flag(decode_exe_addi_flag),
    .slli_flag(decode_exe_slli_flag),
    .slti_flag(decode_exe_slti_flag),
    .sltiu_flag(decode_exe_sltiu_flag),
    .xori_flag(decode_exe_xori_flag),
    .srli_flag(decode_exe_srli_flag),
    .srai_flag(decode_exe_srai_flag),
    .ori_flag(decode_exe_ori_flag),
    .andi_flag(decode_exe_andi_flag),
    
    .add_flag(decode_exe_add_flag),
    .sub_flag(decode_exe_sub_flag),
    .sll_flag(decode_exe_sll_flag),
    .slt_flag(decode_exe_slt_flag),
    .sltu_flag(decode_exe_sltu_flag),
    .xor_flag(decode_exe_xor_flag),
    .srl_flag(decode_exe_srl_flag),
    .sra_flag(decode_exe_sra_flag),
    .or_flag(decode_exe_or_flag),
    .and_flag(decode_exe_and_flag),
    
    .jal_flag(decode_exe_jal_flag),
    .jalr_flag(decode_exe_jalr_flag),
    .beq_flag(decode_exe_beq_flag),
    .bne_flag(decode_exe_bne_flag),
    .blt_flag(decode_exe_blt_flag),
    .bge_flag(decode_exe_bge_flag),
    .bltu_flag(decode_exe_bltu_flag),
    .bgeu_flag(decode_exe_bgeu_flag),
    
    .lui_flag(decode_exe_lui_flag),
    .auipc_flag(decode_exe_auipc_flag),
    
    .lb_flag(decode_exe_lb_flag),
    .lh_flag(decode_exe_lh_flag),
    .lw_flag(decode_exe_lw_flag),
    .lbu_flag(decode_exe_lbu_flag),
    .lhu_flag(decode_exe_lhu_flag),
    .sb_flag(decode_exe_sb_flag),
    .sh_flag(decode_exe_sh_flag),
    .sw_flag(decode_exe_sw_flag),
    
    .csrrw_flag(decode_exe_csrrw_flag),
    .csrrs_flag(decode_exe_csrrs_flag),
    .csrrc_flag(decode_exe_csrrc_flag),
    .csrrwi_flag(decode_exe_csrrwi_flag),
    .csrrsi_flag(decode_exe_csrrsi_flag),
    .csrrci_flag(decode_exe_csrrci_flag)
    );
    
    
    exe_unit exu(
    .clk(clk),
    .rst_(rst_),
    
    .exe_start(decode_exe_start),
    .rs1_idx(decode_exe_rs1_idx),
    .rs2_idx(decode_exe_rs2_idx),
    .rd_idx(decode_exe_rd_idx),
    .imm(decode_exe_imm),
    .shamt(decode_exe_shamt),
    .csr_idx(decode_exe_csr_idx),
    .zimm(decode_exe_zimm),
    .pc_in(decode_exe_pc),
    .pc_next(decode_exe_pc_next),
    
    .addi_flag(decode_exe_addi_flag),
    .slli_flag(decode_exe_slli_flag),
    .slti_flag(decode_exe_slti_flag),
    .sltiu_flag(decode_exe_sltiu_flag),
    .xori_flag(decode_exe_xori_flag),
    .srli_flag(decode_exe_srli_flag),
    .srai_flag(decode_exe_srai_flag),
    .ori_flag(decode_exe_ori_flag),
    .andi_flag(decode_exe_andi_flag),
    
    .add_flag(decode_exe_add_flag),
    .sub_flag(decode_exe_sub_flag),
    .sll_flag(decode_exe_sll_flag),
    .slt_flag(decode_exe_slt_flag),
    .sltu_flag(decode_exe_sltu_flag),
    .xor_flag(decode_exe_xor_flag),
    .srl_flag(decode_exe_srl_flag),
    .sra_flag(decode_exe_sra_flag),
    .or_flag(decode_exe_or_flag),
    .and_flag(decode_exe_and_flag),
    
    .jal_flag(decode_exe_jal_flag),
    .jalr_flag(decode_exe_jalr_flag),
    .beq_flag(decode_exe_beq_flag),
    .bne_flag(decode_exe_bne_flag),
    .blt_flag(decode_exe_blt_flag),
    .bge_flag(decode_exe_bge_flag),
    .bltu_flag(decode_exe_bltu_flag),
    .bgeu_flag(decode_exe_bgeu_flag),
    
    .lui_flag(decode_exe_lui_flag),
    .auipc_flag(decode_exe_auipc_flag),
    
    .lb_flag(decode_exe_lb_flag),
    .lh_flag(decode_exe_lh_flag),
    .lw_flag(decode_exe_lw_flag),
    .lbu_flag(decode_exe_lbu_flag),
    .lhu_flag(decode_exe_lhu_flag),
    .sb_flag(decode_exe_sb_flag),
    .sh_flag(decode_exe_sh_flag),
    .sw_flag(decode_exe_sw_flag),
    
    .csrrw_flag(decode_exe_csrrw_flag),
    .csrrs_flag(decode_exe_csrrs_flag),
    .csrrc_flag(decode_exe_csrrc_flag),
    .csrrwi_flag(decode_exe_csrrwi_flag),
    .csrrsi_flag(decode_exe_csrrsi_flag),
    .csrrci_flag(decode_exe_csrrci_flag),
    
    .dtcm_data(dtcm_exe_data),
    .dtcm_addr(exe_dtcm_addr),
    
    .csr_data(csr_exe_data),
    .csr_addr(exe_csr_addr),

    .wb_start(exe_wb_start),
    .rd_addr(exe_wb_rd_idx),
    .rd_data(exe_wb_rd_data),
    .jump_addr(exe_wb_jump_idx),
    .save_addr(exe_wb_save_idx),
    .save_data(exe_wb_save_data),
    .csr_addr_out(exe_wb_csr_idx),
    .csr_out(exe_wb_csr_data),
    
    .sb_flag_out(exe_wb_sb_flag),
    .sh_flag_out(exe_wb_sh_flag),
    .sw_flag_out(exe_wb_sw_flag),
    
    .rd_en(exe_wb_rd_en),
    .jump_en(exe_wb_jump_en),
    .save_en(exe_wb_save_en),
    .csr_en(exe_wb_csr_en),
    
    .pc_next_out(exe_wb_pc_next)
    );
    
    
    writeback_unit wb(
    .clk(clk),
    .rst_(rst_),
    
    .regfile_en(wb_regfile_en),
    .rd_addr(wb_regfile_addr),
    .rd_data_out(wb_regfile_data),
    
    .sb_en(wb_dtcm_sb_en),
    //.sh_en(wb_dtcm_sh_en),
    //.sw_en(wb_dtcm_sw_en),
    .dtcm_addr(wb_dtcm_addr),
    .sb_data(wb_dtcm_sb_data),
    //.sh_data(wb_dtcm_sh_data),
    //.sw_data(wb_dtcm_sw_data),
    
    .csr_en_out(wb_csr_en),
    .csr_addr(wb_csr_addr),
    .csr_data_out(wb_csr_data),
    
    .flush_flag(wb_ifu_flush_flag),
    .pc_new(wb_ifu_pc_new),
    
    //The exe_unit bus
    .wb_start(exe_wb_start),
    .rd_idx(exe_wb_rd_idx),
    .rd_data(exe_wb_rd_data),
    .jump_addr(exe_wb_jump_idx),
    .save_addr(exe_wb_save_idx),
    .save_data(exe_wb_save_data),
    .csr_idx(exe_wb_csr_idx),
    .csr_data(exe_wb_csr_data),
    
    .sb_flag(exe_wb_sb_flag),
    .sh_flag(exe_wb_sh_flag),
    .sw_flag(exe_wb_sw_flag),
    
    .rd_en(exe_wb_rd_en),
    .jump_en(exe_wb_jump_en),
    .save_en(exe_wb_save_en),
    .csr_en(exe_wb_csr_en),
    
    .pc_next(exe_wb_pc_next)
    );    
    
endmodule
