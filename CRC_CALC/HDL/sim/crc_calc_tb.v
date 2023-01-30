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
  reg clk;
  reg rst_n;
  reg din;
  reg crc_en;
  wire [14:0] crc;
  
  always #500 clk = ~clk;  // 1 MHz clock, for this test, sending one bit per clock cycle
  
  crc_calc uut (clk, rst_n, din, crc_en, crc);
  
  // These are the test frames and contain the following fields in this order: SOF, arbitration, control, and data (both frames are data frames)
  reg [82:0] r_can_frame_1 = 83'b00001100000100010000100000000000001000010000111010100000000000000000000000000000000;  
  reg [82:0] r_can_frame_2 = 83'b00001100010100010000001000000000000000000000000000000010000000000000000000000000000;
  
  reg [9:0] r_idle = 10'hfff;  // IDLE time at end of frame
  reg [92:0] r_bitstream; 
  
  integer i;  // int for the loop to ship out bitstream
  
  initial
    begin 
      $dumpfile("dump.vcd");
      $dumpvars(0,uut);
        clk = 0;
        rst_n = 0;
        crc_en = 0;
        din = 0;
        r_bitstream = {r_idle, r_can_frame_1};  // put idle time in front
      #10
        rst_n = 1;  // release rst
      #20
        for(i = 92; i >= 0; i=i-1)  // start shipping out 1st CAN frame
          begin 
            din = r_bitstream[i];
            if (i <= 82 && i != 0)  // after idle bits from previous frame, SOF starts, drive "en" high 
              begin 
                crc_en = 1;
              end 
            #1000;  // only ship one bit per clock cycle
          end
        $display ("CRC for CAN frame 1 = %h", crc);
        if (crc == 15'h5B40)  // 0x5B40 is the correct CRC for CAN frame 1
          begin 
            $display ("Test 1 passed");
          end  // if (crc == ...
        else 
          begin 
            $display ("Test 1 failed");
        end  // else
        crc_en = 0; // no more bits in bitstream, stop LFSR
      #200
        rst_n = 0;  // reset for next frame and crc calculation
      #20
        rst_n = 1;
        r_bitstream = {r_idle, r_can_frame_2};
        for(i = 92; i >= 0; i=i-1)  // start shipping out 2nd CAN frame
          begin 
            din = r_bitstream[i];
            if (i <= 82 && i != 0)  // after idle bits from previous frame, SOF starts, drive "en" high 
              begin 
                crc_en = 1;
              end 
            #1000;  // only ship one bit per clock cycle
          end
        $display ("CRC for CAN frame 2 = %h", crc);
        if (crc == 15'h3711)  // 0x3711 is the correct CRC for CAN frame 2
          begin 
            $display ("Test 2 passed");
          end  // if (crc == ...
        else 
          begin 
            $display ("Test 2 failed");
        end  // else
        crc_en = 0; // no more bits in bitstream, stop LFSR
      #10
      $finish;
    end  // intial
endmodule  // tb
