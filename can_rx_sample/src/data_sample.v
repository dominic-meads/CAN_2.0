//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Dominic Meads
// 
// Create Date: 01/30/2023 
// Design Name: 
// Module Name: data_sample
// Project Name: CAN_2.0
// Target Devices: 
// Tool Versions: 
// Description: Samples the incoming bitstream on the CAN lines. Sampling is enabled
//              by the SOF flag, and continued until frame has reached the CRC field.
//                    
// Dependencies: 100 MHz clock, 1 Mb/s data rate
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:                    
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module can_rx_sample
  #(parameter clk_speed_MHz = 100,        // system clock on FPGA board
    parameter can_bit_rate_Kbits = 1000)  // CAN speed on my vehicle
  (
  input clk,     // 100 MHz
  input rst_n,   // active low
  input en,      // active at SOF until CRC field
  input din,     // rx in
  output dout,   // registered data out to other modules
  output dvalid  // data valid  
  );
  
  // states
  parameter IDLE = 1'b0;
  parameter SAMPLE = 1'b1;
  
  // state registers
  reg r_present_state;
  reg r_next_state; 
  
  // counter and output registers
  reg [$clog2((clk_speed_MHz * 1000) / can_bit_rate_Kbits)-1:0] r_clks_per_bit_counter = 0;
  reg r_dout = 1'b0;
  reg r_dvalid = 1'b0;
  
  // present state logic
  always @ (posedge clk or negedge rst_n)
    begin 
      if (!rst_n)
        begin 
          r_present_state <= IDLE;
        end  // if (!rst_n)
      else 
        begin
          r_present_state <= r_next_state;
        end  // else
    end  // always 
  
  // next state logic
  always @ (r_present_state, en)
    begin 
      case (r_present_state)
        IDLE : begin 
                 if (en) 
                    begin 
                      r_next_state = SAMPLE;
                    end  // if (en)
               end  // IDLE
        SAMPLE : begin 
                   if (!en) 
                     begin 
                       r_next_state = IDLE;
                     end  // if (!en)
                 end  // SAMPLE
        default : r_next_state = IDLE;
      endcase 
    end  // always 
      
  // implement up counter
  always @ (posedge clk or negedge rst_n)
    begin
      if (!rst_n)
        begin 
          r_clks_per_bit_counter <= 0;
        end  // if (!rst_n)
      else
        begin 
          if (r_next_state == SAMPLE) 
            begin 
              if (r_clks_per_bit_counter < ((clk_speed_MHz * 1000) / can_bit_rate_Kbits) - 1)
                begin
                  r_clks_per_bit_counter <= r_clks_per_bit_counter + 1;
                end  // if (r_clks_per...
        	  else 
                begin
                  r_clks_per_bit_counter <= 0;
                end  // else
            end
          else
            begin
              r_clks_per_bit_counter <= 0;
            end  // else
        end  // else
    end   // always
  
  // implement data sample 
  always @ (posedge clk or negedge rst_n)
    begin 
      if(!rst_n)
        begin 
          r_dout <= 1'b0;
          r_dvalid <= 1'b0;
        end  // (!rst_n)
      else 
        begin 
          if (r_clks_per_bit_counter == ((clk_speed_MHz * 1000) / can_bit_rate_Kbits)/2 - 1) 
            begin
              r_dout <= din;  // sample data at halfway point during bit period
              r_dvalid <= 1'b1;
            end  // if (r_clk_per...
        end  // else
    end  // always
      
  assign dout = r_dout;
  assign dvalid = r_dvalid; 
      
endmodule  // data_sample
