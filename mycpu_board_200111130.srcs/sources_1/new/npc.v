`timescale 1ns / 1ps
module npc #(
    parameter INTERPRETER_NPC = 32'b0                  // 对应pc_sel信号异常，转入中断处理
)
(
    input              reset_i,
    input       [1:0]  pc_sel_i,
    input       [31:0] pc_i,
    input       [31:0] offset_i,
    input       [31:0] rD1_i,
    input              branch_i,
    output reg  [31:0] next_pc_o,
    output      [31:0] pc_plus_4_o                      // 用于jal指令与jalr指令
);
    always @(*) begin
        if(reset_i == 1'b1)
            next_pc_o = pc_i;
        else begin
            case (pc_sel_i)
                2'b00: next_pc_o = pc_i + 3'b100;                                         // pc+4
                2'b01: next_pc_o = (branch_i == 1'b1) ? pc_i + offset_i : pc_i + 3'b100;  // Branch
                2'b10: next_pc_o = pc_i + offset_i;                                       // jal
                2'b11: next_pc_o = (rD1_i + offset_i) & (~1);                             // jalr
                default: 
                    next_pc_o = INTERPRETER_NPC;
            endcase 
        end      
    end
    assign pc_plus_4_o = pc_i+3'b100;
endmodule
