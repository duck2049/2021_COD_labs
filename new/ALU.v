`timescale 1ns / 1ps

module ALU(
    
    input [31:0] a,b, //两操作数
    input [2:0] f,         //操作功能
    output reg [31:0] y,  //运算结果
    output reg z               //0标志
    );

always@(*)
begin
    case(f)
    3'b000://+
    begin
        y=a+b;
        if(y==0) z=1'b1;
        else z=1'b0;
    end
    
    3'b001://-
    begin
        y=a-b;
        if(y==0) z=1'b1;
        else z=1'b0;
    end
    
    3'b010://and
    begin
        y=a&b;
        if(y==0) z=1'b1;
        else z=1'b0;
    end
    
    3'b011://or
    begin 
        y=a|b;
        if(y==0) z=1'b1;
        else z=1'b0;
    end
    
    3'b100://xor
    begin 
        y=a^b;
        if(y==0) z=1'b1;
        else z=1'b0;
    end
    
    default:
    begin
        y=0;
        z=1'b0;
    end
    endcase
end 
endmodule
