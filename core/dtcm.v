`timescale 1ns / 1ps
`include "cpu_define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/02 22:22:32
// Design Name: 
// Module Name: dtcm
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


module dtcm(
    input clk,
    input wen_a,
    input[`DATA_SIZE-1:0] addr_a,
    input[7:0] in_a,
    
    input[`DATA_SIZE-1:0] addr_c,
    output[31:0] out_c
    );
    
    reg[7:0] data [512:0];
    
    always @(posedge clk)
    if (wen_a)
        data[addr_a] <= in_a;
    else;

/*
    always @(posedge clk)
    if (sb_en)
        data[addr_b] <= sb_in;
    else;
    
    always @(posedge clk)
    if (sh_en)
    begin
        data[addr_b] <= sh_in[7:0];
        data[addr_b + 1] <= sh_in[15:8];
    end
    else;
    
    always @(posedge clk)
    if (sw_en)
    begin
        data[addr_b] <= sw_in[7:0];
        data[addr_b + 1] <= sw_in[15:8];
        data[addr_b + 2] <= sw_in[23:16];
        data[addr_b + 3] <= sw_in[31:24];
    end
    else;
*/    
    assign out_c = {data[addr_c+3],data[addr_c+2],data[addr_c+1],data[addr_c]};

endmodule
