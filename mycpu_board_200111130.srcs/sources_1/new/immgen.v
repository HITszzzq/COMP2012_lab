`timescale 1ns / 1ps
module immgen #(
    parameter IMM_R          = 3'b000,
    parameter IMM_I_nonshift = 3'b001, 
    parameter IMM_I_shift    = 3'b010,
    parameter IMM_S          = 3'b011, 
    parameter IMM_B          = 3'b100,
    parameter IMM_U          = 3'b101,
    parameter IMM_J          = 3'b110  
)
(
    input              reset_i,
    input       [31:0] inst_i,
    input        [2:0] imm_sel_i,
    output reg [31:0] ext_o
);
    always@(*) begin
        if(reset_i == 1'b1)
            ext_o = 32'h0;
        else begin
            case(imm_sel_i)
            IMM_R:          ext_o = 32'h0;
            IMM_I_nonshift: ext_o = {{20{inst_i[31]}}, inst_i[31:20]};
            IMM_I_shift:    ext_o = {{27{inst_i[24]}}, inst_i[24:20]};
            IMM_S:          ext_o = {{20{inst_i[31]}}, inst_i[31:25], inst_i[11:7]};
            IMM_B:          ext_o = {{19{inst_i[31]}}, inst_i[31], inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0};
            IMM_U:          ext_o = {inst_i[31:12], 12'b0};
            IMM_J:          ext_o = {{10{inst_i[31]}}, inst_i[31], inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0};
            default: 
                ext_o = 32'h0;
            endcase
        end
    end
endmodule
