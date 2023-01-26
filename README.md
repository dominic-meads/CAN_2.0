# CAN_2.0
CAN_2.0

Bosch Specification: http://esd.cs.ucr.edu/webres/can20.pdf

Trying to port code (pg 13 ^) from Bosch Specification to C (no idea what original code language is). 

CRC calculator
http://crctool.easics.be/

CRC calculation forum
https://www.edaboard.com/threads/c-verilog-code-for-crc-calculation-for-polynomials.61526/




BITSTREAM FOR CAR

SOF |  ARBITRATION | CONTROL |                                     DATA                                       |
0     000110000010   001000    0100 0000 0000 0001 0000 1000 0111 0101 0000 0000 0000 0000 0000 0000 0000 0000
                            0x  4    0    0    1    0    8    7    5    0    0    0    0    0    0    0    0 
                            
                            
                            
 CRC = 101101101000000
