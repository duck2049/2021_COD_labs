`timescale 1ns / 1ps
module Forwarding(
//control
input EX_MEM_RegWrite,
input MEM_WB_RegWrite,

//registers
input [4:0] ID_EX_RS1,
input [4:0] ID_EX_RS2,
input [4:0] EX_MEM_RD,
input [4:0] MEM_WB_RD,

//output,control mux
output [1:0] forwardA,
output [1:0] forwardB
    );
    
      assign forwardA= EX_MEM_RegWrite&& (ID_EX_RS1 !=0) &&(EX_MEM_RD == ID_EX_RS1) ? 2'b01 : MEM_WB_RegWrite 
      && (ID_EX_RS1 !=0)                //����
      && (MEM_WB_RD == ID_EX_RS1)  ?2'b10:2'b0;
    
    
    assign forwardB= EX_MEM_RegWrite&& (ID_EX_RS2 !=0) &&(EX_MEM_RD == ID_EX_RS2) ? 2'b01 : MEM_WB_RegWrite 
      && (ID_EX_RS2 !=0)                //����
      && (MEM_WB_RD == ID_EX_RS2)  ?2'b10:2'b0;
    
//always@(*)
//begin 
    //EX
//      if(EX_MEM_RegWrite              //ֻ��д��ʱ��forward
//      && (MEM_WB_RD !=0)                //������
//      && (EX_MEM_RD == ID_EX_RS1))     //������ͻ
//    forwardA=2'b10;
//  else if(MEM_WB_RegWrite                //д��ʱforward
//      && (MEM_WB_RD !=0)                //����
//      && !(EX_MEM_RegWrite && (EX_MEM_RD == ID_EX_RS1) && (MEM_WB_RD !=0))  //�ͽ�ԭ��
//      && (MEM_WB_RD == ID_EX_RS1)       //������ͻ
//      ) 
//    forwardA=2'b01;
//  else
//    forwardA=2'b0;
  
//    if (EX_MEM_RegWrite
//        && (MEM_WB_RD !=0)
//        && (EX_MEM_RD == ID_EX_RS2))
//      forwardB=2'b10;
//    else  if(MEM_WB_RegWrite 
//        && (MEM_WB_RD !=0)
//        && !(EX_MEM_RegWrite && (EX_MEM_RD == ID_EX_RS2) && (MEM_WB_RD !=0))
//        && (MEM_WB_RD == ID_EX_RS2)) 
//      forwardB=2'b01;
//    else 
//      forwardB=2'b0;
    
    
  
    
    
    
//  if(EX_MEM_RegWrite              //ֻ��д��ʱ��forward
//      && (ID_EX_RS1 !=0)                //������
//      && (EX_MEM_RD == ID_EX_RS1))     //������ͻ
//    forwardA=2'b01;
//  else if(MEM_WB_RegWrite                //д��ʱforward
//      && (ID_EX_RS1 !=0)                //����
//      && (MEM_WB_RD == ID_EX_RS1)       //������ͻ
//      ) 
//    forwardA=2'b10;
//  else
//    forwardA=2'b0;
  
//    if (EX_MEM_RegWrite
//        && (ID_EX_RS2 !=0)
//        && (EX_MEM_RD == ID_EX_RS2))
//      forwardB=2'b01;
//    else  if(MEM_WB_RegWrite 
//        && (ID_EX_RS2 !=0)
//        && (MEM_WB_RD == ID_EX_RS2)) 
//      forwardB=2'b10;
//    else 
//      forwardB=2'b0;
  
    //MEM
  
  

  
//end  
endmodule


