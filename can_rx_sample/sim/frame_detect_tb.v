//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Dominic Meads
// 
// Create Date: 02/02/2023 
// Design Name: 
// Module Name: tb
// Project Name: CAN_2.0
// Target Devices: 
// Tool Versions: 
// Description: Tests the SOF detection in frame_detect.v
//                    
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:                    
//////////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps

module tb();
  reg clk;        
  reg rst_n;
  reg can_rx;    
  wire sof_detect;
  
  always #5 clk = ~clk;  // 100 MHz FPGA system clock
  
  frame_detect #(100, 1000) uut (clk, rst_n, can_rx, sof_detect);
  
  // Data test frames
  reg [93:0] r_can_frame_1_data = 94'b0000110000010001000010000000000000100001000011101010000000000000000000000000000000011111111111;  
  reg [93:0] r_can_frame_2_data = 94'b0000110001010001000000100000000000000000000000000000001000000000000000000000000000011111111111;
  // Error test frame with IFS appended at end
  reg [83:0] r_can_frame_3_error = 84'b000011000101000100000010000000000000000000000000000000100000000000000000011111111111;
  
  integer i;  // int for the loop to ship out bitstream
  integer clk_speed_MHz = 100;
  integer can_bit_rate_Kbits = 1000;
  integer bit_period;
                       
  initial
    begin 
      $dumpfile("dump.vcd");
      $dumpvars(0,uut);
        clk = 1'b0;
        rst_n = 1'b0;
        can_rx = 1'b1; 
        bit_period_ns = ((clk_speed_MHz * 1000) / can_bit_rate_Kbits) * 10;
      #10
        rst_n = 1'b1;  // release rst
      #20
      // send first data frame
        for(i = 93; i >= 0; i=i-1)  
          begin 
            can_rx = r_can_frame_1_data[i];
            #bit_period_ns;
          end
        can_rx = 1'b1;
      #1000
        // send error frame
        for(i = 83; i >= 0; i=i-1)  
          begin 
            can_rx = r_can_frame_3_error[i];
            #bit_period_ns;
          end
        can_rx = 1'b1;
      #500
        // send second data frame
        for(i = 93; i >= 0; i=i-1)  
          begin 
            can_rx = r_can_frame_2_data[i];
            #bit_period_ns;
          end
        can_rx = 1'b1;
      #100
      $finish;
    end  // initial
endmodule  // tb
