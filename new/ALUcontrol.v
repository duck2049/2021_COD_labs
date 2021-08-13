`timescale 1ns / 1ps
module ALUcontrol(
input [1:0] ALUop,
input [3:0] func,
output reg [2:0] ALU_f
    );
always@(*)
begin
    case(ALUop)
    2'b01://-
        ALU_f=3'b001;
    2'b10://+
        ALU_f=3'b000;
    2'b11:
    begin
        if(func[2:0]==3'b110)//OR
            ALU_f=3'b011;
        else//XOR,XORI
            ALU_f=3'b100;
        
    end
    default:
        ALU_f=3'b000;
    endcase
end
endmodule
