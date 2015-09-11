import processing.sound.*;

SinOsc sine;
float freq = 400;

void setup() {
  size(440, 440);
  // Create and start the sine oscillator
  sine = new SinOsc(this);
  sine.play();
}

void draw() {
  background(176, 204, 176);
  // Map the mouseX value from 20Hz to 440Hz for frequency
  float hertz = map(mouseX, 0, width, 20.0, 440.0);
  sine.freq(hertz);
  // Draw a wave to visualize the frequency of the sound
  stroke(26, 76, 102);
  for (int x = 0; x < width; x++) {
    float angle = map(x, 0, width, 0, TWO_PI * hertz);
    float sinValue = sin(angle) * 120;
    line(x, 0, x, height/2 + sinValue);
  }
}