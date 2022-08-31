/******************************************************************************

calculates CRC value for CAN 2.0 standard using bosch specification
and standard length identifier (pg. 13)

bosch specification: http://esd.cs.ucr.edu/webres/can20.pdf

*******************************************************************************/
#include <stdio.h>
#include <stdbool.h>

bool GEN_POLY[15] = {1,0,0,0,1,0,1,1,0,0,1,1,0,0,1}; // generator polynomial 0x4599
// init boolean array 18 bits long -- SOF, Arbitration, Control, Data, 15 zeros (bitstream length only for standard identifier length) 
int BITSTREAM_INDEX = 40;
bool BITSTREAM[41] = {0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}; 
bool CRC_REG[15] = {};  // init boolean array 15 bits long for CRC section of frame
bool CRC_NXT = 0;

int main()
{   
    if(!CRC_NXT)
    {
        CRC_NXT = BITSTREAM[BITSTREAM_INDEX] ^ CRC_REG[14];  // XOR
        BITSTREAM_INDEX--; // decrement BITSTREAM_INDEX
        
        // left shift one
        for(int i=14; i > 1; i--)
        {
            CRC_REG[i] = CRC_REG[i-1];
        }
        CRC_REG[0] = 0; // insert zero at far right of array
    }
    
    else
    {
        for(int i = 0; i < 14; i++)
        {
            CRC_REG[i] = CRC_REG[i] ^ GEN_POLY[i];
        }
    }
    
    
    // print array
    for(int i = 0; i < 14; i++)
    {
        printf("%i", CRC_REG[i] ? true : false);
    }

    return 0;
}



