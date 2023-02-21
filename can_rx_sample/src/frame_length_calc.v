//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Dominic Meads
// 
// Create Date: 02/20/2023 
// Design Name: 
// Module Name: frame_length_calc
// Project Name: CAN_2.0
// Target Devices: 
// Tool Versions: 
// Description: Looks at different bits in the frame such at RTR, IDE, and DLC bits and 
//              determines the length of the frame, as well as when sampling should stop.
//                    
// Dependencies: 100 MHz clock, 1 Mb/s data rate
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:                    
//////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps

module frame_length_calc #(
    parameter clk_speed_MHz = 100,        // system clock on FPGA board
    parameter can_bit_rate_Kbits = 1000)  // CAN speed on my vehicle
  (
    input clk,                       // 100 MHz
    input rst_n,                   
    input sof,                       // sof detected flag
    input error,                     // error flag
    input overload,                  // overload flag
    input din,                       // CAN Rx
    input dvalid,                    // data valid after sample
    output [7:0] frame_length_bits,  //frame length 
    output sample_en                 // low after the frame ends (only sample bus when there is a frame)
  );
  
  // States
  parameter IDLE = 4'b0000;
  parameter RTR_SSR = 4'b0001;
  parameter IDE = 4'b0010;
  
  // states for standard length identifier
  parameter STD = 4'b0011;
  parameter DATA_STD = 4'b0100;
  parameter REMOTE_STD = 4'b0101;
  
  // states for extended length identifier
  parameter RTR_EXT = 4'b0111;
  parameter DATA_EXT = 4'b1000;
  parameter REMOTE_EXT = 4'b1001;
  
  // state registers
  reg r_present_state;
  reg r_next_state; 
  
  // counter and output registers
  reg [7:0] r_frame_length_bits = 8'h00;
  reg [7:0] r_max_bits = 8'FF; 
  reg r_rtr_ssr = 1'b0;  // holds value of rtr bit in standard frame, or ssr bit in extended frame
  reg r_sample_en = 1'b0;
  
  // up counter
  always @ (posedge clk or negedge rst_n)
    begin 
      if (!rst_n)
        begin 
          r_frame_length_bits <= 0;
        end  // if (!rst_n)
      else 
        begin 
          if (dvalid)  // only increment when dvalid is high
            begin 
              if (r_frame_length_bits < r_max_bits)
                begin 
                  r_frame_length_bits <= r_frame_length_bits + 1;
                end  // if (r_frame_length...
              else 
                begin 
                  r_frame_length_bits <= 0;
                end  // else 
            end  // if (dvalid)
        end  // else
    end  // always 
              
  
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
    always @ (r_present_state, r_frame_length_bits, r_max_bits, sof, r_rtr_ssr)
    begin 
      case (r_present_state)
        
        IDLE : begin  // looks for SOF
          if (sof) 
            begin 
              r_next_state = RTR_SSR;
            end  // if (sof)
        end  // IDLE
        
        RTR_SSR : begin  // state to register the RTR/SSR bit for later use
          if (r_frame_length_bits == 12)
            begin
 //             r_rtr_ssr = din;     // register for later
              r_next_state = IDE;
            end  // if (r_frame_length...
        end  // RTS_SSR
        
        IDE : begin  // Determines if the frame is extended or standard 
          if (r_frame_length_bits == 13)
            begin
              if (din)  // The frame has an extended ID
                begin 
                  r_next_state = RTR_EXT;
                end  // if (din)
              else   // frame has a standard ID
                begin 
                  r_next_state = STD;
                end  // else    
            end  // if (r_frame_length...
        end  // IDE
        
        STD : begin 
          if (r_rtr_ssr)  // this bit in the standard frame format determines if the frame is data or remote
            begin  // remote frame
              r_next_state = REMOTE_STD;
            end  // if (rtr_ssr)
          else 
            begin  // data frame
              r_next_state = DATA_STD;
            end  // else
        end  // STD
          
        REMOTE_STD : begin  // no data in this frame, but still waits for all the bits to go back to IDLE
          if (r_frame_length_bits == r_max_bits)
            begin 
              r_next_state = IDLE;
            end  // if (r_frame_length...
        end  // REMOTE_STD
          
        DATA_STD : begin  // waits for all data to be sampled, then goes back to IDLE
          if (r_frame_length_bits == r_max_bits)
            begin 
              r_next_state = IDLE;
            end  // if (r_frame_length...
        end  // DATA_STD  
        
        RTR_EXT : begin 
          if (r_frame_length_bits == 32)  // this bit in the extended frame format determines if the frame is data or remote
            begin  // remote frame
              if (din)  // See if extended frame is a remote or data frame
                begin 
                  r_next_state = REMOTE_EXT;
                end  // if (din)
              else   // extended frame is data
                begin 
                  r_next_state = DATA_EXT;
                end  // else    
            end  // if (r_frame_length...
        end  // RTR_EXT
  
        REMOTE_EXT : begin  // no data in this frame, but still waits for all the bits to go back to IDLE
          if (r_frame_length_bits == r_max_bits)
            begin 
              r_next_state = IDLE;
            end  // if (r_frame_length...
        end  // REMOTE_EXT
          
        DATA_EXT : begin  // waits for all data to be sampled, then goes back to IDLE
          if (r_frame_length_bits == r_max_bits)
            begin 
              r_next_state = IDLE;
            end  // if (r_frame_length...
        end  // DATA_EXT
        
        default : begin 
          r_next_state = IDLE;
        end  // default
        
      endcase
    end  // always
                
            
               
              
                
              
              
         
        
  
  
  
