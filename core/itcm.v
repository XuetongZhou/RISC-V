`timescale 1ns / 1ps
`include "cpu_define.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/02 22:22:21
// Design Name: 
// Module Name: itcm
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


module itcm(
    input clk_a,
    input wen_a,
    input[`PC_SIZE-1:0] addr_a,
    input[7:0] in_a,
    input ren_b,
    input[`PC_SIZE-1:0] addr_b,
    output [31:0] out_b
    );
    
    reg[7:0] instruct [512:0];
    
    always @(posedge clk_a)
    if (wen_a)
        instruct[addr_a] <= in_a;
    else;

    assign out_b = ren_b ? {instruct[addr_b+3],instruct[addr_b+2],instruct[addr_b+1],instruct[addr_b]} : 32'h0000_0000;

endmodule
