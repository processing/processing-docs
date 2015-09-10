import processing.sound.*;

SoundFile blip;
int radius = 120;
float x = 0;
float speed = 1.0;
int direction = 1;

void setup() {
  size(440, 440);
  ellipseMode(RADIUS);
  blip = new SoundFile(this, "blip.wav");
  x = width/2; // Start in the center
}

void draw() {
  background(0);
  x += speed * direction;
  if ((x > width-radius) || (x < radius)) {
    direction = -direction; // Flip direction
    blip.play();
  }
  if (direction == 1) {
    arc(x, 220, radius, radius, 0.52, 5.76); // Face right
  } else {
    arc(x, 220, radius, radius, 3.67, 8.9); // Face left
  }
}