`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2022 04:25:37 AM
// Design Name: 
// Module Name: reg_memory_file
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


module reg_memory_file#(
parameter addr_size=8,
 word_width=8
)(
    input we_s,//write enable signal 
    input clk,
    input [7:0] addr_r,// read address
    input [7:0] addr_w,//write address
    input [7:0] data_w,// data to be written
   output [7:0] data_r // daa to be read
   );
   
    
    //describing a memory  
   reg [7:0] reg_mem [0: 2**8 -1];
   
   //write operation 
   always@(posedge clk) 
   begin
   if(we_s)
   reg_mem[addr_w] <= data_w;
  
   end
   
   // asyn read
    assign data_r = reg_mem[addr_r];
    
endmodule
