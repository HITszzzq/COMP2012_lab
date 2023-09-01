`timescale 1ns / 1ps
module mycpu
(
    input         clk_i,
    input         reset_i,
    input  [31:0] mem_rd,
    output [31:0] wdata_o,
    output [31:0] addr_o,
    output        we_o
    //input  [31:0] inst_i,
    //output [31:0] pc_o,
    //output        mem_we_o,
    //output [13:0] adr_o,
    //output [31:0] outer_inputdata_o,
    //input  [31:0] outer_outputdata_i,
    //output        rf_we_o,
    //output [31:0] rf_wd_o,
    //output [4:0]  rf_wr_o,
    //output [31:0] npc_o
);
    // 数据信号
    wire cpu_clk;             // cpu时钟信号
    wire [31:0] ext;          // 经过拓展处理的立即数
    wire [31:0] rD1;          // Regfile读出的reg1
    wire [31:0] rD2;          // Regfile读出的reg2
    wire [31:0] return_pc;    // 用于jal与jalr，将pc+4存储到rd
    wire [31:0] current_pc;   // 用于B型指令，将当前pc值送入ALU
    wire [31:0] inst;         // 从imem读出的指令
    wire [31:0] alu_result;   // alu运算结果输出
    // wire [31:0] mem_rd;       // dmem读出数据
    // 控制信号
    wire [1:0] wd_sel;        // 选择写入regfile的数据控制线
    wire [1:0] pc_sel;        // pc选择控制线
    wire branch_controler;    // branch控制线
    wire branch_exe;          // alu运算结果branch
    wire branch;
    wire [2:0] imm_sel;             // 对立即数拓展单元的控制线，选择出合适的立即数
    wire regfile_we;          // Regfile写使能控制
    wire mem_we;              // dmem写使能控制
    wire op_A_sel;            // ALU输入选择信号
    wire op_B_sel;            // ALU输入选择信号
    wire [3:0] alu_opcode;    // ALU操作码
    // test
    // reg [31:0] pc_tmp;
    // wire [1:0] mem_data_sel;
    
    
    // assign adr_o = alu_result[15:2];
    // assign adr_o = alu_result[14:1];
    // assign mem_we_o = mem_we;
    // assign outer_inputdata_o = rD2;
    assign branch = branch_controler & branch_exe;
    assign wdata_o = rD2;
    assign addr_o = alu_result;
    assign we_o = mem_we;
    
    assign cpu_clk = clk_i;
    
    // cpuclk u_cpuclk(
    //     .clk_in1    (sysclk_i),
    //     .clk_out1   (cpu_clk)
    // );

    controler u_controler(
        .reset_i       (reset_i),
        .opcode_i      (inst[6:0]),
        .function7_i   (inst[31:25]),
        .function3_i   (inst[14:12]),
        .wd_sel_o      (wd_sel),   
        .pc_sel_o      (pc_sel),   
        .branch_o      (branch_controler),     
        .imm_sel_o     (imm_sel),    
        .regfile_we_o  (regfile_we), 
        .mem_we_o      (mem_we),     
        .op_A_sel_o    (op_A_sel),   
        .op_B_sel_o    (op_B_sel),   
        .alu_opcode_o  (alu_opcode)
    );

    IFplus u_IFplus(
        .clk_i       (cpu_clk),
        .reset_i     (reset_i),
        .pc_sel_i    (pc_sel),
        .offset_i    (ext),
        .rD1_i       (rD1),
        .branch_i    (branch),
        .inst_o      (inst),
        .return_pc_o (return_pc),
        .current_pc_o(current_pc)     // 用于auipc
        // .pc_o        (pc_o)            // 测试
    );
    ID u_ID(
        .clk_i       (cpu_clk),
        .reset_i     (reset_i),
        .return_pc_i (return_pc),
        .ALU_result_i(alu_result),
        // .mem_data_i  (mem_rd),
        .mem_data_i  (mem_rd),        
        .wd_sel_i    (wd_sel),
        .we_i        (regfile_we),
        .inst_i      (inst),
        .imm_sel_i   (imm_sel),
        .ext_o       (ext),
        .rD1_o       (rD1),
        .rD2_o       (rD2)
        //.we_o        (rf_we_o),
        //.wD_o        (rf_wd_o),
        //.wR_o        (rf_wr_o)
    );
    EX u_EX(
        .op_A_sel_i  (op_A_sel),
        .op_B_sel_i  (op_B_sel),
        .current_pc_i(current_pc),
        .rD1_i       (rD1),
        .rD2_i       (rD2),
        .ext_i       (ext),
        .alu_result_o(alu_result),
        .alu_opcode_i(alu_opcode),
        .alu_branch_o(branch_exe)
    );
endmodule
