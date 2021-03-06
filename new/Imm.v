`timescale 1ns / 1ps
module Imm(
input wire [31:0] ins,
output reg [31:0] immediate
    );
always@(*)
begin
    case(ins[6:0])
        7'b1101111://JAL
                immediate={((ins[31]==1)?11'b111_1111_1111:11'b000_0000_0000),ins[31],ins[19:12],ins[20],ins[30:21],1'b0};
        7'b1100011://BEQ，BGE,BLT
                immediate={((ins[31]==1)?19'b111_1111_1111_1111_1111:19'b000_0000_0000_0000_0000),ins[31],ins[7],ins[30:25],ins[11:8],1'b0};
        7'b0000011://LW
                immediate={((ins[31]==1)?20'b1111_1111_1111_1111_1111:20'b0000_0000_0000_0000_0000),ins[31:20]};
        7'b0100011://SW
                immediate={((ins[31]==1)?20'b1111_1111_1111_1111_1111:20'b0000_0000_0000_0000_0000),ins[31:25],ins[11:7]};
        7'b0010011://ADDI,XORI,SLLI(只有[25:20]，即[5:0]有效，其余为0)
                immediate={((ins[31]==1)?20'b1111_1111_1111_1111_1111:20'b0000_0000_0000_0000_0000),ins[31:20]};
        7'b0110011://ADD,XOR,OR
                immediate=32'b0;
        7'b0110111://LUI(已经是左移后的结果了)
                immediate={ins[31:12],12'b0000_0000_0000};
        7'b1100111://JALR
                immediate={((ins[31]==1)?20'b1111_1111_1111_1111_1111:20'b0000_0000_0000_0000_0000),ins[31:20]};
        default:
                immediate=32'b0; 
        endcase
end  
endmodule
