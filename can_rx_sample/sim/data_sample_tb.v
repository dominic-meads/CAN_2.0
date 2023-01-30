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
  
  always #5 clk = ~clk;  // 100 MHz
  
  integer bit_time = 1000;  // 1000 ns or 1 Mb/s
  
  can_rx_sample #(100, 1000) uut (clk, rst_n, en, din, dout);
  
  initial 
    begin 
      $dumpfile("dump.vcd");
      $dumpvars(0, uut);
        clk = 0;
        rst_n = 0;
        en = 0;
      #20
        rst_n = 1;  // release rst_n
      #20
        en = 1;
        din = 1;
      #bit_time
        din = 0;  // SOF
      #bit_time 
        din = 1;
      #bit_time
        din = 0;
      #bit_time
        din = 0;
      #bit_time;
      $finish;
    end 
endmodule  // tb
