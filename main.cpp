#include "mbed.h"

extern "C" int my_leds(int value);

// Initialize LEDs
DigitalOut myled1(LED1);
DigitalOut myled2(LED2);
DigitalOut myled3(LED3);
DigitalOut myled4(LED4);

int main () {
    
    while (1){
        for (int i = 0; i <=15; i++){
        my_leds(i); //Call assembly function with every integer 0 through 15
    }
    };
}
