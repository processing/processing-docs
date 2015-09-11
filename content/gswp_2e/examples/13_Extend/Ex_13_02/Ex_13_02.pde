import processing.sound.*;

AudioIn mic;
Amplitude amp;

void setup() {
  size(440, 440);
  background(0);
  // Create an audio input and start it
  mic = new AudioIn(this, 0);
  mic.start();
  // Create a new amplitude analyzer and patch into input
  amp = new Amplitude(this);
  amp.input(mic);
}

void draw() {
  // Draw a background that fades to black
  noStroke();
  fill(26, 76, 102, 10);
  rect(0, 0, width, height);
  // The analyze() method returns values between 0 and 1,
  // so map() is used to convert the values to larger numbers
  float diameter = map(amp.analyze(), 0, 1, 10, width);
  // Draw the circle based on the volume
  fill(255);
  ellipse(width/2, height/2, diameter, diameter);
}