`timescale 1ns / 1ps
//32���Ĵ�������ÿ������32λ
module RF(
input clk,
input [4:0] ra0,                        //���˿�0��ַ
output [31:0] rd0,                 //���˿�0����
input [4:0] ra1,                        //���˿�1��ַ
output [31:0] rd1,                 //���˿�1����
input [4:0] ra_test,                    //�����Զ˿ڵ�ַ
output [31:0] rd_test,             //д���Զ˿�����
input [4:0] wa,                         //д�˿ڵ�ַ
input we,                               //дʹ�ܣ��ߵ�ƽ��Ч
input [31:0] wd                    //д�˿�����
    );
reg [31:0] regfile[0:(1<<5)-1];

assign rd0 = (ra0==5'b0)? 32'b0 : regfile[ra0];
assign rd1 = (ra1==5'b0)? 32'b0 : regfile[ra1];
assign rd_test=(ra_test==5'b0)? 32'b0 : regfile[ra_test];


always@(negedge clk) 
begin
    if (we)  regfile[wa]  <=  wd;
end


endmodule
