`timescale 1ns / 1ps
`include "cpu_define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/02 22:09:35
// Design Name: 
// Module Name: decode_unit
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


module decode_unit(
    input clk,
    input rst_,
    output reg decode_error,
    
    //The ifu_unit bus
    input decode_start,
    input[`PC_SIZE-1:0] pc_in,
    input[31:0] instruct,
    input[`PC_SIZE-1:0] pc_next,
    
    //The exe_unit bus
    output reg exe_start,
    output reg[`REG_SIZE-1:0] rs1_idx,
    output reg[`REG_SIZE-1:0] rs2_idx,
    output reg[`REG_SIZE-1:0] rd_idx,
    output reg[31:0] imm,
    output reg[4:0] shamt,
    output reg[`CSR_LEN-1:0] csr_idx,
    output reg[31:0] zimm,
    output reg[`PC_SIZE-1:0] pc_out,
    output reg[`PC_SIZE-1:0] pc_next_out,
    
    output reg addi_flag,
    output reg slli_flag,
    output reg slti_flag,
    output reg sltiu_flag,
    output reg xori_flag,
    output reg srli_flag,
    output reg srai_flag,
    output reg ori_flag,
    output reg andi_flag,
    
    output reg add_flag,
    output reg sub_flag,
    output reg sll_flag,
    output reg slt_flag,
    output reg sltu_flag,
    output reg xor_flag,
    output reg srl_flag,
    output reg sra_flag,
    output reg or_flag,
    output reg and_flag,
    
    output reg jal_flag,
    output reg jalr_flag,
    output reg beq_flag,
    output reg bne_flag,
    output reg blt_flag,
    output reg bge_flag,
    output reg bltu_flag,
    output reg bgeu_flag,
    
    output reg lui_flag,
    output reg auipc_flag,
    
    output reg lb_flag,
    output reg lh_flag,
    output reg lw_flag,
    output reg lbu_flag,
    output reg lhu_flag,
    output reg sb_flag,
    output reg sh_flag,
    output reg sw_flag,
    
    output reg csrrw_flag,
    output reg csrrs_flag,
    output reg csrrc_flag,
    output reg csrrwi_flag,
    output reg csrrsi_flag,
    output reg csrrci_flag
    );
    
    
    always@(posedge clk or negedge rst_)
    if(!rst_)
        exe_start <= 1'b0;
    else if(decode_start)
        exe_start <= 1'b1;
    else
        exe_start <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        pc_out <= `PC_SIZE'd0;
    else if(decode_start)
        pc_out <= pc_in;
    else
        pc_out <= `PC_SIZE'd0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        pc_next_out <= `PC_SIZE'd0;
    else if(decode_start)
        pc_next_out <= pc_next;
    else
        pc_next_out <= `PC_SIZE'd0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        rs1_idx <= `REG_SIZE'd0;
    else if(decode_start)
        case(instruct[6:0])
        `OPCODE_JAL:    rs1_idx <= `REG_SIZE'd0;
        `OPCODE_JALR:   rs1_idx <= instruct[19:15];
        `OPCODE_BXX:    rs1_idx <= instruct[19:15];
        `OPCODE_LOAD:   rs1_idx <= instruct[19:15];
        `OPCODE_SAVE:   rs1_idx <= instruct[19:15];
        `OPCODE_I:      rs1_idx <= instruct[19:15];
        `OPCODE_R:      rs1_idx <= instruct[19:15];
        `OPCODE_CSR:    if((instruct[19:15] == `FUNCT_CSRRW) || (instruct[19:15] == `FUNCT_CSRRS) || (instruct[19:15] == `FUNCT_CSRRC))
                            rs1_idx <= instruct[19:15];
                        else
                            rs1_idx <= `REG_SIZE'd0;
        `OPCODE_LUI:    rs1_idx <= `REG_SIZE'd0;
        `OPCODE_AUIPC:  rs1_idx <= `REG_SIZE'd0;
        default:        rs1_idx <= `REG_SIZE'd0;
        endcase
    else
        rs1_idx <= `REG_SIZE'd0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        rs2_idx <= `REG_SIZE'd0;
    else if(decode_start)
        case(instruct[6:0])
        `OPCODE_JAL:    rs2_idx <= `REG_SIZE'd0;
        `OPCODE_JALR:   rs2_idx <= `REG_SIZE'd0;
        `OPCODE_BXX:    rs2_idx <= instruct[24:20];
        `OPCODE_LOAD:   rs2_idx <= `REG_SIZE'd0;
        `OPCODE_SAVE:   rs2_idx <= instruct[24:20];
        `OPCODE_I:      rs2_idx <= `REG_SIZE'd0;
        `OPCODE_R:      rs2_idx <= instruct[24:20];
        `OPCODE_CSR:    rs2_idx <= `REG_SIZE'd0;
        `OPCODE_LUI:    rs2_idx <= `REG_SIZE'd0;
        `OPCODE_AUIPC:  rs2_idx <= `REG_SIZE'd0;
        default:        rs2_idx <= `REG_SIZE'd0;
        endcase
    else
        rs2_idx <= `REG_SIZE'd0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        rd_idx <= `REG_SIZE'd0;
    else if(decode_start)
        case(instruct[6:0])
        `OPCODE_JAL:    rd_idx <= instruct[11:7];
        `OPCODE_JALR:   rd_idx <= instruct[11:7];
        `OPCODE_BXX:    rd_idx <= `REG_SIZE'd0;
        `OPCODE_LOAD:   rd_idx <= instruct[11:7];
        `OPCODE_SAVE:   rd_idx <= `REG_SIZE'd0;
        `OPCODE_I:      rd_idx <= instruct[11:7];
        `OPCODE_R:      rd_idx <= instruct[11:7];
        `OPCODE_CSR:    rd_idx <= instruct[11:7];
        `OPCODE_LUI:    rd_idx <= instruct[11:7];
        `OPCODE_AUIPC:  rd_idx <= instruct[11:7];
        default:        rd_idx <= `REG_SIZE'd0;
        endcase
    else
        rd_idx <= `REG_SIZE'd0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        imm <= 32'h0000_0000;
    else if(decode_start)
        case(instruct[6:0])
        `OPCODE_JAL:    imm <= {{12{instruct[31]}},instruct[19:12],instruct[20],instruct[30:21],1'b0};
        `OPCODE_JALR:   imm <= {{20{instruct[31]}},instruct[31:20]};
        `OPCODE_BXX:    imm <= {{20{instruct[31]}},instruct[7],instruct[30:25],instruct[11:8],1'b0};
        `OPCODE_LOAD:   imm <= {{20{instruct[31]}},instruct[31:20]};
        `OPCODE_SAVE:   imm <= {{20{instruct[31]}},instruct[31:25],instruct[11:7]};
        `OPCODE_I:      if((instruct[14:12] == `FUNCT_SLL) || (instruct[14:12] == `FUNCT_SRL))
                            imm <= 32'h0000_0000;
                        else
                            imm <= {{20{instruct[31]}},instruct[31:20]};
        `OPCODE_R:      imm <= 32'h0000_0000;
        `OPCODE_CSR:    imm <= 32'h0000_0000;
        `OPCODE_LUI:    imm <= {instruct[31:12],12'b0000_0000_0000};
        `OPCODE_AUIPC:  imm <= {instruct[31:12],12'b0000_0000_0000};
        default:        imm <= 32'h0000_0000;
        endcase
    else
        imm <= 32'h0000_0000;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        shamt <= 5'd0;
    else if(decode_start)
        if(instruct[6:0] == `OPCODE_I)
            if((instruct[14:12] == `FUNCT_SLL) || (instruct[14:12] == `FUNCT_SRL))
                shamt <= instruct[24:20];
            else
                shamt <= 5'd0;
        else
            shamt <= 5'd0;
    else
        shamt <= 5'd0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        csr_idx <= `CSR_LEN'd0;
    else if(decode_start)
        if(instruct[6:0] == `OPCODE_CSR)
            csr_idx <= instruct[31:20];
        else
            csr_idx <= `CSR_LEN'd0;
    else
        csr_idx <= `CSR_LEN'd0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        zimm <= 32'd0;
    else if(decode_start)
        if(instruct[6:0] == `OPCODE_CSR)
            if((instruct[14:12] == `FUNCT_CSRRWI) || (instruct[14:12] == `FUNCT_CSRRSI) || (instruct[14:12] == `FUNCT_CSRRCI))
                zimm <= {27'b0000_0000_0000_0000_0000_0000_000,instruct[19:15]};
            else
                zimm <= 32'd0;
        else
            zimm <= 32'd0;
    else
        zimm <= 32'd0;

    always@(posedge clk or negedge rst_)
    if(!rst_)
        lui_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_LUI))
        lui_flag <= 1'b1;
    else
        lui_flag <= 1'b0;

    always@(posedge clk or negedge rst_)
    if(!rst_)
        auipc_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_AUIPC))
        auipc_flag <= 1'b1;
    else
        auipc_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        jal_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_JAL))
        jal_flag <= 1'b1;
    else
        jal_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        jalr_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_JALR))
        jalr_flag <= 1'b1;
    else
        jalr_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        beq_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_BXX) && (instruct[14:12] == `FUNCT_BEQ))
        beq_flag <= 1'b1;
    else
        beq_flag <= 1'b0;

    always@(posedge clk or negedge rst_)
    if(!rst_)
        bne_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_BXX) && (instruct[14:12] == `FUNCT_BNE))
        bne_flag <= 1'b1;
    else
        bne_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        blt_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_BXX) && (instruct[14:12] == `FUNCT_BLT))
        blt_flag <= 1'b1;
    else
        blt_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        bge_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_BXX) && (instruct[14:12] == `FUNCT_BGE))
        bge_flag <= 1'b1;
    else
        bge_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        bltu_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_BXX) && (instruct[14:12] == `FUNCT_BLTU))
        bltu_flag <= 1'b1;
    else
        bltu_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        bgeu_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_BXX) && (instruct[14:12] == `FUNCT_BGEU))
        bgeu_flag <= 1'b1;
    else
        bgeu_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        lb_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_LOAD) && (instruct[14:12] == `FUNCT_LB))
        lb_flag <= 1'b1;
    else
        lb_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        lh_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_LOAD) && (instruct[14:12] == `FUNCT_LH))
        lh_flag <= 1'b1;
    else
        lh_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        lw_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_LOAD) && (instruct[14:12] == `FUNCT_LW))
        lw_flag <= 1'b1;
    else
        lw_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        lbu_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_LOAD) && (instruct[14:12] == `FUNCT_LBU))
        lbu_flag <= 1'b1;
    else
        lbu_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        lhu_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_LOAD) && (instruct[14:12] == `FUNCT_LHU))
        lhu_flag <= 1'b1;
    else
        lhu_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        sb_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_SAVE) && (instruct[14:12] == `FUNCT_SB))
        sb_flag <= 1'b1;
    else
        sb_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        sh_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_SAVE) && (instruct[14:12] == `FUNCT_SH))
        sh_flag <= 1'b1;
    else
        sh_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        sw_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_SAVE) && (instruct[14:12] == `FUNCT_SW))
        sw_flag <= 1'b1;
    else
        sw_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        addi_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_I) && (instruct[14:12] == `FUNCT_ADD))
        addi_flag <= 1'b1;
    else
        addi_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        slli_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_I) && (instruct[14:12] == `FUNCT_SLL))
        slli_flag <= 1'b1;
    else
        slli_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        slti_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_I) && (instruct[14:12] == `FUNCT_SLT))
        slti_flag <= 1'b1;
    else
        slti_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        sltiu_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_I) && (instruct[14:12] == `FUNCT_SLTU))
        sltiu_flag <= 1'b1;
    else
        sltiu_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        xori_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_I) && (instruct[14:12] == `FUNCT_XOR))
        xori_flag <= 1'b1;
    else
        xori_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        srli_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_I) && (instruct[14:12] == `FUNCT_SRL) && (instruct[30] == 1'b0))
        srli_flag <= 1'b1;
    else
        srli_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        srai_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_I) && (instruct[14:12] == `FUNCT_SRA) && (instruct[30] == 1'b1))
        srai_flag <= 1'b1;
    else
        srai_flag <= 1'b0;

    always@(posedge clk or negedge rst_)
    if(!rst_)
        ori_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_I) && (instruct[14:12] == `FUNCT_OR))
        ori_flag <= 1'b1;
    else
        ori_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        andi_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_I) && (instruct[14:12] == `FUNCT_AND))
        andi_flag <= 1'b1;
    else
        andi_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        add_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_R) && (instruct[14:12] == `FUNCT_ADD) && (instruct[30] == 1'b0))
        add_flag <= 1'b1;
    else
        add_flag <= 1'b0;
    
    always@(posedge clk or negedge rst_)
    if(!rst_)
        sub_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_R) && (instruct[14:12] == `FUNCT_SUB) && (instruct[30] == 1'b1))
        sub_flag <= 1'b1;
    else
        sub_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        sll_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_R) && (instruct[14:12] == `FUNCT_SLL))
        sll_flag <= 1'b1;
    else
        sll_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        slt_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_R) && (instruct[14:12] == `FUNCT_SLT))
        slt_flag <= 1'b1;
    else
        slt_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        sltu_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_R) && (instruct[14:12] == `FUNCT_SLTU))
        sltu_flag <= 1'b1;
    else
        sltu_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        xor_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_R) && (instruct[14:12] == `FUNCT_XOR))
        xor_flag <= 1'b1;
    else
        xor_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        srl_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_R) && (instruct[14:12] == `FUNCT_SRL) && (instruct[30] == 1'b0))
        srl_flag <= 1'b1;
    else
        srl_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        sra_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_R) && (instruct[14:12] == `FUNCT_SRA) && (instruct[30] == 1'b1))
        sra_flag <= 1'b1;
    else
        sra_flag <= 1'b0;

    always@(posedge clk or negedge rst_)
    if(!rst_)
        or_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_R) && (instruct[14:12] == `FUNCT_OR))
        or_flag <= 1'b1;
    else
        or_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        and_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_R) && (instruct[14:12] == `FUNCT_AND))
        and_flag <= 1'b1;
    else
        and_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        csrrw_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_CSR) && (instruct[14:12] == `FUNCT_CSRRW))
        csrrw_flag <= 1'b1;
    else
        csrrw_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        csrrs_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_CSR) && (instruct[14:12] == `FUNCT_CSRRS))
        csrrs_flag <= 1'b1;
    else
        csrrs_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        csrrc_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_CSR) && (instruct[14:12] == `FUNCT_CSRRC))
        csrrc_flag <= 1'b1;
    else
        csrrc_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        csrrwi_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_CSR) && (instruct[14:12] == `FUNCT_CSRRWI))
        csrrwi_flag <= 1'b1;
    else
        csrrwi_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        csrrsi_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_CSR) && (instruct[14:12] == `FUNCT_CSRRSI))
        csrrsi_flag <= 1'b1;
    else
        csrrsi_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        csrrci_flag <= 1'b0;
    else if((decode_start == 1'b1) && (instruct[6:0] == `OPCODE_CSR) && (instruct[14:12] == `FUNCT_CSRRCI))
        csrrci_flag <= 1'b1;
    else
        csrrci_flag <= 1'b0;

endmodule
