`timescale 1ns / 1ps
//16 lines
//each line 1 word
//4 bits of index
//7 bits of tag
//for addr:addr[3:0]=line number,addr[10:4]=tag
module Cache (
input clk,
input rst,
input wire [10:0] addr,//depth=2048=2^11
input wire [31:0] data,//data width=32
input we,
input read,//add this wire to know which instruction really reads the DM 
output [31:0] data_out,
output miss
    );

reg [15:0] valid;
reg [31:0] cache_mem[0:15];
reg [6:0] tags[0:15];

wire [31:0] mem_data_out;

//read when hit
assign data_out=cache_mem[addr[3:0]];

reg [3:0] status;
assign miss=(read==1'b1) && !((valid[addr[3:0]]==1'b1) && (tags[addr[3:0]]==addr[10:4]));
always@(posedge clk,posedge rst)
begin
    if(rst==1'b1)
    begin
        valid<=16'b0000000000000000;
        status<=4'b0;
    end
    else //read when miss
    begin
        if(miss==1'b1)
        begin
            if(status==4'b0)
            begin
                status<=4'd12;
            end
            else
            begin
                status<=status-4'd1; //counting
                if(status==4'd1) //counts to the last number,read from DM
                begin
                    cache_mem[addr[3:0]]<=mem_data_out;
                    valid[addr[3:0]]<=1'b1;
                    tags[addr[3:0]]<=addr[10:4];
                end
            end 
        end
        //write when hit,need to change cache
        if((we==1'b1) && (tags[addr[3:0]]==addr[10:4]) && (valid[addr[3:0]]==1))
            cache_mem[addr[3:0]]<=data;
    end
end


data_mem data_mem(
.a(addr),
.d(data),
.dpra(),
.clk(clk),
.we(we),
.spo(mem_data_out),       
.dpo()
);
endmodule
