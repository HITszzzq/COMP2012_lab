`timescale 1ns / 1ps
module alusel #(
    parameter CURRENTPC = 1'b0,
    parameter RD1       = 1'b1,
    parameter EXT       = 1'b0,
    parameter RD2       = 1'b1
)
(
    input             op_A_sel_i,
    input             op_B_sel_i,
    input      [31:0] current_pc_i,
    input      [31:0] rD1_i,
    input      [31:0] rD2_i,
    input      [31:0] ext_i,
    output reg [31:0] alu_op_a_o,
    output reg [31:0] alu_op_b_o
);
    always @(*) begin
        case(op_A_sel_i)
            CURRENTPC: alu_op_a_o = current_pc_i;
            RD1:       alu_op_a_o = rD1_i;
            default:   alu_op_a_o = 32'h0;
        endcase
    end
    always @(*) begin
        case(op_B_sel_i)
            EXT:       alu_op_b_o = ext_i;
            RD2:       alu_op_b_o = rD2_i;
            default:   alu_op_b_o = 32'h0;
        endcase
    end
endmodule
