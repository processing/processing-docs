float offset = 126.0; 
float scaleVal = 126.0;
float angleInc = 0.2;

void setup() {
  size(700, 100);
}

void draw() {
  float angle = 0.0;
  for (int x = -52; x < width; x += 1) {
    float y = offset + (sin(angle) * scaleVal);
    stroke(y);
    line(x, 0, x+50, height);
    angle += angleInc;
  }
}
