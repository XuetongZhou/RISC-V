# RISC-V

这是一个基于FPGA的四级流水线RISC-V CPU软核，目前还在完善中。
___

实现了大部分R32I中的指令：<br>
>寄存器-立即数指令<br>
>>ANDI
>>SLLI
>>SLTI
>>SLTIU
>>XORI
>>SRLI
>>SRAI
>>ORI
>>ANDI
>>LUI
>>AUIPC

>寄存器-寄存器指令<br>
>>AND
>>SUB
>>SLL
>>SLT
>>SLTU
>>XOR
>>SRL
>>SRA
>>OR
>>AND

>跳转指令<br>
>>无条件直接跳转<br>
>>>JAL

>>无条件间接跳转<br>
>>>JALR

>>有条件跳转<br>
>>>BEQ
>>>BNE
>>>BLT
>>>BGE
>>>BLTU
>>>BGEU

>Load指令<br>
>>LB
>>LH
>>LW
>>LBU
>>LHU

>Save指令<br>
>>SB

>CSR指令<br>
>>CSRRW
>>CSRRS
>>CSRRC
>>CSRRWI
>>CSRRSI
>>CSRRCI

由于Vivado不支持多个写端口的ram，所以暂时没有实现SH和SW指令，以后会考虑实现该功能。<br>
RISC-V官方把CSR寄存器定义在特权架构中，这里没有实现。
