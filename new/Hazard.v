`timescale 1ns / 1ps
module Hazard(

input [4:0] ID_EX_RD,
input [4:0] IF_ID_RS1,
input [4:0] IF_ID_RS2,

input ID_EX_MemRead,
input pc_jump,              //jal or branch ��֧�ɹ�
input miss,

output reg flush_IF,
output reg enable_IF,
output reg flush_ID,
output reg enable_ID,

output reg enable_EXMEM,
output reg enable_MEMWB
);
always@(*)
begin
    if(miss==1'b1)
    begin
        enable_IF=1'b0;
        enable_ID=1'b0;
        enable_EXMEM=1'b0;
        enable_MEMWB=1'b0;

        flush_IF=1'b0;
        flush_ID=1'b0;
    end
    else
    begin
        if(pc_jump)//��ת
        begin
            enable_IF=1'b1;
            flush_IF=1'b1;
            enable_ID=1'b1;
            flush_ID=1'b1;
            enable_EXMEM=1'b1;
            enable_MEMWB=1'b1;
        end
        
        else if( ID_EX_MemRead && ((ID_EX_RD==IF_ID_RS1) || (ID_EX_RD==IF_ID_RS2) ))//lw��aluָ���ͻ��stall
        begin
            enable_IF=1'b0;
            flush_IF=1'b0;
            enable_ID=1'b1;
            flush_ID=1'b1;
            enable_EXMEM=1'b1;
            enable_MEMWB=1'b1;
        end
        
        else
        begin
            enable_IF=1'b1;
            flush_IF=1'b0;
            enable_ID=1'b1;
            flush_ID=1'b0;
            enable_EXMEM=1'b1;
            enable_MEMWB=1'b1;
        end
    end
    
    
end
endmodule
