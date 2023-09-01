`timescale 1ns / 1ps
module alu #(
    parameter ADD = 4'b0000,
    parameter SUB = 4'b0001,
    parameter AND = 4'b0010,
    parameter OR  = 4'b0011,
    parameter XOR = 4'b0100,
    parameter SLL = 4'b0101,
    parameter SRL = 4'b0110,
    parameter SRA = 4'b0111,
    parameter LUI = 4'b1000,
    parameter BEQ = 4'b1001,
    parameter BNE = 4'b1010,
    parameter BLT = 4'b1011,
    parameter BGE = 4'b1100
)
(
    input    [3:0] alu_opcode_i,
    input   [31:0] alu_op_a_i,
    input   [31:0] alu_op_b_i,
    output  [31:0] alu_result_o,
    output         branch_o
);
    wire [31:0] sub_result = alu_op_a_i + (~alu_op_b_i + 1'b1);
    assign alu_result_o = (alu_opcode_i == ADD) ? (alu_op_a_i + alu_op_b_i) :
                           (alu_opcode_i == SUB) ? sub_result :
                           (alu_opcode_i == AND) ? (alu_op_a_i & alu_op_b_i) :
                           (alu_opcode_i == OR ) ? (alu_op_a_i | alu_op_b_i) :
                           (alu_opcode_i == XOR) ? (alu_op_a_i ^ alu_op_b_i) :
                           (alu_opcode_i == SLL) ? (alu_op_a_i << alu_op_b_i[4:0]) :
                           (alu_opcode_i == SRL) ? (alu_op_a_i >> alu_op_b_i[4:0]) :
                           (alu_opcode_i == SRA) ? ($signed($signed(alu_op_a_i) >>> alu_op_b_i[4:0])) :
                           (alu_opcode_i == LUI) ? alu_op_b_i :
                           32'b0;
    assign branch_o = ((alu_opcode_i == BEQ && alu_op_a_i == alu_op_b_i) ||
                        (alu_opcode_i == BNE && alu_op_a_i != alu_op_b_i) ||
                        (alu_opcode_i == BLT && sub_result[31]) ||
                        (alu_opcode_i == BGE && (~sub_result[31] || alu_op_a_i == alu_op_b_i))) ? 1'b1 :
                        1'b0;
endmodule
