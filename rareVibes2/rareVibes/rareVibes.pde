

/**********************************************************************************
 _ _ _ _ _ 
 rareVibes
 ^ ^ ^ ^ ^ 
 
 Code to control 4 VPM2 vibrating motors, using historical data from Rare Earth stocks. 
 
 The values I will concentrate on will be the fluctuating volume of contracts
 traded relating to Molycorp's rare Earth stocks, these are ranging in their millions 
 so I willneed to map these to appropriate values so that the Arduino can activate 
 the motors in correspndence. 
 
 I am utitlising processings arduino(Firmata) library so that all the code can be
 contained within one sketch/App. 
 
 **********************************************************************************/

import processing.serial.*;
import cc.arduino.*;
import org.firmata.*;

Arduino arduino;

int i; 
int pwmSend;
float pwm;

// intialising variables for each motor.
//The frequency on most pins is ~490 Hz, (pins 5 and 6 are ~990 Hz). This means 
//that 5 and 6 may result in a value of 0 not fully turning off, so I won't be using them.
int vibe1 = 3;
int vibe2 = 9;
int vibe3 = 10;
int vibe4 = 11;

void setup() {

  println(Arduino.list()); // print a list of the available serial ports.

  //57600 refers to the bps,(bits per second) rate.
  arduino = new Arduino(this, "/dev/tty.usbmodemfd131", 57600);

  // Set the all the digital pins as outputs with a for loop.
  for (int i = 0; i <= 13; i++) {
    arduino.pinMode(i, Arduino.OUTPUT);
    arduino.analogWrite(vibe1, 0); //pin 3 grounded
  }
}


/*
Within draw I need to access the "pwmSend" data values and write them 
 to the digital~(PWM) pins 3, 9, 10, 11. The motors will run at various 
 speeds (depending on the data values,  whilst also adding delays.
 
 Notes: 
 - The frequency on most pins is ~490 Hz, (pins 5 and 6 are ~990 Hz).
 - The analogWrite function has nothing to do with the analog pins or 
 analogRead function!!
 */
void draw() {

  //load the data file into a table with the use of Processings Table class.
  //"header" means the first line of the file should be understood as header.
  Table Molycorp = loadTable("Molycorp.csv", "header");

  //a for loop to iterate through the file.
  for (int i=0; i< Molycorp.getRowCount(); i = i + 1) {

    //select the row corresponding to the counter(i).
    TableRow row = Molycorp.getRow(i);


    //look at the values in the volume collumn of the Molycorp table.
    int vol = row.getInt("volume");

    //map the "volume" values to the PWM output range.
    float pwm = map(vol, 0, 15000000, 0, 255);
    //^^ here i could do different mappings for each pin? 

    //create my final values by converting the float pwms to ints.
    int pwmSend = (int) pwm;

    //print final values to console.
    println(pwmSend);

    //constrain the value of pwmSend to not exceed a max of 180 or min of 0.
    //180 is 3.6V if Vin is 5V (Arduino Uno). The Vibrating motors run at ~3V.
    arduino.analogWrite(vibe1, constrain(pwmSend, 0, 180));

    // wait 10 milliseconds before the next loop for the analog-to-digital 
    //converter to settle after the last reading.
    delay(500);   
    arduino.analogWrite(vibe1, pwmSend); 
    delay(500); 
    arduino.analogWrite(vibe2, pwmSend);
    delay(500); 
    arduino.analogWrite(vibe3, pwmSend);
    delay(500); 
    arduino.analogWrite(vibe4, pwmSend);
    delay(500);
  }
}