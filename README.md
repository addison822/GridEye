## GridEye

This is a simple C++ library for "GridEye" IR sensor to read thermal imaging on Raspberry Pi.

## Prerequisites

1. Because this library is based on [wiringPi](https://github.com/WiringPi/WiringPi) Project, so you need to install it first.

   * http://wiringpi.com/download-and-install/

2. Ensure I2C Interface is enabled on RPi.


3. The connections between GridEye and RPi is as follows:
 
    |  GridEye  |  RPi  |
    |   :----:  | :---: |
    |    VDD    |  3.3V |
    |    GND    |  GND  |
    |    SCL    |  SCL  |
    |    SDA    |  SDA  |
    |    INT    |       |
    | AD_SELECT |  GND  |

## Install

```bash
$ git clone https://github.com/addison822/GridEye
$ cd GridEye/
```

  * For dynamic library
  ```bash
  $ sudo make install
  ```
  * For static library
  ```bash
  $ sudo make install-static
  ```
  
## Usage

* test.cpp

```c++
#include <grideye.h>
   
float frame[8][8];
   
int main(){

    inttialGridEye();
       
    readFrame(frame);
       
    return 0;
}
```

* Compile

```bash
$ g++ test.cpp -lwiringPi -lgrideye -o test
```

## Uninstall

```bash
$ cd GridEye/
$ make uninstall
```
