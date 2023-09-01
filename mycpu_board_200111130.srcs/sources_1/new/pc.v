`timescale 1ns / 1ps
module pc #(
    parameter INIT_PC = 32'b0                 // ��0ΪCPU��λ�������ָ���Ӧ��ַ
)
(
    input       [31:0] npc_i,
    input              clk_i,
    input              reset_i,
    output reg [31:0] pc_o
);
    reg first_time;                            // ��resetʧЧ�ĵ�������ʱ�䲻��,�޷����һ��ָ��ͽ���һ��ָ���ִ��ʱ���Ƴٵ���һ��ʱ�������ص���
    always @(posedge clk_i or posedge reset_i) begin
        if(reset_i) begin
            pc_o <= INIT_PC;
            first_time <= 1'b0;
        end
        else begin
            first_time <= 1'b1;
            if(first_time == 1'b0)
                pc_o <= INIT_PC;
            else
                pc_o <= npc_i;
        end
    end
endmodule
