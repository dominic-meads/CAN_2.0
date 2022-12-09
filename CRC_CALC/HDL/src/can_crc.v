`timescale 1ns / 1ps

module can_crc
  #(parameter clk_speed_MHz = 100,
    parameter can_bit_rate_Kbits = 500)
(
  input clk,          // 100 MHz
  input rst_n,        // active low reset
  input en,           // enable activates @ SOF, deactivates after last bit of DATA field in frame is received
  input din,          // data input from CAN reciever
  output [14:0] crc,  // CRC 
  output crc_ready    // indicates CRC has been calculated
);
  
  //reg r_din_sample = 1'b0;            // holds sample of input data from CAN RX
  reg [14:0] r_crc = 15'h0000;        // init crc reg
  reg r_crc_ready = 1'b0;             // init flag reg
  reg r_crcnxt = 1'b0;                // holds XOR of crc[14] and din
  //reg [14:0] r_crc_shift = 15'h0000;  // init left shift reg
  
  wire [14:0] w_crc_shift = {r_crc[13:0], 1'b0};
  
  // counter registers
  reg [$clog2((clk_speed_MHz * 1000) / can_bit_rate_Kbits)-1:0] r_clks_per_bit_counter = 0;
  
  // implement up counter
  always @ (posedge clk or negedge rst_n)
    begin
      if (!rst_n)
        begin 
          r_clks_per_bit_counter <= 0;
        end 
      else
        begin 
          if (en) 
            begin                          // below is the calculation of the max system clk cycles per CAN RX data bit
              if (r_clks_per_bit_counter < ((clk_speed_MHz * 1000) / can_bit_rate_Kbits) - 1)
                begin
                  r_clks_per_bit_counter <= r_clks_per_bit_counter + 1;
                end 
        	  else 
                begin
                  r_clks_per_bit_counter <= 0;
                end 
            end
          else
            begin
              r_clks_per_bit_counter <= 0;
            end
        end
    end 
  
  // implement data sample close to middle of CAN RX bit
  always @ (posedge clk or negedge rst_n)
    begin 
      if(!rst_n)
        begin 
          r_crcnxt <= 1'b0;
          //r_crc_shift <= 15'h0000;
        end 
      else 
        begin                              // find halfway point in counter using given parameters
          if (r_clks_per_bit_counter == ((clk_speed_MHz * 1000) / can_bit_rate_Kbits)/2 - 1) 
            begin
              r_crcnxt <= din ^ r_crc[14]; // sample  and XOR input data @ halfway (most stable)
            end 
        end 
    end
  
  // CRC calculation
  always @ (posedge clk or negedge rst_n)
    begin
      if (!rst_n)
        begin
          r_crc <= 15'h0000;
          r_crc_ready <= 1'b0;
        end
      else
        begin 
          if (en && r_clks_per_bit_counter == ((clk_speed_MHz * 1000) / can_bit_rate_Kbits)/2 - 1) 
            begin
              if (r_crcnxt)
                begin 
                  r_crc <= w_crc_shift ^ 15'h4599;
                end 
              else 
                begin 
                  r_crc <= w_crc_shift;
                end
            end
        end 
    end  
  
  assign crc = r_crc;
  //assign crc_ready = r_crc_ready;
  
endmodule


