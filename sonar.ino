// https://howtomechatronics.com/projects/arduino-radar-project/

/*
  Project Name: Sonar
  Author: Daniel Rodrigo
  Date: 10/10/2024

  Description: Ultrasonic Sensor Sonar
  
  Hardware:
    - Board: Arduino UNO
    - Sensor: HC-SR04 Ultrasonic Sensor
    - Actuator: Servo motor 9g
  
  Connections: 
    - Pin 10: HC-SR04 Trigger Pin
    - Pin 11: HC-SR04 Echo Pin
    - Pin 12: Servo
    
  Libraries: 
    - Servo.h
  
  Notes:
    - ...
*/

#include <Servo.h>

// Define constants
const int trigPin = 10;
const int echoPin = 11;
const int servoPin = 12;
const int rotIni = 15; // initial servo degree
const int rotEnd = 165; // final servo degree

// Declare global variables
long duration;
long distance;
Servo servo;


/*
  setup() - This function runs once when the program starts.
  It sets up the pins, initializes the serial communication, and
  performs other setup tasks.
*/
void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  Serial.begin(9600);
  servo.attach(servoPin);
}

/*
  loop() - Thus function runs continuously in a loop after setup() completes.
  It's the main part of the program that executes the logic repeatedly.
*/
void loop() {
  // Servo rotation
  servoRotation(rotIni, rotEnd);
}

/*
  servoRotation() - Rotates the servo motor

  Parameters:
    int start: Initial servo degree
    int finish: Last servo degree
  
  Returns:
    void

*/
void servoRotation(int start, int finish) {

  for (int dg=start; dg<=finish; dg++) {
    servo.write(dg);
    delay(80);

    // Calculate distance measured
    distance = calculateDistance();
    printDistance(dg, distance);
  }

  for (int dg=finish; dg<=start; dg--) {
    servo.write(dg);
    delay(80);

    // Calculate distance measured
    distance = calculateDistance();
    printDistance(dg, distance);
  }

}

/*
  calculateDistance() - Calculate distance measured from the ultrasonic sensor.

  Returns:
    int
*/
int calculateDistance() {
  
  // Short LOW pulse to ensure a clean HIGH pulse
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  // Trigger the sensor by a HIGH pulse of 10 ms.
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  // Read sound wave travel time
  duration = pulseIn(echoPin, HIGH);

  // Time - Distance conversion
  distance = (duration/2) * 0.0343; // cm

  return distance;
}

/*
  printDistance() - Print distance calculated using the measurements from the ultrasonic sensor.

  Parameters:
    int degree: Current servo degree.
    int distance: Current measured distance.
  
  Returns:
    void
*/
void printDistance(int degree, int distance) {
  Serial.print(degree);
  Serial.print(",");
  Serial.print(distance);
  Serial.print(".");
}