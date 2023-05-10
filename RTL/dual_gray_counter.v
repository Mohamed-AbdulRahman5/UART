`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2022 07:51:31 PM
// Design Name: 
// Module Name: gray_counter
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


module dual_gray_counter#(
parameter addr_size=8
)(
    input clk,
    output [8:0] gray_count_st,//msb for cycle detction 
    output [7:0] gray_count_nd,
    input reset_n,
    input en
    );
    
    
    reg [8:0] Q_reg,Q_next ;
    wire _2nd_msb ;
     always @(posedge clk, negedge reset_n)
       begin
           if (~reset_n)
               Q_reg <= 'b0;
           else if(en)
               Q_reg <= Q_next;
               else Q_reg <= Q_reg ;
       end
       
       // Next state logic
       always @(Q_reg)
       begin
           Q_next <= Q_reg + 1;
       end
       
       // Output logic fr gary convertion
       //nbit gray output
    assign gray_count_st = Q_reg ^ (Q_reg >> 1);
    
   /// logic for n-1 bit 
    assign _2nd_msb = gray_count_st[8] ^gray_count_st[7];
    assign gray_count_nd ={_2nd_msb,gray_count_st[6:0]};
endmodule
