`timescale 1ns / 1ps
module CPU(
  input clk, 
  input rst,

  //IO_BUS
  output [7:0] io_addr,      //led??seg????
  output [31:0] io_dout,     //???led??seg??????
  output io_we,                 //???led??seg?????????????
  input [31:0] io_din,        //????sw??????????

  //Debug_BUS
  input [7:0] m_rf_addr,   //?????(MEM)????????(RF)??????????
  output [31:0] rf_data,    //??RF?????????
  output [31:0] m_data,    //??MEM?????????

  //PC/IF/ID ??????????
  output reg [31:0] pc,         
  output [31:0] pcd,
  output [31:0] ir,
  output [31:0] pcin,

  //ID/EX ??????????
  output [31:0] pce,        
  output [31:0] a,          
  output [31:0] b,
  output [31:0] imm,
  output [4:0] rd,
  output [31:0] ctrl,

  //EX/MEM ??????????
  output [31:0] y,
  output [31:0] bm,
  output [4:0] rdm,
  output [31:0] ctrlm,

  //MEM/WB ??????????
  output [31:0] yw,
  output [31:0] mdr,
  output [4:0] rdw,
  output [31:0] ctrlw
    );
    


//wires
wire [31:0] RD1_IDEX_wire,RD2_IDEX_wire,imm_IDEX_wire,
    ALU_result_EXMEM_wire,ins_IFID_wire,RD2_EXMEM_wire,MDR_MEMWB_wire;
reg [31:0] ALU_B_EXMEM_wire;
wire [1:0] ALUop_IDEX_wire,RegScr_IDEX_wire;
wire BEQ_IDEX_wire,jal_IDEX_wire,MemWrite_IDEX_wire,ALUScr_IDEX_wire,
    RegWrite_IDEX_wire,MemRead_IDEX_wire,ALU_Z_EXMEM_wire;
wire BGE_IDEX_wire,BLT_IDEX_wire;
wire [1:0] LeftShift_IDEX_wire;
wire jalr_IDEX_wire;


//////////////////////////////IF/ID
reg [31:0] pc_IFID;
reg [31:0] pc_add4_IFID;
reg [31:0] ins_IFID;

wire flush_IFID;
wire enable_IFID;


//////////////////////////////ID/EX
////register
reg [31:0] pc_add4_IDEX;
//reg [31:0] pc_cur_IDEX;
reg [31:0] pc_IDEX;
reg [31:0] imm_IDEX;
reg [31:0] RD1_IDEX,RD2_IDEX;
reg [31:0] ins_IDEX;

////control
reg BEQ_IDEX;
reg BGE_IDEX;
reg BLT_IDEX;
reg jal_IDEX;
reg jalr_IDEX;
reg MemWrite_IDEX;
reg ALUScr_IDEX;
reg RegWrite_IDEX;
reg MemRead_IDEX;            //??
reg [1:0] RegScr_IDEX;
reg [1:0] ALUop_IDEX;
reg [1:0] LeftShift_IDEX;

////hazard
wire flush_IDEX;
wire enable_IDEX;

////forward
reg [4:0] RS1_IDEX,RS2_IDEX;
reg [4:0] RD_IDEX;

////EX
wire [2:0] ALU_f;
reg [31:0] ALU_A_IDEX;

///////////////////////////////////EX/MEM
////register
reg [31:0] pc_add4_EXMEM;
reg [31:0] RD2_EXMEM;
// [31:0] pc_cur_EXMEM;
reg [31:0] pc_EXMEM;
reg [31:0] ALU_result_EXMEM;
reg [31:0] ALU_B_EXMEM;

reg ALU_Z_EXMEM;

////control
reg MemWrite_EXMEM;
reg RegWrite_EXMEM;
reg MemRead_EXMEM;            //??
reg [1:0] RegScr_EXMEM;
reg BEQ_EXMEM;
reg jal_EXMEM;
reg jalr_EXMEM;

////
reg [4:0] RD_EXMEM; 
wire enable_EXMEM;
//////////////////////////////////////MEM/WB
////register
reg [31:0] pc_add4_MEMWB;
reg [31:0] ALU_result_MEMWB;
reg [31:0] MDR_MEMWB;
reg [31:0] io_din_MEMWB;

////control
reg RegWrite_MEMWB;
reg [1:0] RegScr_MEMWB;

////
reg [4:0] RD_MEMWB;

reg [31:0] RF_WriteData;
wire enable_MEMWB;

//////////////////////////////////////////////////////////


//CONTROL
Control Control(
.opcode(ins_IFID[6:0]),
.func(ins_IFID[14:12]),
.BEQ(BEQ_IDEX_wire),
.BGE(BGE_IDEX_wire),
.BLT(BLT_IDEX_wire),
.jal(jal_IDEX_wire),
.jalr(jalr_IDEX_wire),
.RegScr(RegScr_IDEX_wire),
.ALUop(ALUop_IDEX_wire),
.MemWrite(MemWrite_IDEX_wire),
.ALUScr(ALUScr_IDEX_wire),
.RegWrite(RegWrite_IDEX_wire),
.MemRead(MemRead_IDEX_wire),
.LeftShift(LeftShift_IDEX_wire)
);

//RF
RF RF(
.clk(clk),
.ra0(ins_IFID[19:15]),
.ra1(ins_IFID[24:20]),
.rd0(RD1_IDEX_wire),
.rd1(RD2_IDEX_wire),
.ra_test(m_rf_addr[4:0]),
.rd_test(rf_data),
.we(RegWrite_MEMWB),
.wa(RD_MEMWB),
.wd(RF_WriteData)
);

//IMM
Imm Imm(
.ins(ins_IFID),
.immediate(imm_IDEX_wire)
);

//ALU CONTROL
ALUcontrol ALUcontrol(
.ALUop(ALUop_IDEX),
.func({ins_IDEX[31],ins_IDEX[14:12]}),
.ALU_f(ALU_f)
);


reg [31:0] ALU_B;

//ALU
ALU ALU(
.a(ALU_A_IDEX),
.b(ALU_B),
.f(ALU_f),
.y(ALU_result_EXMEM_wire),
.z(ALU_Z_EXMEM_wire)
);

//INS MEM
ins_mem ins_mem(
.a(pc[9:2]),
.spo(ins_IFID_wire)
);

assign io_addr=ALU_result_EXMEM;
assign io_dout=ALU_B_EXMEM;
assign io_we=MemWrite_EXMEM & (ALU_result_EXMEM[10]);

wire miss;
// assign enable_IFID=~miss_edge;
// assign enable_IDEX=~miss_edge;
// assign enable_EXMEM=~miss_edge;
// assign enable_MEMWB=~miss_edge;

Cache Cache(
.clk(clk),
.rst(rst),
.addr(ALU_result_EXMEM[12:2]),
.data(ALU_B_EXMEM),
.we(MemWrite_EXMEM),
.read(RegScr_EXMEM==2'b01),
.data_out(MDR_MEMWB_wire),
.miss(miss)
);

// //DATA MEM
// data_mem data_mem(
// .a(ALU_result_EXMEM[14:2]),
// .d(ALU_B_EXMEM),
// .dpra(m_rf_addr),
// .clk(clk),
// .we(MemWrite_EXMEM),
// .spo(MDR_MEMWB_wire),       
// .dpo(m_data)
// );

//FORWARD
wire [1:0] mux_a,mux_b;
Forwarding Forwarding(
.EX_MEM_RegWrite(RegWrite_EXMEM),
.MEM_WB_RegWrite(RegWrite_MEMWB),
.ID_EX_RS1(RS1_IDEX),
.ID_EX_RS2(RS2_IDEX),
.EX_MEM_RD(RD_EXMEM),
.MEM_WB_RD(RD_MEMWB),
.forwardA(mux_a),
.forwardB(mux_b)
);

//HAZARD
Hazard Hazard(
.ID_EX_RD(RD_IDEX),
.IF_ID_RS1(ins_IFID[19:15]),
.IF_ID_RS2(ins_IFID[24:20]),
.ID_EX_MemRead(MemRead_IDEX),
// .pc_jump((ALU_Z_EXMEM_wire & BEQ_IDEX)|(~alu_result[31] & BGE_IDEX) | (alu_result[31] & BLT_IDEX ) | jal_IDEX),
.pc_jump((ALU_Z_EXMEM_wire & BEQ_IDEX)|(~ALU_result_EXMEM_wire[31] & BGE_IDEX) | (ALU_result_EXMEM_wire[31] & BLT_IDEX ) | jal_IDEX | jalr_IDEX),
.miss(miss),
.flush_IF(flush_IFID),
.enable_IF(enable_IFID),
.flush_ID(flush_IDEX),
.enable_ID(enable_IDEX),
.enable_EXMEM(enable_EXMEM),
.enable_MEMWB(enable_MEMWB)

);

/////////////////////////////////////////////////////////////////////
//PC
wire [1:0] PCSrc; 
reg [31:0] pc_next;

//assign PCSrc = (ALU_Z_EXMEM_wire & BEQ_IDEX) | jal_IDEX;//??EX?????????????????
assign PCSrc[0] = (ALU_Z_EXMEM_wire & BEQ_IDEX)|(~ALU_result_EXMEM_wire[31] & BGE_IDEX) | (ALU_result_EXMEM_wire[31] & BLT_IDEX ) | jal_IDEX;
assign PCSrc[1]=jalr_IDEX;

always@(*)
begin
    if( PCSrc[1]==1'b1)//JALR
    begin
        pc_next<=ALU_A_IDEX+imm_IDEX;
        
    end
    else if(PCSrc[0]==1'b1)//BRANCH,JAL
    begin
        pc_next<=pc_IDEX+imm_IDEX;
    end
    else 
    begin
        pc_next<=pc+4;
    end
end

///////////////////////////////////////IF
always@(posedge clk,posedge rst)
begin
    if(rst==1'b1)
    begin
        pc<=32'b0;
        //pc_next<=32'b0;
        pc_IFID<=32'b0;
        pc_add4_IFID<=32'b0;
        ins_IFID<=32'h00000013;
        
    end
    else
    begin
        if(enable_IFID)//??????stall??????????
        begin
            pc<=pc_next;
            if(flush_IFID)//hazard
            begin
                pc_IFID<=32'b0;
                pc_add4_IFID<=32'b0; 
                ins_IFID<=32'h00000013;
            end
            else
            begin
                pc_IFID<=pc;
                pc_add4_IFID<=pc+32'd4;
                ins_IFID<=ins_IFID_wire;
            end
        end
    end
end

///////////////////////////////////////ID
always@(posedge clk,posedge rst)
begin
    if(rst==1'b1)
    begin
        pc_IDEX<=0;
        pc_add4_IDEX<=0;
        imm_IDEX<=0;
        RD1_IDEX<=0;
        RD2_IDEX<=0;
        ins_IDEX<=0;
        
        BEQ_IDEX<=0;
        jal_IDEX<=0;
        MemWrite_IDEX<=0;
        ALUScr_IDEX<=0;
        RegWrite_IDEX<=0;
        MemRead_IDEX<=0;            //??
        RegScr_IDEX<=0;
        ALUop_IDEX<=0;
        BGE_IDEX<=0;
        BLT_IDEX<=0;
        jalr_IDEX<=0;
        LeftShift_IDEX<=0;

        RS1_IDEX<=0;
        RS2_IDEX<=0;
        RD_IDEX<=0;
     end
     
     else
     begin
        if(enable_IDEX)
        begin
              if(flush_IDEX)
              begin
                pc_IDEX<=0;
                pc_add4_IDEX<=0;
                imm_IDEX<=0;
                RD1_IDEX<=0;
                RD2_IDEX<=0;
                ins_IDEX<=0;
                
                BEQ_IDEX<=0;
                jal_IDEX<=0;
                MemWrite_IDEX<=0;
                ALUScr_IDEX<=0;
                RegWrite_IDEX<=0;
                MemRead_IDEX<=0;            //??
                RegScr_IDEX<=0;
                ALUop_IDEX<=0;
                BGE_IDEX<=0;
                BLT_IDEX<=0;
                jalr_IDEX<=0;
                LeftShift_IDEX<=0;

                RS1_IDEX<=0;
                RS2_IDEX<=0;
                RD_IDEX<=0;
            end
            
            else
            begin
                pc_IDEX<=pc_IFID;
                pc_add4_IDEX<=pc_add4_IFID;
                imm_IDEX<=imm_IDEX_wire;
                RD1_IDEX<=RD1_IDEX_wire;
                RD2_IDEX<=RD2_IDEX_wire;
                ins_IDEX<=ins_IFID;
                
                BEQ_IDEX<=BEQ_IDEX_wire;
                jal_IDEX<=jal_IDEX_wire;
                MemWrite_IDEX<=MemWrite_IDEX_wire;
                ALUScr_IDEX<= ALUScr_IDEX_wire;
                RegWrite_IDEX<=RegWrite_IDEX_wire;
                MemRead_IDEX<=MemRead_IDEX_wire;            //??
                RegScr_IDEX<=RegScr_IDEX_wire;
                ALUop_IDEX<=ALUop_IDEX_wire;
                BGE_IDEX<=BGE_IDEX_wire;
                BLT_IDEX<=BLT_IDEX_wire;
                jalr_IDEX<=jalr_IDEX_wire;
                LeftShift_IDEX<=LeftShift_IDEX_wire;


                RS1_IDEX<=ins_IFID[19:15];
                RS2_IDEX<=ins_IFID[24:20];

                RD_IDEX<=ins_IFID[11:7];
            end
        end
    end
end

///////////////////////////////////////EX
reg [31:0] ALU_B_NEW;
//muxA
always@(*)
begin
    case(mux_a)
    2'b00:ALU_A_IDEX=RD1_IDEX;
    2'b01:ALU_A_IDEX=(RegScr_EXMEM==2'b10)?pc_add4_EXMEM:ALU_result_EXMEM;//pc_add4_MEMWB
    2'b10:ALU_A_IDEX=RF_WriteData;
    default:ALU_A_IDEX=ALU_A_IDEX;
    endcase
end

//muxB
always@(*)
begin
    case(mux_b)
    2'b00:ALU_B_NEW=RD2_IDEX;
    2'b01:ALU_B_NEW=(RegScr_EXMEM==2'b10)?pc_add4_EXMEM:ALU_result_EXMEM;
    2'b10:ALU_B_NEW=RF_WriteData;
    default:ALU_B_NEW=ALU_B_NEW;
    endcase
end

//next mux
always@(*)
begin
    if(ALUScr_IDEX==1'b0) 
        ALU_B=ALU_B_NEW;
    else 
        ALU_B=imm_IDEX;
end

always@(posedge clk,posedge rst)
begin
    
    if(rst==1'b1)
    begin
        pc_add4_EXMEM<=0;
        pc_EXMEM<=0;
        ALU_result_EXMEM<=0;
        ALU_B_EXMEM<=0;
        ALU_Z_EXMEM<=0;
        
        MemWrite_EXMEM<=0;
        RegWrite_EXMEM<=0;
        MemRead_EXMEM<=0;            //??
        RegScr_EXMEM<=0;
        BEQ_EXMEM<=0;
        jal_EXMEM<=0;
    
        RD_EXMEM<=0; 
     end
     
     else
        if(enable_EXMEM)
        begin
            
            RD2_EXMEM<=RD2_IDEX;
            pc_add4_EXMEM<=pc_add4_IDEX;
            pc_EXMEM<=pc_IDEX;
            //mux for leftshift(after alu)
            case(LeftShift_IDEX)
            2'b00:
                ALU_result_EXMEM<=ALU_result_EXMEM_wire;
            2'b01:
                ALU_result_EXMEM<=ALU_A_IDEX<<imm_IDEX[4:0];
            2'b10:
                ALU_result_EXMEM<=imm_IDEX;
            default:
                ALU_result_EXMEM<=ALU_result_EXMEM_wire;
            endcase

            // ALU_result_EXMEM<=ALU_result_EXMEM_wire;
            ALU_B_EXMEM<=ALU_B_NEW;
            ALU_Z_EXMEM<=ALU_Z_EXMEM;
            
            MemWrite_EXMEM<=MemWrite_IDEX;
            RegWrite_EXMEM<= RegWrite_IDEX;
            MemRead_EXMEM<=MemRead_IDEX;            //??
            RegScr_EXMEM<=RegScr_IDEX;
            BEQ_EXMEM<=BEQ_IDEX;
            jal_EXMEM<=jal_IDEX;
        
            RD_EXMEM<=RD_IDEX;  
        end
    
end

//mux for leftshift(after alu)
// always@(*)
// begin
//     case(LeftShift_IDEX)
//     2'b00:
//         ALU_result_EXMEM=ALU_result_EXMEM_wire;
//     2'b01:
//         ALU_result_EXMEM=ALU_A_IDEX<<imm_IDEX[4:0];
//     2'b10:
//         ALU_result_EXMEM=imm_IDEX;
//     default:
//         ALU_result_EXMEM=ALU_result_EXMEM_wire;
//     endcase
// end
//////////////////////////////////////MEM
always@(posedge clk,posedge rst)
begin
    
    if(rst==1'b1)
    begin
        ALU_result_MEMWB<=0;
        MDR_MEMWB<=0;
        pc_add4_MEMWB<=0;
        RegWrite_MEMWB<=0;
        RegScr_MEMWB<=0;
        io_din_MEMWB<=0;
        RD_MEMWB<=0;
    end
    
    else
        if(enable_MEMWB)
        begin
            ALU_result_MEMWB<=ALU_result_EXMEM;
            MDR_MEMWB<=MDR_MEMWB_wire;
            pc_add4_MEMWB<=pc_add4_EXMEM;
            RegWrite_MEMWB<=RegWrite_EXMEM;
            RegScr_MEMWB<= RegScr_EXMEM;
            io_din_MEMWB<=io_din;
            RD_MEMWB<=RD_EXMEM;
        end

    
end
 
 
 ////////////////////////////////////WB
 //mux
 always@(*)
begin
    case(RegScr_MEMWB)
    2'b00:
        RF_WriteData=ALU_result_MEMWB;
    2'b01:
        RF_WriteData=MDR_MEMWB;
    2'b10:
        RF_WriteData=pc_add4_MEMWB;
    default:
        RF_WriteData=0;
    endcase
end

/////////////////////////////////////////////////////////////
assign pcd=pc_IFID;
assign ir=ins_IFID;
assign pcin=pc_next;

assign pce=pc_IDEX;
assign a=RD1_IDEX; 
assign b=RD2_IDEX;
assign imm=imm_IDEX;
assign rd=RD_IDEX;
assign ctrl={enable_IFID,enable_IDEX,flush_IFID,flush_IDEX,2'b00,mux_a,2'b00,mux_b,1'b0,RegWrite_IDEX,RegScr_IDEX,2'b00,MemRead_IDEX,MemWrite_IDEX,2'b00,jal_IDEX,BEQ_IDEX,2'b00,1'b0,ALUScr_IDEX,ALU_f}; 
  
assign y=ALU_result_EXMEM;
assign bm=ALU_B_EXMEM;
assign rdm=RD_EXMEM;
assign ctrlm={enable_IFID,enable_IDEX,flush_IFID,flush_IDEX,2'b00,mux_a,2'b00,mux_b,1'b0,RegWrite_EXMEM,RegScr_EXMEM,2'b00,MemRead_EXMEM,MemWrite_EXMEM,2'b00,jal_EXMEM,BEQ_EXMEM,2'b00,1'b0,1'b1,ALU_f};

assign yw=ALU_result_MEMWB;
assign mdr=MDR_MEMWB;
assign rdw=RD_MEMWB;
assign ctrlw={enable_IFID,enable_IDEX,flush_IFID,flush_IDEX,2'b00,mux_a,2'b00,mux_b,1'b0,RegWrite_MEMWB,RegScr_MEMWB,2'b00,1'b0,1'b0,2'b00,1'b0,1'b0,2'b00,1'b0,1'b0,ALU_f};
endmodule
