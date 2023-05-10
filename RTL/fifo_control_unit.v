`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2022 04:26:15 AM
// Design Name: 
// Module Name: fifo_control_unit
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


module fifo_control_unit#(
parameter addr_size=8

)
(
input reset_n,
input w_clk,// clock for writing 
input r_clk,// clock for reading
// read and write command
input rd,
input wr,
//read and write address
output [7:0] addr_r, //addr_size-1 bis for adressing 
output [7:0] addr_w,
output full,
output empty,
output we_enable,
output rd_enable
    );
    
    
    //declaring ptr ports 
    // ptr is n+1 bit to use the msb to detect the overlaping or the cycle
     wire [8:0] ptr_r;
     wire [8:0] ptr_w;
    // _syn and _syn_1 to syncronizie the pointer to the cross clock domain 
      reg [8:0] ptr_r_syn,ptr_r_syn_1;
      reg [8:0] ptr_w_syn,ptr_w_syn_1;
    
    ///write and read enable condition 
    assign we_enable =wr&(!full);
    assign  rd_enable=rd&(!empty) ;
   
    
    // increaminting the addr_r pointer when rd command and not empty on read clock
    dual_gray_counter#(.addr_size(8)) read_ptr(
         .clk(r_clk),
        .gray_count_st(ptr_r),//msb for cycle detction 
        .gray_count_nd(addr_r),
         .reset_n(reset_n),
         .en(rd_enable)
        );
        //increaminting the addr_w pointer when wr command and not full on write clock
    dual_gray_counter#(.addr_size(8)) write_ptr(
                .clk(w_clk),
              .gray_count_st(ptr_w),//msb for cycle detction 
                .gray_count_nd(addr_w),
                .reset_n(reset_n),
                .en(we_enable)
               );
               
               ///syncriozing the ptrs 
               /*  syncroizing the write pointer to read clock
               this will cause empty and full flag 
               
               */
               always@(posedge r_clk, negedge reset_n)
               begin
               if(~reset_n)//reseting block
               begin
               {ptr_w_syn,ptr_w_syn_1} <= 0; 
               end
               else begin    
                 ptr_w_syn_1 <= ptr_w;
                ptr_w_syn <=  ptr_w_syn_1;
               end 
               end
               
               //syncroizing the read pointer to write clock
               /*
               syncroization will cause a two-clock delay to the full and empty
               flags to go down but its safe and will prevent overwritting and reading miss data
               */
               always@(posedge w_clk, negedge reset_n)
                              begin
                              if(~reset_n)//reseting block
                              begin
                              {ptr_r_syn,ptr_r_syn_1} <= 0; 
                              end
                              else begin    
                                ptr_r_syn_1 <= ptr_r;
                               ptr_r_syn <=  ptr_r_syn_1;
                              end 
                              end
               
               // full and empty flags
               //  depend on grey code  cycling  
               
               //full cindition 
               /* the full condition accures when the write pointer msb differ from msb of read pointer
               this means wirte is overhead the read by cycle this is the first condition 
               the 2nd msb also must be diffrint to not cause false full due to the mirroring of gray code
               the rest should be the same  
               */
            assign full = ( (ptr_w[8] != ptr_r_syn[8]) &&
             (ptr_w[7] != ptr_r_syn[7]) &&
                  (ptr_w[6:0]) == (ptr_r_syn[6:0])    );
                  
                  
                  ///empty condition
                /* the empty condtion accures when they are in the same cycle
                and at the same memory location 
                */  
                  
      assign empty = (((ptr_w_syn == ptr_r))   );
endmodule
