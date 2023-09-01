`timescale 1ns / 1ps
module rib(
    input              rst_i,
    input              clk_i,
    input  wire [2:0]  func,
	input  wire [7:0]  num1,
	input  wire [7:0]  num2,
    output wire [7:0]  led_en,
    output wire        led_ca,
    output wire        led_cb,
    output wire        led_cc,
    output wire        led_cd,
    output wire        led_ce,
    output wire        led_cf,
    output wire        led_cg,
    output wire        led_dp
    );
    
    wire rst_n = !rst_i;

    reg [31:0] cal_result;

    wire [31:0] data_i = {func, 5'b0, num1, num2};
    
    wire [31:0] mem_rd;
    
    wire [31:0] wdata;
    
    wire [31:0] addr;
    
    wire we;
    
    wire [31:0] rdata;
    
    wire [31:0] dram_output;
    
    wire clk;
    
    cpuclk u_cpuclk(
        .clk_in1    (clk_i),
        .clk_out1   (clk)
    );
    
    mycpu u_mycpu(
       .clk_i     (clk),
       .reset_i   (rst_i),
       .mem_rd    (mem_rd),
       .wdata_o   (wdata),
       .addr_o    (addr),
       .we_o      (we)
    );
    
    display u_display(
        .clk       (clk),
        .rst       (rst_n),
        .cal_result(cal_result),
        .led_en    (led_en),
        .led_ca    (led_ca),
        .led_cb    (led_cb),
        .led_cc    (led_cc),
        .led_cd    (led_cd),
        .led_ce    (led_ce),
        .led_cf    (led_cf),
        .led_cg    (led_cg),
        .led_dp    (led_dp)
    );
    
    dram u_dram(
        .clk    (clk),             // input wire clka
        .a      (addr[15:2]),              // input wire [13:0] addra
        .spo    (dram_output),       // output wire [31:0] douta
        .we     (we),                // input wire [0:0] wea
        .d      (wdata)         // input wire [31:0] dina
    );
    
    assign mem_rd = (addr == 32'hFFFFF070) ? data_i : dram_output;
    
    always@(posedge clk or negedge rst_n) begin
        if(~rst_n)                               cal_result <= 32'b0;
        else if(we & (addr == 32'hFFFFF000))   cal_result <= wdata;
    end
    
endmodule
