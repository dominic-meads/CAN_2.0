//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Dominic Meads
// 
// Create Date: 01/30/2023 
// Design Name: 
// Module Name: frame_detect
// Project Name: CAN_2.0
// Target Devices: 
// Tool Versions: 
// Description: Determines the SOF, then enables the data_sample module to 
//              start registering the data. 
//        
//              On Data and Remote frames, End Of Frame (EOF) and 
//              Inter-Frame Space (IFS) together consist of 11 recessive bits. 
//              On error and overload frames, the error and overload delimiters 
//              consist of 8 recessive bits, and if either are not follwed by the 
//              other (i.e. error frame followed by overload frame or vice versa),
//              a minimum of 3 recessive bits will follow. 
// 
//              In any frame type, 11 consecutive recessive bits denotes the end of 
//              a frame. This module looks for those 11 bits, and once they have been 
//              transmitted, it looks for the first dominant bit, indicating the start 
//              of another frame (SOF)
//
//              More info on overload/error frames: https://www.embeddedc.in/p/can-basics3.html
//                    
// Dependencies: 100 MHz clock, 1 Mb/s data rate
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:                    
//////////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps

module frame_detect#(
  parameter clk_speed_MHz = 100,
  parameter can_bit_rate_KHz = 1000
)(
  input clk,     // 100 MHz system clk
  input rst_n,
  input can_rx,  // data in
  output sof     // start of frame, if high, enables the data_sample module 
); 
  
  // counter register to keep track of clk cycles per 11 recessive bits sent on the can line
  reg [$clog2(((clk_speed_MHz * 1000) / can_bit_rate_Kbits)*11)-1:0] r_frame_end_time = 0;
  
  reg r_sof = 1'b0;
  
  // up counter timer
  always @ (posedge clk or negedge rst_n)
    begin 
      if (!rst_n)
        begin 
          r_sof <= 1'b0; 
          r_frame_end_time <= 0;
        end  // if (!rst_n)
      else 
        begin 
          if (can_rx)  // start counter everytime a recessive level is read
            begin
              if (r_frame_end_time < ((clk_speed_MHz * 1000) / can_bit_rate_Kbits)*11))  // if less than max time value
                begin 
                  r_frame_end_time <= r_frame_end_time + 1;  // count up
                end  // if (r_frame_end...
              else 
                begin 
                  r_frame_end_time <= 0;  // reset counter
                end  // else
            end
          
          
          add always block to start sof when counter is maxed. 
          add in the else statement for when can_rx is not high. 
              
          
  
  
endmodule  // frame_detect
  
