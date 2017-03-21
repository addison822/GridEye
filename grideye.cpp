#include "grideye.h"

#include <iostream>
#include <iomanip>
#include <unistd.h>
#include <wiringPiI2C.h>

using namespace std;

int fd;

void initialGridEye(){
    
    fd = wiringPiI2CSetup(0x68);
    if(fd < 0)
        cout << "I2C Setup failed!" << endl;

}

float readAmbientTemperature(){

    unsigned char buffer[2];
    //Read lower byte
    int result = wiringPiI2CReadReg8(fd, 0x0E);
    if(result == -1)
        cout << "Read temperature failed" << endl;
    else
        buffer[0] = result;
    //Read upper byte
    result = wiringPiI2CReadReg8(fd, 0x0F);
    if(result == -1)
        cout << "Read temperature failed" << endl;
    else
        buffer[1] = result;

    //Ambient temperature data is 12bits(11bits + sign bit) 
    //and it's indicated as signed magnitude representation form
    //The resolution is 0.0625 degrees Celsius 
    unsigned short temp = 0;
    if((buffer[1] & 0b00001000) != 0){
        buffer[1] &= 0b00000111;
        temp = ((temp|buffer[1])<<8)|buffer[0];
        return -(float)temp/16;
    }
    temp = ((temp|buffer[1])<<8)|buffer[0];    
    return (float)temp/16;
}

bool readFrame(float frame[8][8]){

    unsigned char buffer[128];
    int row = 0;
    int col = 0;
    //Read data
    for(int i=0;i<128;i++){
        int result = wiringPiI2CReadReg8(fd, 0x80+i);
        if(result == -1){
            cout << "Read frame failed" << endl;
            return false;
        }

        buffer[i] = result;
        if(i%2==1){
            //Temperature data is 12bits(11bits + sign bit) 
            //and it's indicated as two's complement form
            if((buffer[i] & 0b00001000) != 0){
                buffer[i] |= 0b11111000;
            }
            unsigned short temp = 0;
            temp = ((temp|buffer[i])<<8)|buffer[i-1];
            //The resolution is 0.25 degrees Celsius
            frame[row][col] = (float)temp/4;

            col++;
            if(col%8==0){
                row++;
                col = 0;
            }
        }  
        
    }
    return true;
}
