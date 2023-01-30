# CAN_2.0
CAN_2.0

Bosch Specification: http://esd.cs.ucr.edu/webres/can20.pdf 

Also https://docs.xilinx.com/v/u/en-US/xapp209 has good examples and descriptions of how CRCs are calculated, as well as modular arithmetic.

I looked at CAN frames coming from my OBD2 port on my car. Below is one example, with the corresponding CRC

BITSTREAM FOR CAR

SOF |  ARBITRATION | CONTROL |

0     000110000010   001000   

DATA      

0100 0000 0000 0001 0000 1000 0111 0101 0000 0000 0000 0000 0000 0000 0000 0000  -- Bin

 4    0    0    1    0    8    7    5    0    0    0    0    0    0    0    0    -- Hex
                            
                            
CRC = 101101101000000
hex -> 5B40


Notes:

- 1/30/23 
At this point, a parallel CRC calculation implementation is beyond my ability. CAN frames dont have a fixed length, there are different identifers and data field lengths. All the parallel CRC code generators I found rely on a fixed length data input, and it would not be very efficient to implement many parallel calculations for each length frame. However, CAN 2.0 frames can be upwards of 131 bits if using the extended identifer and an 8 byte data field. The crc calculation only needs the part of the frame before and including the data field (if present), but this is still a significant number of bits, and therefore clock cycles, for a serial LFSR implementation. CAN 2.0 runs at a max speed of 1 Mb/s, and the CRC delimiter is present to give some time for the nodes to calculate the CRC. a 1 Mb/s rate leaves   1 us to calculate the CRC, therefore, a 150-200 MHz clock should be sufficient to shift through all bits in the LFSR. My idea is to put in a FIFO and sample the bits as they come in. The bits would be sampled in the middle of their period, so when the last bit comes in, there is an extra 500 ns plus the 1 us delimiter to calculate the CRC. The LFSR circuit in the faster clock domain can read out the bits from the FIFO and calculate it. 
