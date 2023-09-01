# 功能描述（含所有实现的指令描述，以及单周期 CPU 频率）
在 Minisys 开发板上实现了单周期 CPU，完成了 25 条指令
1. R 型指令：add、sub、and、or、xor、sll、srl、sra
2. I 型指令：addi、andi、ori、xori、slli、srli、lw、jalr
3. S 型指令：sw
4. B 型指令：beq、bne、blt、bge
5. U 型指令：lui、auipc
6. J 型指令：jal
单周期频率为 25MHz

# 设计框图
![image](https://github.com/HITszzzq/COMP2012_lab/assets/74006311/5f4e07d5-bf3f-4484-9029-f6c8c1611455)
![image](https://github.com/HITszzzq/COMP2012_lab/assets/74006311/df6912a7-280c-49d8-bdb4-b358cf1316ed)
