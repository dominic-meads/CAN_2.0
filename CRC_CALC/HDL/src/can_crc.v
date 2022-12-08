`timescale 1ns / 1ps

module can_crc (
  input clk,
  input rst_n,
  input en,
  input din,
  output [14:0] crc
);
  
  reg [14:0] r_crc = 15'h0000;        // init crc reg
  reg [14:0] r_crc_shift = 15'h0000;  // init crc shift reg
  
  reg r_crcnxt = 1'b0;
  
  always @ (posedge clk or negedge rst_n)
    begin
      if (!rst_n)
        begin 
          r_crc <= 15'h0000;
          r_crcnxt <= 1'b0;
        end
      else
        begin
          if (en)
            begin
              r_crcnxt <= r_crc[14] ^ din;
              r_crc_shift <= {r_crc[13:0], 1'b0};
                if (r_crcnxt)
                  begin 
                    r_crc <= r_crc_shift ^ 15'h4599;
                  end 
                else 
                  begin 
                    r_crc <= r_crc_shift;
                  end 
            end 
          else 
            begin 
              r_crc <= 15'h0000;
            end 
        end
      end 
  
  //assign crc <= r_crc;
  
endmodule 


