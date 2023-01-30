//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Dominic Meads
// 
// Create Date: 01/30/2023 
// Design Name: 
// Module Name: crc_calc
// Project Name: CAN_2.0
// Target Devices: 
// Tool Versions: 
// Description: Performs a CRC calculation as described in the Bosch CAN 2.0 specification.
//              (Pgs. 13-14 http://esd.cs.ucr.edu/webres/can20.pdf)
//
//              Generator polynomial for CAN 2.0: 
//              x^15 + x^14 + x^10 + x^8 + x^7 + x^4 + x^3 + 1
//                    
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:                    
//////////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 1 ps

module crc_calc(
  input clk,        
  input rst_n,        // active low rst
  input din,          // serial bistream in
  input crc_en,       // If high, start crc calculation (waits for SOF)
  output [14:0] crc,  // crc output
);
  
  reg [14:0] r_crc = 15'h0000;
  
  wire w_crc_nxt = din ^ r_crc[14];
  
  always @ (posedge clk or negedge rst_n)
    begin 
      if (!rst_n)
        begin
          r_crc <= 15'h0000;
        end  // if (!rst_n)
      else 
        begin 
          if (crc_en)
            begin
              if (w_crc_nxt)
                begin 
                  // This block performs the shift and the XOR with 0x4599 at the same time. 
                  r_crc[0]  <= 1'b1;  // in the Bosch specification, after the shift, this bit is set to 0, but then XORed with 1. 0 ^ 1 = 1
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
                end // if (w_crc_nxt)
              else 
                begin 
                  r_crc <= r_crc << 1; 
                end // else
            end // if (crc_en)
           else 
            begin
              r_crc <= 15'h0000;
            end // else 
        end  // else
    end  // always
  
  assign crc = r_crc; 
  
endmodule  // crc_calc
          
