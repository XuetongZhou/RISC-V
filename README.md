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

<p>四级流水线分别是取指、译码、执行、写回。其中取指阶段采用静态预测：对于有条件跳转指令，向前跳时预测为不跳，向后(向回)跳时预测为跳转。</p>

<p>由于Vivado不支持多个写端口的ram，所以暂时没有实现SH和SW指令，以后会考虑实现该功能。</p>

<p>RISC-V官方把CSR寄存器定义在特权架构中，这里没有实现。</p>

<p>当然我也不能保证现在的工程绝对是对的（手动狗头）。目前只对一部分指令进行了测试，还没有完全测试完成。</p>
