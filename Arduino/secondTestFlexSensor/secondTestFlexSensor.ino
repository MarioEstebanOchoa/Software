#include <SimpleKalmanFilter.h>
/******************************************************************************
Flex_Sensor_Example.ino
Example sketch for SparkFun's flex sensors
  (https://www.sparkfun.com/products/10264)
Jim Lindblom @ SparkFun Electronics
April 28, 2016

Create a voltage divider circuit combining a flex sensor with a 47k resistor.
- The resistor should connect from A0 to GND.
- The flex sensor should connect from A0 to 3.3V
As the resistance of the flex sensor increases (meaning it's being bent), the
voltage at A0 should decrease.

Development environment specifics:
Arduino 1.6.7
******************************************************************************/
const int FLEX_PIN1 = A0; // Pin connected to voltage divider output
const int FLEX_PIN2 = A1; // Pin connected to voltage divider output
const int FLEX_PIN3 = A2; // Pin connected to voltage divider output

SimpleKalmanFilter simpleKalmanFilter(1, 1, 2);
//#define SERIAL_BUFFER_SIZE 1


void setup() 
{
  Serial.begin(9600);
  pinMode(FLEX_PIN1, INPUT);
  pinMode(FLEX_PIN2, INPUT);
  pinMode(FLEX_PIN3, INPUT);
  
}

void loop() 
{
  // Read the ADC, and calculate voltage and resistance from it
  float flexADC1 = analogRead(FLEX_PIN1); 
  //int flexADC2 = analogRead(FLEX_PIN2);
  //int flexADC3 = analogRead(FLEX_PIN3);
  float real_value = flexADC1/1024.0 * 100.0;
  float measured_value = real_value;
  float estimated_value = simpleKalmanFilter.updateEstimate(measured_value);

  Serial.print(real_value);      //the first variable for plotting
  Serial.print(",");              //seperator
//  Serial.print(measured_value);          //the second variable for plotting including line break
//  Serial.print(","); 
  Serial.println(estimated_value);
  delay(10);
}
