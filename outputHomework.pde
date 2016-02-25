import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;

int xspacing = 16;   // How far apart should each horizontal location be spaced
int w;              // Width of entire wave

float theta = 0.0;  // Start angle at 0
float amplitude = 25.0;  // Height of wave
float period = 500.0;  // How many pixels before the wave repeats
float dx;  // Value for incrementing X, a function of period and xspacing
float[] yvalues;  // Using an array to store height values for the wave

int xspacing2 = 16;   // How far apart should each horizontal location be spaced
int w2;              // Width of entire wave

float theta2 = 0.0;  // Start angle at 0
float amplitude2 = 25.0;  // Height of wave
float period2 = 500.0;  // How many pixels before the wave repeats
float dx2;  // Value for incrementing X, a function of period and xspacing
float[] yvalues2;

import processing.serial.*;
import cc.arduino.*;

Arduino jane;

int ledPin = 9;
int ledPin2 = 10;
int ledPin3 = 11;
int touchSensor = 0;

void setup() {
  size(1400, 360);
  w = width+16;
  dx = (TWO_PI / period) * xspacing;
  yvalues = new float[w/xspacing];
  
  w2 = width+16;
  dx2 = (TWO_PI / period) * xspacing2;
  yvalues2 = new float[w2/xspacing2];
  
  background(0);
  smooth();
  ellipseMode(CENTER);
  
  //minim = new Minim(this);
  //hello = minim.loadFile("hello.mp3");
  
  println(Arduino.list());

  jane = new Arduino(this, Arduino.list()[2]);

  jane.pinMode(ledPin, Arduino.OUTPUT);
  jane.pinMode(ledPin2, Arduino.OUTPUT);
  jane.pinMode(ledPin3, Arduino.OUTPUT);
  jane.pinMode(touchSensor, Arduino.INPUT); 
}

void draw() {
  int analogValue =  jane.analogRead(touchSensor);
  println(analogValue);
  //int analogValue2 =  jane.analogRead(sensorPin2);
  
  if (analogValue < 200){
    background(0);
    calcWave();
    renderWave();
    jane.digitalWrite(ledPin, Arduino.LOW);
    jane.digitalWrite(ledPin2, Arduino.LOW);
    jane.digitalWrite(ledPin3, Arduino.LOW);
    delay(100);
    } else {                           
     jane.digitalWrite(ledPin, Arduino.HIGH); 
     jane.digitalWrite(ledPin2, Arduino.HIGH); 
     jane.digitalWrite(ledPin3, Arduino.HIGH); 
    }
}

void calcWave() {
  // Increment theta (try different values for 'angular velocity' here
  theta += 0.30;
  theta2 -= 0.30;

  // For every x value, calculate a y value with sine function
  float x = theta;
  for (int i = 0; i < yvalues.length; i++) {
    yvalues[i] = sin(x)*amplitude;
    x+=dx;
  }
  float x2 = theta2;
  for (int j = 0; j < yvalues2.length; j++) {
    yvalues2[j] = sin(x2)*amplitude2;
    x2+=dx2;
  }
}

void renderWave() {
  noStroke();
  fill(255, 0, 0);
  // A simple way to draw the wave with an ellipse at each location
  for (int x = 0; x < yvalues.length; x++) {
    ellipse(x*xspacing, height/2+yvalues[x], 16, 16);
  }
  
  noStroke();
  fill(255, 0, 0);
  // A simple way to draw the wave with an ellipse at each location
  for (int x2 = 0; x2 < yvalues2.length; x2++) {
    ellipse(x2*xspacing2, height/1.5+yvalues2[x2], 16, 16);
  }
}