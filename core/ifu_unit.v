`timescale 1ns / 1ps
`include "cpu_define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/02 22:10:55
// Design Name: 
// Module Name: ifu_unit
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


module ifu_unit(
    input clk,
    input rst_,
    input start,
    
    //The itcm bus
    input[31:0] instruct_in,
    output reg itcm_ren,
    output reg[`PC_SIZE-1:0] pc,
    
    //The decode_unit bus
    output reg decode_start,
    output reg[31:0] instruct,
    output reg[`PC_SIZE-1:0] pc2decode,
    
    //The Regfile bus
    input[31:0] regfile_data,
    output[`REG_SIZE-1:0] regfile_addr,
    
    //The writeback_unit bus
    input flush_flag,
    input[`PC_SIZE-1:0] pc_new
    );
    
    wire[`PC_SIZE-1:0] pc_next;
    wire jump_flag;
    
    wire jal_flag;
    wire jalr_flag;
    wire bxx_flag;
    wire[31:0] bjp_imm;
    wire[31:0] jal_imm, jalr_imm, bxx_imm;
    
    wire[31:0] adder_in1, adder_in2, adder_out;
    
    assign jal_flag = (instruct_in[6:0] == `OPCODE_JAL) ? 1'b1 : 1'b0;
    assign jalr_flag = (instruct_in[6:0] == `OPCODE_JALR) ? 1'b1 : 1'b0;
    assign bxx_flag = (instruct_in[6:0] == `OPCODE_BXX) ? 1'b1 : 1'b0;
    
    assign jal_imm = {{12{instruct[31]}},instruct[19:12],instruct[20],instruct[30:21],1'b0} << 1;
    assign jalr_imm = {{20{instruct[31]}},instruct[31:20]};
    assign bxx_imm = {{20{instruct[31]}},instruct[7],instruct[30:25],instruct[11:8],1'b0} << 1;
    
    assign bjp_imm = ({32{jal_flag}} & jal_imm) | ({32{bxx_flag}} & bxx_imm) | ({32{jalr_flag}} & jalr_imm);
    
    assign jump_flag = jal_flag | jalr_flag | (bxx_flag & bjp_imm[31]);
    
    assign regfile_addr = jalr_flag ? instruct[19:15] : `REG_SIZE'd0;
    
    assign adder_in1 = jalr_flag ? regfile_data : {{`PC_COVER_SIZE{1'b0}},pc};
    assign adder_in2 = jump_flag ? bjp_imm : 32'd4;
    assign adder_out = adder_in1 + adder_in2;
    
    assign pc_next = adder_out[`PC_SIZE-1:0];
    
    always@(posedge clk or negedge rst_)
    if(!rst_)
        pc <= `PC_SIZE'd0;
    else if(start)
        if(flush_flag)
            pc <= pc_new;
        else
            pc <= pc_next;
    else;
    
    always@(posedge clk or negedge rst_)
    if(!rst_)
        itcm_ren <= 1'b0;
    else
        itcm_ren <= 1'b1;
    
    always@(posedge clk or negedge rst_)
    if(!rst_)
        decode_start <= 1'b0;
    else if(start)
        decode_start <= 1'b1;
    else
        decode_start <= 1'b0;
    
    always@(posedge clk or negedge rst_)
    if(!rst_)
        instruct <= 32'h0000_0000;
    else if(start)
        instruct <= instruct_in;
    else;
    
    always@(posedge clk or negedge rst_)
    if(!rst_)
        pc2decode <= `PC_SIZE'd0;
    else if(start)
        pc2decode <= pc;
    else
        pc2decode <= `PC_SIZE'd0;
    
endmodule