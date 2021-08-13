`timescale 1ns / 1ps
module Control(
input wire [6:0] opcode,
input wire [2:0] func,
output reg BEQ,
output reg BGE,
output reg BLT,
output reg jal,
output reg jalr,
output reg [1:0] RegScr,
output reg [1:0] ALUop,
output reg MemWrite,
output reg ALUScr,
output reg RegWrite,
output reg MemRead,
output reg [1:0] LeftShift
    );

always@(*)
begin 
    case(opcode)
    7'b1101111://JAL
    begin
        BEQ=1'b0;
        BGE=1'b0;
        BLT=1'b0;
        jal=1'b1;
        jalr=1'b0;
        RegScr=2'b10;
        ALUop=2'b00;
        MemWrite=1'b0;
        ALUScr=1'b0;
        RegWrite=1'b1;
        MemRead=1'b0;
        LeftShift=2'b00;
    end
    
    7'b1100011:
    begin
        if(func==3'b000)//BEQ
            begin
                BEQ=1'b1;
                BGE=1'b0;
                BLT=1'b0;
                jal=1'b0;
                jalr=1'b0;
                RegScr=2'b00;
                ALUop=2'b01;
                MemWrite=1'b0;
                ALUScr=1'b0;
                RegWrite=1'b0;
                MemRead=1'b0;
                LeftShift=2'b00;
            end
        if(func==3'b101)//BGE
            begin
                BEQ=1'b0;
                BGE=1'b1;
                BLT=1'b0;
                jal=1'b0;
                jalr=1'b0;
                RegScr=2'b00;
                ALUop=2'b01;
                MemWrite=1'b0;
                ALUScr=1'b0;
                RegWrite=1'b0;
                MemRead=1'b0;
                LeftShift=2'b00;
            end
        if(func==3'b100)//BLT
            begin
                BEQ=1'b0;
                BGE=1'b0;
                BLT=1'b1;
                jal=1'b0;
                jalr=1'b0;
                RegScr=2'b00;
                ALUop=2'b01;
                MemWrite=1'b0;
                ALUScr=1'b0;
                RegWrite=1'b0;
                MemRead=1'b0;
                LeftShift=2'b00;
            end
    end
    
    7'b0000011://LW
    begin
        BEQ=1'b0;
        BGE=1'b0;
        BLT=1'b0;
        jal=1'b0;
        jalr=1'b0;
        RegScr=2'b01;
        ALUop=2'b00;
        MemWrite=1'b0;
        ALUScr=1'b1;
        RegWrite=1'b1;
        MemRead=1'b1;
        LeftShift=2'b00;
    end
    
    7'b0100011://SW
    begin
        BEQ=1'b0;
        BGE=1'b0;
        BLT=1'b0;
        jal=1'b0;
        jalr=1'b0;
        RegScr=2'b00;
        ALUop=2'b00;
        MemWrite=1'b1;
        ALUScr=1'b1;
        RegWrite=1'b0;
        MemRead=1'b0;
        LeftShift=2'b00;
    end
    
    7'b0010011:
    begin
        if(func==3'b001)//SLLI
            begin
                BEQ=1'b0;
                BGE=1'b0;
                BLT=1'b0;
                jal=1'b0;
                jalr=1'b0;
                RegScr=2'b00;
                ALUop=2'b00;
                MemWrite=1'b0;
                ALUScr=1'b1;
                RegWrite=1'b1;
                MemRead=1'b0;
                LeftShift=2'b01;
            end
        if(func==3'b100)//XORI
            begin
                BEQ=1'b0;
                BGE=1'b0;
                BLT=1'b0;
                jal=1'b0;
                jalr=1'b0;
                RegScr=2'b00;
                ALUop=2'b11;
                MemWrite=1'b0;
                ALUScr=1'b1;
                RegWrite=1'b1;
                MemRead=1'b0;
                LeftShift=2'b00;
            end
        if(func==3'b000)//ADDI
            begin
                BEQ=1'b0;
                BGE=1'b0;
                BLT=1'b0;
                jal=1'b0;
                jalr=1'b0;
                RegScr=2'b00;
                ALUop=2'b10;
                MemWrite=1'b0;
                ALUScr=1'b1;
                RegWrite=1'b1;
                MemRead=1'b0;
                LeftShift=2'b00;
            end
    end

    7'b0110011:
    begin
        if(func==3'b000)//ADD
            begin
                
                BEQ=1'b0;
                BGE=1'b0;
                BLT=1'b0;
                jal=1'b0;
                jalr=1'b0;
                RegScr=2'b00;
                ALUop=2'b10;
                MemWrite=1'b0;
                ALUScr=1'b0;
                RegWrite=1'b1;
                MemRead=1'b0;
                LeftShift=2'b00;
    
            end 
        if(func==3'b100)//XOR
            begin
                BEQ=1'b0;
                BGE=1'b0;
                BLT=1'b0;
                jal=1'b0;
                jalr=1'b0;
                RegScr=2'b00;
                ALUop=2'b11;
                MemWrite=1'b0;
                ALUScr=1'b0;
                RegWrite=1'b1;
                MemRead=1'b0;
                LeftShift=2'b00;
            end
        if(func==3'b110)//OR
            begin
                BEQ=1'b0;
                BGE=1'b0;
                BLT=1'b0;
                jal=1'b0;
                jalr=1'b0;
                RegScr=2'b00;
                ALUop=2'b11;
                MemWrite=1'b0;
                ALUScr=1'b0;
                RegWrite=1'b1;
                MemRead=1'b0;
                LeftShift=2'b00;
            end
    end

    
    7'b0110111://LUI
    begin
        BEQ=1'b0;
        BGE=1'b0;
        BLT=1'b0;
        jal=1'b0;
        jalr=1'b0;
        RegScr=2'b00;
        ALUop=2'b00;
        MemWrite=1'b0;
        ALUScr=1'b0;
        RegWrite=1'b1;
        MemRead=1'b0;
        LeftShift=2'b10;
    end

    7'b1100111://JALR
    begin
        BEQ=1'b0;
        BGE=1'b0;
        BLT=1'b0;
        jal=1'b0;
        jalr=1'b1;
        RegScr=2'b10;
        ALUop=2'b00;
        MemWrite=1'b0;
        ALUScr=1'b0;
        RegWrite=1'b1;
        MemRead=1'b0;
        LeftShift=2'b00;
    end

    default:
    begin
        BEQ=1'b0;
        BGE=1'b0;
        BLT=1'b0;
        jal=1'b0;
        jalr=1'b0;
        RegScr=2'b00;
        ALUop=2'b10;
        MemWrite=1'b0;
        ALUScr=1'b0;
        RegWrite=1'b0; 
        MemRead=1'b0;
        LeftShift=2'b00;
    end
    endcase
end

endmodule
