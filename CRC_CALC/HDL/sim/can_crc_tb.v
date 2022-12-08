`timescale 1 ns / 1 ps

module tb();
  reg clk;
  reg rst_n;
  reg en;
  reg din;
  wire [14:0] crc;
  
  always #5 clk = ~clk;  // 100 MHz
  
  can_crc uut(clk, rst_n, en, din, crc);
  
  reg [9:0] r_idle = 10'hfff;  // IDLE time at end of frame
  reg [82:0] r_can_rx = 83'b00001100000100010000100000000000001000010000111010100000000000000000000000000000000;  // add extra one to see where data ends
  reg [92:0] r_bitstream;
  integer i;
  
  initial
    begin 
      $dumpfile("dump.vcd");
      $dumpvars(0,uut);
      clk = 0;
      rst_n = 0;
      en = 0;
      din = 0;
      r_bitstream = {r_idle, r_can_rx};  // put idle time in front
      #10
      rst_n = 1;
      #20
      en = 1;
      for(i = 92; i >= 0; i=i-1)
        begin 
          din = r_bitstream[i];
          #2000;  // 500 Kbit/s
        end 
      #200000
      $finish;
    end 
endmodule
