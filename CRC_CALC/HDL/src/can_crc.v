`timescale 1ns / 1ps

module can_crc (
  input clk,          // 100 MHz
  input rst_n,        // active low reset
  input en,           // enable activates @ SOF, deactivates after last bit of DATA field in frame is received
  input din,          // data input from CAN reciever
  output [14:0] crc,  // CRC 
  output crc_ready    // indicates CRC has been calculated
);
  
  reg [14:0] r_crc = 15'h0000;        // init crc reg
  reg r_crc_ready = 1'b0;             // init flag register
  
  wire w_crcnxt = din ^ r_crc[14];    			  // XOR of two bits (see pg. 13 of Bosch pdf)
  wire [14:0] w_crc_shift = {r_crc[13:0], 1'b0};  // init left shift
  
  always @ (posedge clk or negedge rst_n)
    begin
      if (!rst_n)
        begin 
          r_crc <= 15'h0000;
          r_crc_ready <= 1'b0;          
        end
      else
        begin 
          if (en) 
            begin 
              if (w_crcnxt)
                begin 
                  r_crc <= w_crc_shift ^ 15'h4599;
                end 
              else 
                begin 
                  r_crc <= w_crc_shift;
                end
            end
          else 
            begin 
              r_crc <= w_crc_shift;
            end
        end 
    end  
  
  assign crc = r_crc;
  assign crc_ready = r_crc_ready;
  
endmodule 


