`timescale 1ns / 1ps
`include "cpu_define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/02 22:14:03
// Design Name: 
// Module Name: exe_unit
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


module exe_unit(
    input clk,
    input rst_,
    
    //The decode_unit bus
    input exe_start,
    input[`REG_SIZE-1:0] rs1_idx,
    input[`REG_SIZE-1:0] rs2_idx,
    input[`REG_SIZE-1:0] rd_idx,
    input[31:0] imm,
    input[4:0] shamt,
    input[`CSR_LEN-1:0] csr_idx,
    input[31:0] zimm,
    input[`PC_SIZE-1:0] pc_in,
    input[`PC_SIZE-1:0] pc_next,
    
    input addi_flag,
    input slli_flag,
    input slti_flag,
    input sltiu_flag,
    input xori_flag,
    input srli_flag,
    input srai_flag,
    input ori_flag,
    input andi_flag,
    
    input add_flag,
    input sub_flag,
    input sll_flag,
    input slt_flag,
    input sltu_flag,
    input xor_flag,
    input srl_flag,
    input sra_flag,
    input or_flag,
    input and_flag,
    
    input jal_flag,
    input jalr_flag,
    input beq_flag,
    input bne_flag,
    input blt_flag,
    input bge_flag,
    input bltu_flag,
    input bgeu_flag,
    
    input lui_flag,
    input auipc_flag,
    
    input lb_flag,
    input lh_flag,
    input lw_flag,
    input lbu_flag,
    input lhu_flag,
    input sb_flag,
    input sh_flag,
    input sw_flag,
    
    input csrrw_flag,
    input csrrs_flag,
    input csrrc_flag,
    input csrrwi_flag,
    input csrrsi_flag,
    input csrrci_flag,
    
    //The dtcm bus
    input[31:0] dtcm_data,
    output[`DATA_SIZE-1:0]dtcm_addr,
    
    //The CSR bus
    input[31:0] csr_data,
    output[`CSR_LEN-1:0] csr_addr,
    
    //The writeback_unit bus
    output reg wb_start,
    output reg[`REG_SIZE-1:0] rd_addr,
    output reg[31:0] rd_data,
    output reg[31:0] jump_addr,
    output reg[`DATA_SIZE-1:0] save_addr,
    output reg[31:0] save_data,
    output reg[`CSR_LEN-1:0] csr_addr_out,
    output reg[31:0] csr_out,
    
    output reg sb_flag_out,
    output reg sh_flag_out,
    output reg sw_flag_out,
    
    output reg rd_en,
    output reg jump_en,
    output reg save_en,
    output reg csr_en,
    
    output reg[`PC_SIZE-1:0] pc_next_out
    );
    
    
    wire[31:0] addi_result, slli_result, slti_result, sltiu_result, xori_result, srli_result, srai_result, ori_result, andi_result;
    wire[31:0] add_result, sub_result, sll_result, slt_result, sltu_result, xor_result, srl_result, sra_result, or_result, and_result;
    wire[31:0] jal_result, jalr_result;
    wire beq_result, bne_result, blt_result, bge_result, bltu_result, bgeu_result;
    wire[31:0] lui_result, auipc_result;
    wire[31:0] lb_result, lh_result, lw_result, lbu_result, lhu_result;
    wire[31:0] save_result;
    wire[31:0] csrrw_result, csrrs_result, csrrc_result, csrrwi_result, csrrsi_result, csrrci_result;
    
    wire[31:0] jump_addr_result, csr_data_result;
    wire[`DATA_SIZE-1:0] save_addr_result;
    wire[`CSR_LEN-1:0] csr_addr_result;
    
    reg[31:0] regfile_temp [31:0];
    wire[31:0] regfile_temp_addr;
    wire[31:0] rs1_data;
    wire[31:0] rs2_data;
    
    reg[2:0] count;
    
    always@(posedge clk or negedge rst_)
    if(!rst_)
        wb_start <= 1'b0;
    else if(exe_start == 1'b1)
        wb_start <= 1'b1;
    else
        wb_start <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        regfile_temp[0] <= 32'd0;
    else if(exe_start)
        if(count == 0)
            if(addi_flag)
                regfile_temp[rd_idx] <= addi_result;
            else if(slli_flag)
                regfile_temp[rd_idx] <= slli_result;
            else if(slti_flag)
                regfile_temp[rd_idx] <= slti_result;
            else if(sltiu_flag)
                regfile_temp[rd_idx] <= sltiu_result;
            else if(xori_flag)
                regfile_temp[rd_idx] <= xori_result;
            else if(srli_flag)
                regfile_temp[rd_idx] <= srli_result;
            else if(srai_flag)
                regfile_temp[rd_idx] <= srai_result;
            else if(ori_flag)
                regfile_temp[rd_idx] <= ori_result;
             else if(andi_flag)
                regfile_temp[rd_idx] <= andi_result;
            else if(add_flag)
                regfile_temp[rd_idx] <= add_result;
            else if(sub_flag)
                regfile_temp[rd_idx] <= sub_result;
            else if(sll_flag)
                regfile_temp[rd_idx] <= sll_result;
            else if(slt_flag)
                regfile_temp[rd_idx] <= slt_result;
            else if(sltu_flag)
                regfile_temp[rd_idx] <= sltu_result;
            else if(xor_flag)
                regfile_temp[rd_idx] <= xor_result;
            else if(srl_flag)
                regfile_temp[rd_idx] <= srl_result;
            else if(sra_flag)
                regfile_temp[rd_idx] <= sra_result;
            else if(or_flag)
                regfile_temp[rd_idx] <= or_result;
            else if(and_flag)
                regfile_temp[rd_idx] <= and_result;
            else if(jal_flag)
                regfile_temp[rd_idx] <= jal_result;
            else if(jalr_flag)
                regfile_temp[rd_idx] <= jalr_result;
            else if(lui_flag)
                regfile_temp[rd_idx] <= lui_result;
            else if(auipc_flag)
                regfile_temp[rd_idx] <= auipc_result;
            else if(lb_flag)
                regfile_temp[rd_idx] <= lb_result;
            else if(lh_flag)
                regfile_temp[rd_idx] <= lh_result;
            else if(lw_flag)
                regfile_temp[rd_idx] <= lw_result;
            else if(lbu_flag)
                regfile_temp[rd_idx] <= lbu_result;
            else if(lhu_flag)
                regfile_temp[rd_idx] <= lhu_result;
            else if(csrrw_flag | csrrs_flag | csrrc_flag | csrrwi_flag | csrrsi_flag | csrrci_flag)
                regfile_temp[rd_idx] <= csr_data_result;
            else;
        else;
    else;
    
    assign rs1_data = regfile_temp[rs1_idx];
    assign rs2_data = regfile_temp[rs2_idx];
    
    assign addi_result = addi_flag ? rs1_data + imm : 32'd0;
    assign slli_result = slli_flag ? rs1_data << shamt : 32'd0;
    assign slti_result = slti_flag ? (((rs1_data[31] == 1) && (imm[31] == 0)) || ((rs1_data[31] == 0) && (imm[31] == 0) && (rs1_data[30:0] < imm[30:0])) || ((rs1_data[31] == 1) && (imm[31] == 1) && (rs1_data[30:0] < imm[30:0]))) ? 32'd1 : 32'd0 : 32'd0; 
    assign sltiu_result = sltiu_flag ? (rs1_data < imm) ? 32'd1 : 32'd0 : 32'd0;
    assign xori_result = xori_flag ? rs1_data ^ imm : 32'd0;
    assign srli_result = srli_flag ? rs1_data >> shamt : 32'd0;
    assign srai_result = srai_flag ? rs1_data[31] ? (rs1_data >> shamt) & (32'h1111_1111_1111_1111 >> shamt) : (rs1_data >> shamt) : 32'd0;
    assign ori_result = ori_flag ? rs1_data | imm : 32'd0;
    assign andi_result = andi_flag ? rs1_data & imm : 32'd0;
    
    assign add_result = add_flag ? rs1_data + rs2_data : 32'd0;
    assign sub_result = sub_flag ? rs1_data + (~rs2_data + 1) : 32'd0;
    assign sll_result = sll_flag ? rs1_data << rs2_data[4:0] : 32'd0;
    assign slt_result = slt_flag ? (((rs1_data[31] == 1) && (rs2_data[31] == 0)) || ((rs1_data[31] == 0) && (rs2_data[31] == 0) && (rs1_data[30:0] < rs2_data[30:0])) || ((rs1_data[31] == 1) && (rs2_data[31] == 1) && (rs1_data[30:0] < rs2_data[30:0]))) ? 32'd1 : 32'd0 : 32'd0; 
    assign xor_result = xor_flag ? rs1_data ^ rs2_data : 32'd0;
    assign srl_result = srl_flag ? rs1_data >> rs2_data[4:0] : 32'd0;
    assign sra_result = sra_flag ? rs1_data[31] ? (rs1_data >> rs2_data[4:0]) & (32'h1111_1111_1111_1111 >> rs2_data[4:0]) : (rs1_data >> rs2_data[4:0]) : 32'd0;
    assign or_result = or_flag ? rs1_data | rs2_data : 32'd0;
    assign and_result = and_flag ? rs1_data & rs2_data : 32'd0;
    
    assign jal_result = jal_flag ? {{`PC_COVER_SIZE{1'b0}},pc_in} + 32'd4 : 32'd0;
    assign jalr_result = jalr_flag ? {{`PC_COVER_SIZE{1'b0}},pc_in} + 32'd4 : 32'd0;
    assign beq_result = beq_flag ? (rs1_data == rs2_data) ? 1'b1 : 1'b0 : 1'b0;
    assign bne_result = bne_flag ? (rs1_data != rs2_data) ? 1'b1 : 1'b0 : 1'b0;
    assign blt_result = blt_flag ? (((rs1_data[31] == 1) && (rs2_data[31] == 0)) || ((rs1_data[31] == 0) && (rs2_data[31] == 0) && (rs1_data[30:0] < rs2_data[30:0])) || ((rs1_data[31] == 1) && (rs2_data[31] == 1) && (rs1_data[30:0] < rs2_data[30:0]))) ? 1'b1 : 1'b0 : 1'b0; 
    assign bge_result = bge_flag ? (((rs1_data[31] == 0) && (rs2_data[31] == 1)) || ((rs1_data[31] == 0) && (rs2_data[31] == 0) && (rs1_data[30:0] >= rs2_data[30:0])) || ((rs1_data[31] == 1) && (rs2_data[31] == 1) && (rs1_data[30:0] >= rs2_data[30:0]))) ? 1'b1 : 1'b0 : 1'b0; 
    assign bltu_result = bltu_flag ? (rs1_data < rs2_data) ? 1'b1 : 1'b0 : 1'b0;
    assign bgeu_result = bgeu_flag ? (rs1_data >= rs2_data) ? 1'b1 : 1'b0 : 1'b0;
    
    assign jump_addr_result = jal_flag ? {{`PC_COVER_SIZE{1'b0}},pc_in} + (imm << 1) : jalr_flag ? rs1_data + imm : (beq_result | bne_result | blt_result | bge_result | bltu_result | bgeu_result) ? {{`PC_COVER_SIZE{1'b0}},pc_in} + (imm << 1) : {{`PC_COVER_SIZE{1'b0}},pc_in} + 32'd4;
    
    assign lui_result = lui_flag ? imm : 32'd0;
    assign auipc_result = auipc_flag ? imm + {{`PC_COVER_SIZE{1'b0}},pc_in} : 32'd0;
    
    assign dtcm_addr = (lb_flag | lh_flag | lw_flag | lbu_flag | lhu_flag) ? (rs1_data[`DATA_SIZE-1:0] + imm[`DATA_SIZE-1:0]) : 32'd0;
    assign lb_result = lb_flag ? {{24{dtcm_data[7]}},dtcm_data[7:0]} : 32'd0;
    assign lh_result = lh_flag ? {{16{dtcm_data[15]}},dtcm_data[15:0]} : 32'd0;
    assign lw_result = lw_flag ? dtcm_data : 32'd0;
    assign lbu_result = lbu_flag ? {{24{1'b0}},dtcm_data[7:0]} : 32'd0;
    assign lhu_result = lhu_flag ? {{16{1'b0}},dtcm_data[15:0]} : 32'd0;
    
    assign save_result = (sb_flag | sh_flag | sw_flag) ? rs2_data : 32'd0;
    assign save_addr_result = (sb_flag | sh_flag | sw_flag) ? (rs1_data[`DATA_SIZE-1:0] + imm[`DATA_SIZE-1:0]) : `DATA_SIZE'd0;
    
    assign csr_addr_result = (csrrw_flag | csrrs_flag | csrrc_flag | csrrwi_flag | csrrsi_flag | csrrci_flag) ? csr_idx : `CSR_LEN'd0;
    assign csr_data_result = (csrrw_flag | csrrs_flag | csrrc_flag | csrrwi_flag | csrrsi_flag | csrrci_flag) ? csr_data : 32'd0;
    assign csrrw_result = csrrw_flag ? rs1_data : 32'd0;
    assign csrrs_result = csrrs_flag ? rs1_data | csr_data : 32'd0;
    assign csrrc_result = csrrc_flag ? (~rs1_data) & csr_data : 32'd0;
    assign csrrwi_result = csrrwi_flag ? zimm : 32'd0;
    assign csrrsi_result = csrrsi_flag ? zimm | csr_data : 32'd0;
    assign csrrci_result = csrrci_flag ? (~zimm) & csr_data : 32'd0;
    
    always@(posedge clk or negedge rst_)
    if(!rst_)
        rd_addr <= `REG_SIZE'd0;
    else if(exe_start)
        rd_addr <= rd_idx;
    else
        rd_addr <= `REG_SIZE'd0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        rd_data <= 32'd0;
    else if(exe_start)
        if(addi_flag)
            rd_data <= addi_result;
        else if(slli_flag)
            rd_data <= slli_result;
        else if(slti_flag)
            rd_data <= slti_result;
        else if(sltiu_flag)
            rd_data <= sltiu_result;
        else if(xori_flag)
            rd_data <= xori_result;
        else if(srli_flag)
            rd_data <= srli_result;
        else if(srai_flag)
            rd_data <= srai_result;
        else if(ori_flag)
            rd_data <= ori_result;
         else if(andi_flag)
            rd_data <= andi_result;
        else if(add_flag)
            rd_data <= add_result;
        else if(sub_flag)
            rd_data <= sub_result;
        else if(sll_flag)
            rd_data <= sll_result;
        else if(slt_flag)
            rd_data <= slt_result;
        else if(sltu_flag)
            rd_data <= sltu_result;
        else if(xor_flag)
            rd_data <= xor_result;
        else if(srl_flag)
            rd_data <= srl_result;
        else if(sra_flag)
            rd_data <= sra_result;
        else if(or_flag)
            rd_data <= or_result;
        else if(and_flag)
            rd_data <= and_result;
        else if(jal_flag)
            rd_data <= jal_result;
        else if(jalr_flag)
            rd_data <= jalr_result;
        else if(lui_flag)
            rd_data <= lui_result;
        else if(auipc_flag)
            rd_data <= auipc_result;
        else if(lb_flag)
            rd_data <= lb_result;
        else if(lh_flag)
            rd_data <= lh_result;
        else if(lw_flag)
            rd_data <= lw_result;
        else if(lbu_flag)
            rd_data <= lbu_result;
        else if(lhu_flag)
            rd_data <= lhu_result;
        else if(csrrw_flag | csrrs_flag | csrrc_flag | csrrwi_flag | csrrsi_flag | csrrci_flag)
            rd_data <= csr_data_result;
        else
            rd_data <= 32'd0;
    else
        rd_data <= 32'd0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        jump_addr <= 32'd0;
    else if(exe_start)
        if(jal_flag | jalr_flag | beq_flag | bne_flag | blt_flag | bge_flag | bltu_flag | bgeu_flag)
            jump_addr <= jump_addr_result;
        else
            jump_addr <= 32'd0;
    else
        jump_addr <= 32'd0;

    always@(posedge clk or negedge rst_)
    if(!rst_)
        sb_flag_out <= 1'b0;
    else if(exe_start)
        sb_flag_out <= sb_flag;
    else
        sb_flag_out <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        sh_flag_out <= 1'b0;
    else if(exe_start)
        sh_flag_out <= sh_flag;
    else
        sh_flag_out <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        sw_flag_out <= 1'b0;
    else if(exe_start)
        sw_flag_out <= sw_flag;
    else
        sw_flag_out <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        save_addr <= `DATA_SIZE'd0;
    else if(exe_start)
        if(sb_flag | sh_flag | sw_flag)
            save_addr <= save_addr_result;
        else
            save_addr <= `DATA_SIZE'd0;
    else
        save_addr <= `DATA_SIZE'd0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        save_data <= 32'd0;
    else if(exe_start)
        if(sb_flag | sh_flag | sw_flag)
            save_data <= save_result;
        else
            save_data <= 32'd0;
    else
        save_addr <= 32'd0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        csr_addr_out <= `CSR_LEN'd0;
    else if(exe_start)
        if(csrrw_flag | csrrs_flag | csrrc_flag | csrrwi_flag | csrrsi_flag | csrrci_flag)
            csr_addr_out <= csr_idx;
        else
            csr_addr_out <= `CSR_LEN'd0;
    else
        csr_addr_out <= `CSR_LEN'd0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        csr_out <= 32'd0;
    else if(exe_start)
        if(csrrw_flag)
            csr_out <= csrrw_result;
        else if(csrrs_flag)
            csr_out <= csrrs_result;
        else if(csrrc_flag)
            csr_out <= csrrc_result;
        else if(csrrwi_flag)
            csr_out <= csrrwi_result;
        else if(csrrsi_flag)
            csr_out <= csrrsi_result;
        else if(csrrci_flag)
            csr_out <= csrrci_result;
        else
            csr_out <= 32'd0;
    else
        csr_out <= 32'd0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        rd_en <= 1'b0;
    else if(exe_start)
        if(addi_flag | slli_flag | slti_flag | sltiu_flag | xori_flag | srli_flag | srai_flag | ori_flag | andi_flag | add_flag | sub_flag | sll_flag | slt_flag | sltu_flag | xor_flag | srl_flag | sra_flag |or_flag | and_flag | lui_flag | auipc_flag | jal_flag | jalr_flag | lb_flag | lh_flag | lw_flag | lbu_flag | lhu_flag | csrrw_flag | csrrs_flag | csrrc_flag | csrrwi_flag | csrrsi_flag | csrrci_flag)
            rd_en <= 1'b1;
        else
            rd_en <= 1'b0;
    else
        rd_en <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        jump_en <= 1'b0;
    else if(exe_start)
        if(jal_flag | jalr_flag | beq_flag | bne_flag | blt_flag | bge_flag | bltu_flag | bgeu_flag)
            jump_en <= 1'b1;
        else
            jump_en <= 1'b0;
    else
        jump_en <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        save_en <= 1'b0;
    else if(exe_start)
        if(sb_flag | sh_flag | sw_flag)
            save_en <= 1'b1;
        else
            save_en <= 1'b0;
    else
        save_en <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        csr_en <= 1'b0;
    else if(exe_start)
        if(csrrw_flag | csrrs_flag | csrrc_flag | csrrwi_flag | csrrsi_flag | csrrci_flag)
            csr_en <= 1'b1;
        else
            csr_en <= 1'b0;
    else
        csr_en <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        pc_next_out <= `PC_SIZE'd0;
    else if(exe_start)
        pc_next_out <= pc_next;
    else
        pc_next_out <= `PC_SIZE'd0;
       
    always@(posedge clk or negedge rst_)
    if(!rst_)
        count <= 3'd0;
    else if(exe_start)
        if(jal_flag | jalr_flag | beq_flag | bne_flag | blt_flag | bge_flag | bltu_flag | bgeu_flag)
            if(pc_next != jump_addr_result)
                count <= 3'd4;
            else if(count > 3'd0)
                count <= count - 1;
            else
                count <= 3'd0;
        else if(count > 3'd0)
            count <= count - 1;
        else
            count <= 3'd0;
    else
        count <= 3'd0;
endmodule
