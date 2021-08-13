`timescale 1ns / 1ps
//32个寄存器，且每个数据32位
module RF(
input clk,
input [4:0] ra0,                        //读端口0地址
output [31:0] rd0,                 //读端口0数据
input [4:0] ra1,                        //读端口1地址
output [31:0] rd1,                 //读端口1数据
input [4:0] ra_test,                    //读测试端口地址
output [31:0] rd_test,             //写测试端口数据
input [4:0] wa,                         //写端口地址
input we,                               //写使能，高电平有效
input [31:0] wd                    //写端口数据
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
