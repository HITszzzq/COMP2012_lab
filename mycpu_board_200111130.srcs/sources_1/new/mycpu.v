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
    // �����ź�
    wire cpu_clk;             // cpuʱ���ź�
    wire [31:0] ext;          // ������չ�����������
    wire [31:0] rD1;          // Regfile������reg1
    wire [31:0] rD2;          // Regfile������reg2
    wire [31:0] return_pc;    // ����jal��jalr����pc+4�洢��rd
    wire [31:0] current_pc;   // ����B��ָ�����ǰpcֵ����ALU
    wire [31:0] inst;         // ��imem������ָ��
    wire [31:0] alu_result;   // alu���������
    // wire [31:0] mem_rd;       // dmem��������
    // �����ź�
    wire [1:0] wd_sel;        // ѡ��д��regfile�����ݿ�����
    wire [1:0] pc_sel;        // pcѡ�������
    wire branch_controler;    // branch������
    wire branch_exe;          // alu������branch
    wire branch;
    wire [2:0] imm_sel;             // ����������չ��Ԫ�Ŀ����ߣ�ѡ������ʵ�������
    wire regfile_we;          // Regfileдʹ�ܿ���
    wire mem_we;              // dmemдʹ�ܿ���
    wire op_A_sel;            // ALU����ѡ���ź�
    wire op_B_sel;            // ALU����ѡ���ź�
    wire [3:0] alu_opcode;    // ALU������
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
        .current_pc_o(current_pc)     // ����auipc
        // .pc_o        (pc_o)            // ����
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
