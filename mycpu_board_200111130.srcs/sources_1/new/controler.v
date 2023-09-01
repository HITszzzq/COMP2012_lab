`timescale 1ns / 1ps
module controler #(
    parameter OPCODE_JAL   = 7'b1101111,
    parameter OPCODE_JALR  = 7'b1100111,
    parameter OPCODE_LOAD  = 7'b0000011,
    parameter OPCODE_B     = 7'b1100011,
    parameter OPCODE_R     = 7'b0110011,
    parameter OPCODE_I     = 7'b0010011,
    parameter OPCODE_S     = 7'b0100011,
    parameter OPCODE_AUIPC = 7'b0010111,
    parameter OPCODE_LUI   = 7'b0110111,
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
    input             reset_i,
    input      [6:0]  opcode_i,
    input      [6:0]  function7_i,
    input      [2:0]  function3_i,
    output reg [1:0]  wd_sel_o,      // Regfileд������ѡ���ź�
    output reg [1:0]  pc_sel_o,      // npcѡ���ź�
    output reg        branch_o,      // B��ָ��������ת�ź� 
    output reg [2:0]  imm_sel_o,     // ������ѡ���ź�     
    output reg        regfile_we_o,  // Regfileд�����ź�
    output reg        mem_we_o,      // Memд�����ź�
    output reg        op_A_sel_o,    // ALU����ѡ���ź�
    output reg        op_B_sel_o,    // ALU����ѡ���ź�   
    output reg [3:0]  alu_opcode_o   // alu������
    );
    // wd_sel��ֵ����
    always @(*) begin
        if(reset_i == 1'b1)
            wd_sel_o = 2'b11;
        else begin
            case(opcode_i)
                // jal,jalr
                OPCODE_JAL,OPCODE_JALR:
                    wd_sel_o = 2'b00;
                // lw
                OPCODE_LOAD:
                    wd_sel_o = 2'b10;
                // ����
                default:
                    wd_sel_o = 2'b01;
            endcase
        end
    end

    // pc_sel��ֵ����
    always @(*) begin
        if(reset_i == 1'b1)
            pc_sel_o = 2'b00;
        else begin
            case(opcode_i)
                // B��ָ��
                OPCODE_B:
                    pc_sel_o = 2'b01;
                // jalr
                OPCODE_JALR:
                    pc_sel_o = 2'b11;
                // jal
                OPCODE_JAL:
                    pc_sel_o = 2'b10;
                default:
                    pc_sel_o = 2'b00;
            endcase
        end
    end

    // branch��ֵ����
    always @(*) begin
        if(reset_i == 1'b1)
            branch_o = 1'b0;
        else begin
            case(opcode_i)
                // B��ָ��
                OPCODE_B:
                    branch_o = 1'b1;
                default:
                    branch_o = 1'b0;
            endcase
        end
    end

    // imm_sel��ֵ����
    always @(*) begin
        if(reset_i == 1'b1)
            imm_sel_o = 3'b000;
        else begin
            case(opcode_i)
                // R��ָ��
                OPCODE_R:
                    imm_sel_o = 3'b000;
                // I��ָ����������������λ����
                OPCODE_I: begin
                    case(function3_i)
                        // ��λ����
                        3'b001, 3'b101:
                            imm_sel_o = 3'b010;
                        default:
                            imm_sel_o = 3'b001;
                    endcase
                end
                // lw,jalr
                OPCODE_LOAD, OPCODE_JALR:
                    imm_sel_o = 3'b001;
                // S��
                OPCODE_S:
                    imm_sel_o = 3'b011;
                // B��
                OPCODE_B:
                    imm_sel_o = 3'b100;
                OPCODE_AUIPC, OPCODE_LUI:
                    imm_sel_o = 3'b101;
                OPCODE_JAL:
                    imm_sel_o = 3'b110;
                default:;
            endcase
        end
    end

    // regfile_we_o����
    always @(*) begin
        if(reset_i == 1'b1)
            regfile_we_o = 1'b0;
        else begin
            case(opcode_i)
                // R�ͣ�I�ͣ�U�ͣ�J����Ҫд�Ĵ��� 
                OPCODE_R,
                OPCODE_I, 
                OPCODE_LOAD, 
                OPCODE_JAL, 
                OPCODE_LUI,
                OPCODE_AUIPC, 
                OPCODE_JALR:
                    regfile_we_o = 1'b1;
                default:
                    regfile_we_o = 1'b0;
            endcase
        end
    end

    // mem_we_o����
    always @(*) begin
        if(reset_i == 1'b1)
            mem_we_o = 1'b0;
        else begin
            case(opcode_i)
                // S��ָ��
                OPCODE_S:
                    mem_we_o = 1'b1;
                default:
                    mem_we_o = 1'b0;
            endcase
        end
    end

    // op_A_sel_o����
    always @(*) begin
        case(opcode_i)
            // R�ͣ�I�ͣ�S��, B��
            OPCODE_R,
            OPCODE_I,
            OPCODE_LOAD,
            OPCODE_JAL,
            OPCODE_S,
            OPCODE_B:
                op_A_sel_o = 1'b1;
            default:
                op_A_sel_o = 1'b0;
        endcase
    end

    // op_B_sel_o
    always @(*) begin
        case(opcode_i)
            // R�ͣ�B��
            OPCODE_R,
            OPCODE_B:
                op_B_sel_o = 1'b1;
            default:
                op_B_sel_o = 1'b0;
        endcase
    end

    // alu_opcode_o����
    always @(*) begin
        case(opcode_i)
            OPCODE_R: begin
                case(function3_i)
                    3'b000: begin
                        if(function7_i == 7'b0100000) alu_opcode_o = SUB;
                        else alu_opcode_o = ADD;
                    end
                    3'b111: alu_opcode_o = AND;
                    3'b110: alu_opcode_o = OR;
                    3'b100: alu_opcode_o = XOR;
                    3'b001: alu_opcode_o = SLL;
                    3'b101: begin
                        if(function7_i == 7'b0100000) alu_opcode_o = SRA;
                        else alu_opcode_o = SRL;
                    end
                    default:;
                endcase
            end
            OPCODE_I: begin
                case(function3_i)
                    3'b000: alu_opcode_o = ADD;
                    3'b111: alu_opcode_o = AND;
                    3'b110: alu_opcode_o = OR;
                    3'b100: alu_opcode_o = XOR;
                    3'b001: alu_opcode_o = SLL;
                    3'b101: begin
                        if(function7_i == 7'b0100000) alu_opcode_o = SRA;
                        else alu_opcode_o = SRL;
                    end
                    default:;
                endcase
            end
            OPCODE_LOAD,
            OPCODE_JAL,
            OPCODE_S,
            OPCODE_AUIPC,
            OPCODE_JALR: alu_opcode_o = ADD;
            OPCODE_LUI:  alu_opcode_o = LUI;
            OPCODE_B: begin
                case(function3_i)
                    3'b000: alu_opcode_o = BEQ;
                    3'b001: alu_opcode_o = BNE;
                    3'b100: alu_opcode_o = BLT;
                    3'b101: alu_opcode_o = BGE;
                    default:;
                endcase
            end
            default:;
        endcase
    end
    
endmodule
