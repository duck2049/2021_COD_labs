`timescale 1ns / 1ps
module IO_TOP(
    input wire[7:0] sw,
    output wire[7:0] led,
    output wire[2:0] an,
    output wire[3:0] seg,
    input wire button,
    input wire clk
    );
    wire clk_cpu;
    wire io_we; 
    wire [7:0] io_addr;
    wire [31:0] io_dout;                
    wire[31:0] io_din;         
  //Debug_BUS
    wire[7:0] m_rf_addr;   
    wire[31:0] rf_data;    
    wire[31:0] m_data;   
    wire[31:0] pc;  
    
    wire [31:0] pcin, pcd, pce;
    wire [31:0] ir, imm, mdr;
    wire [31:0] a, b, y, bm, yw; 
    wire [4:0]  rd, rdm, rdw;
    wire [31:0] ctrl, ctrlm, ctrlw;    
    
    
    PDU PUD(.clk(clk),.rst(sw[7]),.run(sw[6]),.step(button),.clk_cpu(clk_cpu),
                .valid(sw[5]),.in(sw[4:0]),.check(led[6:5]),.out0(led[4:0]),.an(an),.seg(seg),
                .ready(led[7]),.io_addr(io_addr),.io_dout(io_dout),.io_we(io_we),.io_din(io_din),
                .m_rf_addr(m_rf_addr),.rf_data(rf_data),.m_data(m_data),.pc(pc),
                .pcin(pcin), .pcd(pcd), .pce(pce),
                .ir(ir), .imm(imm), .mdr(mdr),
                .a(a), .b(b), .y(y), .bm(bm), .yw(yw), 
                .rd(rd), .rdm(rdm), .rdw(rdw),
                .ctrl(ctrl), .ctrlm(ctrlm), .ctrlw(ctrlw)  
                );
    
    
    CPU CPU(.clk(clk_cpu),.rst(sw[7]),.io_addr(io_addr),.io_dout(io_dout),
                .io_we(io_we),.io_din(io_din),.m_rf_addr(m_rf_addr),.rf_data(rf_data),.m_data(m_data),.pc(pc),
                .pcin(pcin), .pcd(pcd), .pce(pce),
                .ir(ir), .imm(imm), .mdr(mdr),
                .a(a), .b(b), .y(y), .bm(bm), .yw(yw), 
                .rd(rd), .rdm(rdm), .rdw(rdw),
                .ctrl(ctrl), .ctrlm(ctrlm), .ctrlw(ctrlw)  
                );
endmodule
