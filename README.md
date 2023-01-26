# CAN_2.0
CAN_2.0

Bosch Specification: http://esd.cs.ucr.edu/webres/can20.pdf 

CRC calculator/HDL code generator
http://outputlogic.com/?page_id=321 I think this calculator is based on this paper: https://patentimages.storage.googleapis.com/23/eb/42/41726b420b55f1/US6295626.pdf

Also https://docs.xilinx.com/v/u/en-US/xapp209 has good examples and descriptions of how CRCs are calculated, as well as modular arithmetic.
There is supposed to be an attatched zip file that has perl scripts to generate "next-state" equations for a parallel CRC architecture (as opposed to LFSR).
I cannot find this file. 


I looked at CAN frames coming from my OBD2 port on my car. Below is one example, with the corresponding CRC

BITSTREAM FOR CAR

SOF |  ARBITRATION | CONTROL |

0     000110000010   001000   

DATA      

0100 0000 0000 0001 0000 1000 0111 0101 0000 0000 0000 0000 0000 0000 0000 0000  -- Bin

 4    0    0    1    0    8    7    5    0    0    0    0    0    0    0    0    -- Hex
                            
                            
CRC = 101101101000000
hex -> 5B40
