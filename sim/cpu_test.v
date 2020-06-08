`timescale 1ns / 1ps
`include "cpu_test_define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/08 11:40:44
// Design Name: 
// Module Name: cpu_test
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


module cpu_test;


    reg clk, rst_, start;
    
    reg itcm_en;
    reg[`PC_SIZE-1:0] itcm_addr;
    reg[7:0] itcm_data;
    
    reg dtcm_en;
    reg[`DATA_SIZE-1:0] dtcm_addr;
    reg[7:0] dtcm_data;
    
    wire error;
    
    wire wb_csr_en;
    wire[`CSR_LEN-1:0] wb_csr_addr;
    wire[31:0] wb_csr_data;
    wire[`CSR_LEN-1:0] exe_csr_addr;
    reg[31:0] csr_exe_data;
    
    initial
    begin
        clk = 0;
        forever #(`CLOCK_PERIOD/2) clk = ~clk;
    end
    
    initial #(`INSTRUCT_NUM*6 * `CLOCK_PERIOD) $stop;
    
    initial
    begin
        rst_ = 0;
        #(`INSTRUCT_NUM*4 * `CLOCK_PERIOD) rst_ = 1;
    end
    
    initial
    begin
        start = 0;
        #((`INSTRUCT_NUM*4+1) * `CLOCK_PERIOD) start = 1;
    end
    
    initial
    begin
        itcm_en = 1;
        #(`INSTRUCT_NUM*4 * `CLOCK_PERIOD) itcm_en = 0;
    end
    
    initial
    begin
        itcm_addr = `PC_SIZE'd0;
        repeat(`INSTRUCT_NUM*4-1) #`CLOCK_PERIOD itcm_addr = itcm_addr + `PC_SIZE'd1;
    end
    
    initial
    begin
        itcm_data = 8'b1001_0011;
        #`CLOCK_PERIOD itcm_data = 8'b0000_0000;
        #`CLOCK_PERIOD itcm_data = 8'b0001_0000;
        #`CLOCK_PERIOD itcm_data = 8'b0000_0000;         // addi x1, x0, 12'd1
        
        #`CLOCK_PERIOD itcm_data = 8'b0000_0011;
        #`CLOCK_PERIOD itcm_data = 8'b0010_0001;
        #`CLOCK_PERIOD itcm_data = 8'b0100_0000;
        #`CLOCK_PERIOD itcm_data = 8'b0000_0000;         // lw x2, x0, 12'd4
        
        #`CLOCK_PERIOD itcm_data = 8'b1000_0011;
        #`CLOCK_PERIOD itcm_data = 8'b1000_0001;
        #`CLOCK_PERIOD itcm_data = 8'b0111_0000;
        #`CLOCK_PERIOD itcm_data = 8'b0000_0000;         // lb x3, x1, 12'd7
        
        #`CLOCK_PERIOD itcm_data = 8'b0110_1111;
        #`CLOCK_PERIOD itcm_data = 8'b0000_0010;
        #`CLOCK_PERIOD itcm_data = 8'b1000_0000;
        #`CLOCK_PERIOD itcm_data = 8'b0000_0000;         // jal x4, 21'd8     
        
        #`CLOCK_PERIOD itcm_data = 8'b0011_0011;
        #`CLOCK_PERIOD itcm_data = 8'b1111_0010;
        #`CLOCK_PERIOD itcm_data = 8'b0010_0000;
        #`CLOCK_PERIOD itcm_data = 8'b0000_0000;         // and x4, x1, x2
        
        #`CLOCK_PERIOD itcm_data = 8'b1010_0011;
        #`CLOCK_PERIOD itcm_data = 8'b1010_0011;
        #`CLOCK_PERIOD itcm_data = 8'b0011_0000;
        #`CLOCK_PERIOD itcm_data = 8'b0000_0000;         // sw x3, x1, 12'd7
    end
    
    initial
    begin
        dtcm_en = 1;
        #(`DATA_NUM*4 * `CLOCK_PERIOD) dtcm_en = 0;
    end
    
    initial
    begin
        dtcm_addr = `DATA_SIZE'd0;
        repeat(`DATA_NUM*4-1) #`CLOCK_PERIOD dtcm_addr = dtcm_addr + `DATA_SIZE'd1;
    end
    
    initial
    begin
        dtcm_data = 8'b0000_0001;
        #`CLOCK_PERIOD dtcm_data = 8'b0000_0000;
        #`CLOCK_PERIOD dtcm_data = 8'b0000_0000;
        #`CLOCK_PERIOD dtcm_data = 8'b0000_0000;             //1
        
        #`CLOCK_PERIOD dtcm_data = 8'b0000_0010;
        #`CLOCK_PERIOD dtcm_data = 8'b0000_0000;
        #`CLOCK_PERIOD dtcm_data = 8'b0000_0000;
        #`CLOCK_PERIOD dtcm_data = 8'b0000_0000;             //2
        
        #`CLOCK_PERIOD dtcm_data = 8'b0000_0011;
        #`CLOCK_PERIOD dtcm_data = 8'b1111_1111;
        #`CLOCK_PERIOD dtcm_data = 8'b1111_1111;
        #`CLOCK_PERIOD dtcm_data = 8'b1111_1111;             //3
    end

    initial csr_exe_data = 32'd0;

    cpu_top cpu(
    .clk(clk),
    .rst_(rst_),
    .start(start),
    .error(error),
    
    //itcm interface
    .itcm_en(itcm_en),
    .itcm_addr(itcm_addr),
    .itcm_data(itcm_data),
    
    //dtcm interface
    .dtcm_en(dtcm_en),
    .dtcm_addr(dtcm_addr),
    .dtcm_data(dtcm_data),
    
    //CSR interface
    .wb_csr_en(wb_csr_en),
    .wb_csr_addr(wb_csr_addr),
    .wb_csr_data(wb_csr_data),
    
    .exe_csr_addr(exe_csr_addr),
    .csr_exe_data(csr_exe_data)
    );
    
endmodule
