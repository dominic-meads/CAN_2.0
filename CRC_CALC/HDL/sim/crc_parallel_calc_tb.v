//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Dominic Meads
// 
// Create Date: 01/30/2023 
// Design Name: 
// Module Name: tb
// Project Name: CAN_2.0
// Target Devices: 
// Tool Versions: 
// Description: Tests the crc calculation from crc_calc.v
//              Both the CAN frame bitstreams for test were taken from a vehicle's OBD2 port. 
//              Both frames had the ACK bit driven to 0, indicating a valid CRC. 
//                    
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:                    
//////////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps

module tb();
//  reg clk;
//  reg rst_n;
  reg [82:0] din;
//  reg crc_en;
  wire [14:0] o_crc;
  
 // always #500 clk = ~clk;  // 1 MHz clock, for this test, sending one bit per clock cycle
  
  CRC15_D83 uut (din, o_crc);
  
  // These are the test frames and contain the following fields in this order: SOF, arbitration, control, and data (both frames are data frames)
  reg [82:0] r_can_frame_1 = 83'b00001100000100010000100000000000001000010000111010100000000000000000000000000000000;  
  reg [82:0] r_can_frame_2 = 83'b00001100010100010000001000000000000000000000000000000010000000000000000000000000000;
  
//  reg [9:0] r_idle = 10'hfff;  // IDLE time at end of frame
//  reg [92:0] r_bitstream; 
  
  integer i;  // int for the loop to ship out bitstream
  
  initial
    begin 
      $dumpfile("dump.vcd");
      $dumpvars(0,uut);
      din = r_can_frame_1;
      #100
      din = r_can_frame_2;
      #100
      $finish;
    end  // intial
endmodule  // tb
