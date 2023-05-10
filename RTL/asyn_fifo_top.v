`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2022 08:53:13 PM
// Design Name: 
// Module Name: asyn_fifo_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module asyn_fifo_top#(
parameter 
 word_width=8
)(
    input r_clk,
    input w_clk,
     // read and write command
       input rd,
       input wr,
    input reset_n,
    input [word_width-1:0] data_in,
    output [word_width-1:0] data_out,
    output full,
    output empty
    );
    
    localparam addr_size =8;
    
        
      //declaration needed  
        wire [addr_size-1:0] addr_r,addr_w ;
        wire we_enable , rd_enable ;
        wire [addr_size:0] ptr_r;
        wire [addr_size:0] ptr_w;
    
      
      //initialize control unit   
    fifo_control_unit#(.addr_size(addr_size)) fifo_ctrl
    (.reset_n(reset_n),.w_clk(w_clk), .r_clk(r_clk),.rd(rd),.wr(wr),.addr_r(addr_r), .addr_w(addr_w),
   .full(full),.empty(empty), .we_enable(we_enable),.rd_enable(rd_enable) );
        
        
        
    // initialize memory register 
    reg_memory_file#(addr_size,word_width) fifo_memory (.we_s(we_enable), .clk(w_clk),.addr_r(addr_r),
          .addr_w(addr_w),.data_w(data_in),.data_r(data_out) );
    
    
    
    
    
    
    
    
    
    
endmodule
