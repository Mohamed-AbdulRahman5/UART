`timescale 1ns/ 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2023 07:33:16 PM
// Design Name: 
// Module Name: uart_tb
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


module uart_tb(   );



 localparam D_bits=9 ,B_bits =10 ,sb_tick =16;
  reg clk,reset_n;
             //transmitter ports
               reg wr_uart;
               reg [D_bits-2:0] data_w ;
               wire tx, tx_full;
             //reciever ports 
              reg rx;
              reg rd_uart;
              wire  [D_bits-2:0] data_r;
              wire rx_empty,rx_err, rx_done, fr_err ;
             // baud 
             reg [B_bits-1:0] baud_final;
              

 UART#( D_bits , B_bits,sb_tick )   UART_TB (  clk,reset_n,
             //transmitter ports
                wr_uart, data_w,tx,tx_full,
             //reciever ports 
               rx,rd_uart,data_r, rx_empty,
             rx_err,//error detection
              rx_done,fr_err ,
             // baud 
               baud_final  );




    
 initial
 begin 
   baud_final=650; // value for baud rate
 clk=0;
 reset_n=1 ;
 rx=1;
 rd_uart=0;
 wr_uart=0;
 data_w= 8'b00100101;
 
 end   
  //reset block  
initial begin
 #2 reset_n=0;
 #2 reset_n=1;
 end   
//clock gen block
always #5 clk =~clk;


// transmiter block
initial begin 
  data_w = 8'b00101010;
 #6 wr_uart=1;
 #10 wr_uart=0;

end

//reciever block

initial begin 

// freeze state
#5 rx =1;
// start bit
#10 rx =0;
// data bits 11100110 
// 104160 ps is the duration of the single bit
#104160 
rx= 0; //lsb first
#104160 
rx= 1;
#104160 
rx= 1;
#104160 
rx= 0;
#104160 
rx= 0;
#104160 
rx= 1;
#104160 
rx= 1;
#104160 
rx= 1;
//parity bit 
#104160 
rx= 1; 
// stop bit 
#104160 
rx= 1;


end







    

endmodule
