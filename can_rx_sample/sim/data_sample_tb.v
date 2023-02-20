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
// Description: Verifies module data_sample. Acts as CAN tx, transmitting bits @ 1 Mb/s
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
  reg en;
  reg din;
  wire dout;
  wire dvalid;
  
  always #5 clk = ~clk;  // 100 MHz
  
  integer i;  // int for the loop to ship out bitstream
  integer clk_speed_MHz = 100;
  integer can_bit_rate_Kbits = 1000;
  integer bit_period;
  
  // example frame
  reg [82:0] r_can_frame_1_data = 83'b00001100000100010000100000000000001000010000111010100000000000000000000000000000000; 
  
  can_rx_sample #(100, 1000) uut (clk, rst_n, en, din, dout, dvalid);
  
  initial 
    begin 
      $dumpfile("dump.vcd");
      $dumpvars(0, uut);
        clk = 0;
        rst_n = 0;
        en = 0;
      bit_period_ns = ((clk_speed_MHz * 1000) / can_bit_rate_Kbits) * 10;
      #20
        rst_n = 1;  // release rst_n
      #20
      en = 1;  // simulate SOF
      // send data frame
      for(i = 82; i >= 0; i=i-1)  
          begin 
            din = r_can_frame_1_data[i];
            #bit_period_ns;
          end
      en = 0;  // start of CRC, disable data sampling
      #1000
      en = 1;  // see if state machine resets
      #1000
      $finish;
    end 
endmodule  // tb
