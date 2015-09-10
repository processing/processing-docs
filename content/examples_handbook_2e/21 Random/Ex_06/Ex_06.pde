void setup() {
  size(100, 100);
  stroke(255);
  frameRate(2);
}

void draw() {
  background(0);
  float r = random(100);
  if (r < 50.0) {
    line(0, 0, 100, 100);
  } else {
    ellipse(50, 50, 75, 75);
  }
}
