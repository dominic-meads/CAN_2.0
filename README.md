# CAN_2.0
CAN_2.0

Bosch Specification: http://esd.cs.ucr.edu/webres/can20.pdf 

CRC calculator
http://outputlogic.com/?page_id=321


I looked at CAN frames coming from my OBD2 port on my car. Below is one example, with the corresponding CRC

BITSTREAM FOR CAR

SOF |  ARBITRATION | CONTROL |                                     DATA                                       |
0     000110000010   001000    0100 0000 0000 0001 0000 1000 0111 0101 0000 0000 0000 0000 0000 0000 0000 0000
       Data in hex          0x  4    0    0    1    0    8    7    5    0    0    0    0    0    0    0    0 
                            
                            
                            
 CRC = 101101101000000
