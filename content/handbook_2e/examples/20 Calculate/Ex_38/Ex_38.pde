float scaleVal = 6.0;
float angleInc = 0.19;

void setup() {
  size(700, 100);
  stroke(255);
}

void draw() {
  background(0);
  float angle = 0.0;
  for (int offset = -10; offset < width+10; offset += 5) {
    for (int y = 0; y <= height; y += 2) {
      float x = offset + (sin(angle) * scaleVal);
      line(x, y, x, y+2);
      angle += angleInc;
    }
    angle += PI;
  }
}

