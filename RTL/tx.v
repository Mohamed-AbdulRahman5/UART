



module tx #(parameter D_bits=9 ,
    parameter sb_tick =16
)(   input clk, reset_n,
     input [7:0] data_in,
     input tx_start,
     input s_tick,
     output reg tx,
     output reg tx_done,
     output reg parity_bit 
);

 localparam  idle = 0, start = 1,
                    data = 2, stop = 3;
 reg tx_next;
  reg [7:0] b_reg, b_next;   // the register of the data shifted in  +parity                                
 reg [1:0] state_reg, state_next; // the track of state
 reg [3 :0] n_reg, n_next;// number of bits shifted in+ parity bit 
 reg [3:0] s_reg, s_next;   //baud rate 
 reg parity_next;// generated parity inside tx
 
   always@(posedge clk, negedge reset_n)begin 
        if (~reset_n)
         begin
             state_reg <= 0;
             s_reg <= 0;
             n_reg <= 0;
             b_reg <= 0;
             parity_bit <=0;
             end
         else  begin
              state_reg <= state_next;
              s_reg <= s_next;
              n_reg <= n_next;
              b_reg <= b_next;
              parity_bit <=parity_next;
               if(n_reg==8)
                   tx <= parity_bit;
                 else tx <= tx_next;
              end
                 end
         
         always @(*) begin
         
         state_next <= state_reg;
                 s_next <= s_reg;
                 n_next <= n_reg;
                 b_next <= b_reg;
                 tx_done <= 1'b0;
              parity_next <= parity_bit;
              
   case (state_reg)
        idle:   
       begin    
        tx_next <= 1'b1;         
           if (tx_start)
               begin
         s_next <= 0;
          b_next <= data_in;
           state_next <= start;                        
              end
              end                 
           start:    
              begin
               tx_next <= 1'b0;            
                if (s_tick)
                if (s_reg == 15)
                begin
                s_next <= 0;
                n_next <= 0;
                 state_next <= data;
                  end
                else                        
                 s_next <= s_reg + 1;
                          end                                                                                       
            data:
                  begin
                  tx_next <= b_reg[0];
                  if (s_tick) begin
                   if(s_reg == 15) begin
                   if(n_reg==8)
                     begin
                     n_next<=0;
                   s_next<=0;
                   state_next <=stop;
                   end             
                  else begin    s_next<=0;
                 b_next <= b_reg>>1;//shifting right  
                 parity_next <= parity_bit ^ tx;  
                n_next <=n_reg+1;  end//else for n_reg != d_bits            
                end
             else s_next <=s_reg+1;//else for s_reg=!15
             end 
             else  state_next <= state_reg;
             end
        stop:
           begin
              tx_next <= 1'b1;
              if (s_tick)
                if(s_reg == (15))
                begin
                     tx_done <= 1'b1;
                     state_next <= idle;
                     end
                     else
                     s_next <= s_reg + 1;                        
                          end
                          default:
                              state_next <= idle;
                      endcase  

               end
               
endmodule
