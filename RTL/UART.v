`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2023 05:24:29 PM
// Design Name: 
// Module Name: UART
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


`include "rx.v"
`include "tx.v"
`include "fifo_control_unit.v"
`include "baud.v"
`include "asyn_fifo_top.v"
`include "dual_gray_counter.v"
`include "reg_memory_file.v"  




module UART#(parameter D_bits=9 ,
    parameter B_bits=10,
    parameter sb_tick =16
)( input clk,
             input reset_n,
             //transmitter ports
               input wr_uart,
               input [7:0] data_w,
              
               output tx,
               output tx_full,
             
               
             //reciever ports 
              input rx,
              input rd_uart,
             output [7:0] data_r,
             output rx_empty,
             output rx_err,//error detection
             output rx_done,
             output fr_err ,
             // baud 
              input [9:0] baud_final
              

    );
    
    
    
    
    
    
     wire parity_bit;
    wire s_tick;
     wire tx_done;
     wire [7:0] data_in, data_out ;  
      wire empty;
    // tx fsm
    tx#(.D_bits(9),.sb_tick (16) ) Uart_transmitter 
        (.clk(clk) , 
         .reset_n(reset_n),
         .data_in(data_in),
       .tx_start(~empty),
          .s_tick(s_tick),
          .tx(tx),
         .tx_done(tx_done),
       .parity_bit(parity_bit) 
    );
    /// the fifo of the tx
    asyn_fifo_top#(  .word_width(8)) tx_fifo (
         .r_clk(clk),
         .w_clk(clk),
         // read and write command
            .rd(tx_done),
          .wr(wr_uart),
         .reset_n(reset_n),
       .data_in(data_w),
         .data_out(data_in),
        .full(tx_full),
        .empty(empty)
        );
    
    // the reciever fsm
    rx#(.D_bits(9),.sb_tick (16) ) Uart_reciever 
    (.clk(clk) , 
     .reset_n(reset_n),
     .rx(rx),
     .s_tick(s_tick),
     .data_out(data_out),
     .rx_done(rx_done),
     .rx_err(rx_err),
     .fr_err(fr_err)
             );
        
     asyn_fifo_top#( .addr_size(8), .word_width(8)) rx_fifo (
                .r_clk(clk),
                .w_clk(clk),

             // read and write command
                .rd(rd_uart),
               .wr(rx_done),
             .reset_n(reset_n),
            .data_in(data_out),
             .data_out(data_r),
             .full(),
             .empty(rx_empty)
            );
    
    
timer #( .bits(10) ) baud_rate (
   .clk(clk) ,
 . enable(1'b1),
     .reset(reset_n),
   .final(baud_final),
     .tkl (s_tick)
    
    ); 
    
    
    
endmodule
