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


module UART#(parameter D_bits=9 ,
    parameter B_bits=10,
    parameter sb_tick =16
)( input clk,
             input reset_n,
             //transmitter ports
               input wr_uart,
               input [D_bits-2:0] data_w,
              
               output tx,
               output tx_full,
             
               
             //reciever ports 
              input rx,
              input rd_uart,
             output [D_bits-2:0] data_r,
             output rx_empty,
             output rx_err,//error detection
             output rx_done,
             output fr_err ,
             // baud 
              input [B_bits-1:0] baud_final
              

    );
     wire parity_bit;
    wire s_tick;
     wire tx_done;
     wire [D_bits-2:0] data_in, data_out ;  
      wire empty;
    // tx fsm
    tx#(.D_bits(D_bits),.sb_tick (sb_tick) ) Uart_transmitter 
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
    asyn_fifo_top#( .addr_size(3), .word_width(D_bits-1)) tx_fifo (
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
    rx#(.D_bits(D_bits),.sb_tick (sb_tick) ) Uart_reciever 
    (.clk(clk) , 
     .reset_n(reset_n),
     .rx(rx),
     .s_tick(s_tick),
     .data_out(data_out),
     .rx_done(rx_done),
     .rx_err(rx_err),
     .fr_err(fr_err)
             );
        
     asyn_fifo_top#( .addr_size(3), .word_width(D_bits-1)) rx_fifo (
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
    
    
timer #( .bits(B_bits) ) baud_rate (
   .clk(clk) ,
 . enable(1'b1),
     .reset(reset_n),
   .final(baud_final),
     .tkl (s_tick)
    
    ); 
    
    
    
endmodule
