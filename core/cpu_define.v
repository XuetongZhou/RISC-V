//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/06/04 17:21:37
// Design Name: 
// Module Name: cpu_define
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

`define PC_SIZE     9
`define REG_SIZE    5
`define DATA_SIZE   9
`define CSR_LEN    12

`define PC_COVER_SIZE 32-`PC_SIZE

`define OPCODE_JAL      7'b1101111
`define OPCODE_JALR     7'b1100111
`define OPCODE_BXX      7'b1100011
`define OPCODE_LOAD     7'b0000011
`define OPCODE_SAVE     7'b0100011
`define OPCODE_I        7'b0010011
`define OPCODE_R        7'b0110011
`define OPCODE_CSR      7'b1110011
`define OPCODE_LUI      7'b0110111
`define OPCODE_AUIPC    7'b0010111

`define FUNCT_BEQ       3'b000
`define FUNCT_BNE       3'b001
`define FUNCT_BLT       3'b100
`define FUNCT_BGE       3'b101
`define FUNCT_BLTU      3'b110
`define FUNCT_BGEU      3'b111

`define FUNCT_LB        3'b000
`define FUNCT_LH        3'b001
`define FUNCT_LW        3'b010
`define FUNCT_LBU       3'b100
`define FUNCT_LHU       3'b101

`define FUNCT_SB        3'b000
`define FUNCT_SH        3'b001
`define FUNCT_SW        3'b010

`define FUNCT_ADD       3'b000
`define FUNCT_SUB       3'b000
`define FUNCT_SLL       3'b001
`define FUNCT_SLT       3'b010
`define FUNCT_SLTU      3'b011
`define FUNCT_XOR       3'b100
`define FUNCT_SRL       3'b101
`define FUNCT_SRA       3'b101
`define FUNCT_OR        3'b110
`define FUNCT_AND       3'b111

`define FUNCT_CSRRW     3'b001
`define FUNCT_CSRRS     3'b010
`define FUNCT_CSRRC     3'b011
`define FUNCT_CSRRWI    3'b101
`define FUNCT_CSRRSI    3'b110
`define FUNCT_CSRRCI    3'b111