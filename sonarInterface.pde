import processing.serial.*; // Library for Serial Communication
import java.awt.event.KeyEvent; // Imports library for reading the data from the Serial PC
import java.io.IOException;

// Declare global variables
Serial serialPort; // Defines Object Serial
String angleStr = "";
String distanceStr = "";
String data="";
String noObject;
float pixelsDistance;
int angle = 0;
int distance = 0;
int idx = 0;
int maxRange = 40;
color interfaceColor = color(4,196,251);
color searchColor = color(4,196,251);
color objectColor = color(53, 53, 255);
color textColor = color(4,196,251);


/*
  setup()
*/
void setup() {
  size(1920, 1080);
  smooth();
  
  // Starts the serial communication
  serialPort = new Serial(this, "COM4", 9600);
  
  // Reads data from the serial port
  serialPort.bufferUntil('.'); // Up to the character '.'
}

/*
  draw() - Draw sonar interface
*/
void draw() {
  // Motion blur & Slow fade
  noStroke();
  fill(0,6);
  rect(0, 0, width, 1010);
  
  // Draw sonar reticule
  drawSonar();
  drawLine();
  drawObject();
  drawText();
}

/*
  serialEvent() - Reads data from the Serial Port
  
  Prameters:
    Serial serialPort: Serial port assigned to serial communication
*/
void serialEvent (Serial serialPort) {
  // Read data strings
  data = serialPort.readStringUntil('.');
  //text(data, 240, 800);
  data = data.substring(0, data.length() - 1);
  idx = data.indexOf(",");
  angleStr = data.substring(0, idx);
  distanceStr = data.substring(idx+1, data.length());
  
  // Data conversion
  angle = int(angleStr);
  distance = int(distanceStr);
}

/*
  drawSonar() - Draw sonar grid
*/
void drawSonar() {
  pushMatrix();
  
  // Starting coords
  translate(960, 1000);
  noFill();
  strokeWeight(6);
  stroke(interfaceColor);

  // Update arc lines dimension
  for (int dim = 450; dim <= 1800; dim += 450) {
    arc(0, 0, dim, dim, PI, TWO_PI);
  }
  
  // Update angle lines
  line(-960, 0, 960, 0);
   for (int ang = 30; ang <= 150; ang += 30) {
    line(0,0,-960*cos(radians(ang)),-960*sin(radians(ang)));
  }
  line(-960*cos(radians(30)), 0, 960, 0);
  
  // Inner Grid
  strokeWeight(2);

  // Update arc lines dimension
  for (int dim = 225; dim <= 1605; dim += 450) {
    arc(0, 0, dim, dim, PI, TWO_PI);
  }
  
  // Update angle lines
  line(-960, 0, 960, 0);
   for (int ang = 15; ang <= 165; ang += 30) {
    line(0,0,-960*cos(radians(ang)),-960*sin(radians(ang)));
  }
  line(-960*cos(radians(30)), 0, 960, 0);
  
  popMatrix();
}


/*
  drawObject() - Draw object detection
*/
void drawObject() {
  pushMatrix();
  
  translate(960,1000); // origin
  strokeWeight(9);
  stroke(objectColor);
  pixelsDistance = distance * 22.5;
  
  // Object detected
  if (distance <= maxRange) {
    line(pixelsDistance*cos(radians(angle)),-pixelsDistance*sin(radians(angle)),950*cos(radians(angle)),-950*sin(radians(angle)));
  }
  
  popMatrix();
}

/*
  drawLine() - Draw searching line
*/
void drawLine() {
  pushMatrix();
 
  strokeWeight(9);
  stroke(searchColor);
  // Starting coords new location
  translate(960,1000);
  line(0,0,950*cos(radians(angle)),-950*sin(radians(angle)));

  popMatrix();
}

/*
  drawText() - Draw sonar interface information panel
*/
void drawText() {
  pushMatrix();
  
  if (distance > 30) {
    noObject = "Out of Range";
  } else {
    noObject = "Object Detected";
  }
  
  fill(0, 6);
  noStroke();
  rect(0, 1010, width, 1080);
  fill(textColor);
  textSize(25);
  
  
  text("10cm",1160,1040);
  text("20cm",1380,1040);
  text("30cm",1600,1040);
  text("40cm",1820,1040);
 
  text("40cm",40,1040);
  text("30cm",260,1040);
  text("20cm",480,1040);
  text("10cm",700,1040);
 
  textSize(30);
  text("Object:     " + noObject, 50, 50);
  text("Angle:       " + angle, 50, 80);
  text("                            º", 50, 80);
  text("Distance: ", 50, 110);
  if (distance < maxRange) {
    text("                    " + distance + " cm", 50, 110);
  }

  
  textSize(25);
  fill(interfaceColor);
  
  
  translate(961+960*cos(radians(30)),982-960*sin(radians(30)));
  rotate(-radians(-60));
  text("30°",0,0);
  resetMatrix();
  translate(954+960*cos(radians(60)),984-960*sin(radians(60)));
  rotate(-radians(-30));
  text("60°",0,0);
  resetMatrix();
  translate(945+960*cos(radians(90)),990-960*sin(radians(90)));
  rotate(radians(0));
  text("90°",0,0);
  resetMatrix();
  translate(935+960*cos(radians(120)),1003-960*sin(radians(120)));
  rotate(radians(-30));
  text("120°",0,0);
  resetMatrix();
  translate(940+960*cos(radians(150)),1018-960*sin(radians(150)));
  rotate(radians(-60));
  text("150°",0,0);

  popMatrix();
}
