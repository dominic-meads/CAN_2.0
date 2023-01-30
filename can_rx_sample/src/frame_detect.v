//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Dominic Meads
// 
// Create Date: 01/30/2023 
// Design Name: 
// Module Name: frame_detect
// Project Name: CAN_2.0
// Target Devices: 
// Tool Versions: 
// Description: Determines the SOF, then enables the data_sample module to 
//              start registering the data. 
//        
//              On Data and Remote frames, End Of Frame (EOF) and 
//              Inter-Frame Space (IFS) together consist of 11 recessive bits. 
//              On error and overload frames, the error and overload delimiters 
//              consist of 8 recessive bits, and if either are not follwed by the 
//              other (i.e. error frame followed by overload frame or vice versa),
//              a minimum of 3 recessive bits will follow. 
// 
//              In any frame type, 11 consecutive recessive bits denotes the end of 
//              a frame. This module looks for those 11 bits, and once they have been 
//              transmitted, it looks for the first dominant bit, indicating the start 
//              of another frame (SOF)
//                    
// Dependencies: 100 MHz clock, 1 Mb/s data rate
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:                    
//////////////////////////////////////////////////////////////////////////////////
