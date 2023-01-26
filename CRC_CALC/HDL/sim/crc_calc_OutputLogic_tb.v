`timescale 1 ns / 1 ps

module tb();
  reg [82:0] data_in = 83'b00001100000100010000100000000000001000010000111010100000000000000000000000000000000; 
  reg crc_en;
  wire [14:0] crc_out;
  reg rst;
  reg clk;
  
  always #500 clk = ~clk;  // 1 MHz
  
  crc uut (data_in, crc_en, crc_out, rst, clk);
  
  initial
    begin 
      $dumpfile("dump.vcd");
      $dumpvars(0,uut);
      clk = 0;
      rst = 1;
      crc_en = 0;
      #10
      rst = 0;  // release rst
      #20
      crc_en = 1;
      #200000000
      $finish;
    end
endmodule
