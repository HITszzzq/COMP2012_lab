`timescale 1ns / 1ps
module regfile(    
    input         clk_i,
    input         reset_i,
    input   [4:0] rR1_i,
    input   [4:0] rR2_i,
    input   [4:0] wR_i,
    input  [31:0] wD_i,
    input         WE_i,
    output [31:0] rD1_o,
    output [31:0] rD2_o
    );
    reg [31:0] reg_array[31:0];
    //WRITE
    always @(posedge clk_i) begin
        if (WE_i) reg_array[wR_i] <= wD_i;
    end
    //READ OUT 1
    assign rD1_o = (rR1_i == 5'b0) ? 32'b0 : reg_array[rR1_i];
    //READ OUT 2
    assign rD2_o = (rR2_i == 5'b0) ? 32'b0 : reg_array[rR2_i];
endmodule