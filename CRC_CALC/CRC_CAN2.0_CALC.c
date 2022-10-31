/******************************************************************************

calculates CRC value for CAN 2.0 standard using bosch specification
and standard length identifier (pg. 13)

bosch specification: http://esd.cs.ucr.edu/webres/can20.pdf

*******************************************************************************/
#include <stdio.h>
#include <stdbool.h>

bool GEN_POLY[15] = {1,0,0,1, 1,0,0,1, 1,0,1,0, 0,0,1}; // generator polynomial 0x4599 (flipped--MSB at end of array in C)
// init boolean array 27 bits long -- SOF, Arbitration, Control, and Data fields (bitstream length only for standard identifier length) 
int BITSTREAM_INDEX = 26;
//                   |      DATA       |    CONTROL   |       ARBITRATION        |SOF|
bool BITSTREAM[27] = {1,0,0,0,0,0,0,0,   1,0,0,0,0,0,   0,0,0,1,0,1,0,0,0,0,0,0,   0}; 
bool CRC_REG[15] = {};  // init boolean array 15 bits long for CRC section of frame
bool CRC_NXT = 0;

int main()
{   
    for(int i = BITSTREAM_INDEX; i > 0; i--)
    {
        CRC_NXT = BITSTREAM[i] ^ CRC_REG[0];  // XOR
            
            // right shift because of inverted arrays
            for(int j = 14; j >0; j--)
            {
                CRC_REG[j] = CRC_REG[j - 1];
            }
            CRC_REG[0] = 0; // insert zero at far right of array    
        
        if(CRC_NXT == 1)
        {
            for(int k = 0; k < 15; k++)
            {
                CRC_REG[k] = CRC_REG[k] ^ GEN_POLY[k];
            }
        }
    }
    
    
    // print array
    for(int m = 15; m > 0; m--)
    {
        printf("%i", CRC_REG[m] ? true : false);
    }

    return 0;
}



