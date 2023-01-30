`timescale 1 ns / 1 ps

module crc(
  input clk,        
  input rst_n,        // active low rst
  input din,          // serial bistream in
  input crc_en,       // conditional, if high, start crc calculation
  output [14:0] crc,  
  output crc_valid    // high when the crc has been calculated, i.e. when there are no more bits to shift in. 
);
  
  // output registers
  reg [14:0] r_crc = 15'h0000;
  reg r_crc_valid;
  
  wire w_crc_nxt = din ^ r_crc[14];
  
  always @ (posedge clk or negedge rst_n)
    begin 
      if (!rst_n)
        begin
          r_crc <= 15'h0000;
          r_crc_valid <= 1'b0;
        end  // if
      else 
        begin 
          if (crc_en)
            begin
              if (w_crc_nxt)
                begin 
                  // one-to-many Galois structure LFSR
                  r_crc[0]  <= 1;
                  r_crc[1]  <= r_crc[0];
                  r_crc[2]  <= r_crc[1];
                  r_crc[3]  <= r_crc[2] ^ 1'b1;
                  r_crc[4]  <= r_crc[3] ^ 1'b1;
                  r_crc[5]  <= r_crc[4];
                  r_crc[6]  <= r_crc[5];
                  r_crc[7]  <= r_crc[6] ^ 1'b1;
                  r_crc[8]  <= r_crc[7] ^ 1'b1;
                  r_crc[9]  <= r_crc[8];
                  r_crc[10] <= r_crc[9] ^ 1'b1;
                  r_crc[11] <= r_crc[10];
                  r_crc[12] <= r_crc[11];
                  r_crc[13] <= r_crc[12];
                  r_crc[14] <= r_crc[13] ^ 1'b1;
                end // if
              else 
                begin 
                  r_crc <= r_crc << 1;
                end // else
            end // if
           else 
            begin
              r_crc <= 15'h0000;
            end // else 
        end  // else
    end  // always
  
endmodule
