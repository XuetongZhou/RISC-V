`timescale 1ns / 1ps
`include "cpu_define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/06 16:04:54
// Design Name: 
// Module Name: writeback_unit
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


module writeback_unit(
    input clk,
    input rst_,
    
    //The regfile bus
    output reg regfile_en,
    output reg[`REG_SIZE-1:0] rd_addr,
    output reg[31:0] rd_data_out,
    
    //The dtcm bus
    output reg sb_en,
    //output reg sh_en,
    //output reg sw_en,
    output reg[`DATA_SIZE-1:0] dtcm_addr,
    output reg[7:0] sb_data,
    //output reg[15:0] sh_data,
    //output reg[31:0] sw_data,
    
    //The CSR bus
    output reg csr_en_out,
    output reg[`CSR_LEN-1:0] csr_addr,
    output reg[31:0] csr_data_out,
    
    //The ifu_unit bus
    output reg flush_flag,
    output reg[`PC_SIZE-1:0] pc_new,
    
    //The exe_unit bus
    input wb_start,
    input[`REG_SIZE-1:0] rd_idx,
    input[31:0] rd_data,
    input[31:0] jump_addr,
    input[`DATA_SIZE-1:0] save_addr,
    input[31:0] save_data,
    input[`CSR_LEN-1:0] csr_idx,
    input[31:0] csr_data,
    
    input sb_flag,
    input sh_flag,
    input sw_flag,
    
    input rd_en,
    input jump_en,
    input save_en,
    input csr_en,
    
    input[`PC_SIZE-1:0] pc_next
    );
    
    
    reg[2:0] count;
    
    always@(posedge clk or negedge rst_)
    if(!rst_)
        rd_addr <= `REG_SIZE'd0;
    else if(wb_start)
        rd_addr <= rd_idx;
    else
        rd_addr <= `REG_SIZE'd0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        rd_data_out <= 32'd0;
    else if(wb_start)
        rd_data_out <= rd_data;
    else
        rd_data_out <= 32'd0;
    
    always@(posedge clk or negedge rst_)
    if(!rst_)
        dtcm_addr <= 32'd0;
    else if(wb_start)
        dtcm_addr <= save_addr;
    else
        dtcm_addr <= 32'd0;

    always@(posedge clk or negedge rst_)
    if(!rst_)
        sb_data <= 8'd0;
    else if(wb_start)
        if(sb_flag)
            sb_data <= save_data[7:0];
        else
            sb_data <= 8'd0;
    else
        sb_data <= 8'd0;
     
     /*   
    always@(posedge clk or negedge rst_)
    if(!rst_)
        sh_data <= 16'd0;
    else if(wb_start)
        if(sh_flag)
            sh_data <= save_data[15:0];
        else
            sh_data <= 16'd0;
    else
        sh_data <= 16'd0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        sw_data <= 32'd0;
    else if(wb_start)
        if(sw_flag)
            sw_data <= save_data;
        else
            sw_data <= 32'd0;
    else
        sw_data <= 32'd0;
    */
    
    always@(posedge clk or negedge rst_)
    if(!rst_)
        csr_addr <= `CSR_LEN'd0;
    else if(wb_start)
        csr_addr <= csr_idx;
    else
        csr_addr <= `CSR_LEN'd0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        csr_data_out <= 32'd0;
    else if(wb_start)
        csr_data_out <= csr_data;
    else
        csr_data_out <= 32'd0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        flush_flag <= 1'b0;
    else if(wb_start)
        if((jump_en == 1'b1) && (jump_addr[`PC_SIZE-1:0] != pc_next) )
            flush_flag <= 1'b1;
        else
            flush_flag <= 1'b0;
    else
        flush_flag <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        pc_new <= `PC_SIZE'd0;
    else if(wb_start)
        if((jump_en == 1'b1) && (jump_addr[`PC_SIZE-1:0] != pc_next) )
            pc_new <= jump_addr[`PC_SIZE-1:0];
        else
            pc_new <= `PC_SIZE'd0;
    else
        pc_new <= `PC_SIZE'd0;
    
    always@(posedge clk or negedge rst_)
    if(!rst_)
        count <= 3'd0;
    else if(wb_start)
        if((jump_en == 1'b1) && (jump_addr[`PC_SIZE-1:0] != pc_next) )
            count <= 3'd4;
        else if(count > 0)
            count <= count -1;
        else
            count <= 3'd0;
    else
        count <= 3'd0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        regfile_en <= 1'b0;
    else if(wb_start)
        if(count == 3'd0)
            regfile_en <= rd_en;
        else
            regfile_en <= 1'b0;
    else
        regfile_en <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        sb_en <= 1'b0;
    else if(wb_start)
        if(count == 3'd0)
            sb_en <= sb_flag;
        else
            sb_en <= 1'b0;
    else
        sb_en <= 1'b0;

    /*
    always@(posedge clk or negedge rst_)
    if(!rst_)
        sh_en <= 1'b0;
    else if(wb_start)
        if(count == 3'd0)
            sh_en <= sh_flag;
        else
            sh_en <= 1'b0;
    else
        sh_en <= 1'b0;
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        sw_en <= 1'b0;
    else if(wb_start)
        if(count == 3'd0)
            sw_en <= sw_flag;
        else
            sw_en <= 1'b0;
    else
        sw_en <= 1'b0;
    */
        
    always@(posedge clk or negedge rst_)
    if(!rst_)
        csr_en_out <= 1'b0;
    else if(wb_start)
        if(count == 3'd0)
            csr_en_out <= csr_en;
        else
            csr_en_out <= 1'b0;
    else
        csr_en_out <= 1'b0;
    
endmodule
