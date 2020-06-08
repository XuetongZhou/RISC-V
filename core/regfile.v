`timescale 1ns / 1ps
`include "cpu_define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/02 22:21:13
// Design Name: 
// Module Name: regfile
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


module regfile(
    input clk_a,
    input wen_a,
    input[`REG_SIZE-1:0] addr_a,
    input[31:0] in_a,
    
    input[`REG_SIZE-1:0] addr_b,
    output [31:0] out_b
    );
    
    reg[31:0] reg_data [31:0];
    
    always @(posedge clk_a)
    if (wen_a)
        if(addr_a != `REG_SIZE'd0)
            reg_data[addr_a] <= in_a;
        else
            reg_data[addr_a] <= 32'd0;
    else;
    

    assign out_b = (addr_b == `REG_SIZE'd0) ? 32'd0 : reg_data[addr_b];

endmodule
