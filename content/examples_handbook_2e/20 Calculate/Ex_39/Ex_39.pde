int radius = 38;
  
void setup() {
  size(100, 100);
  fill(0);
}

void draw() {
  background(204);
  for (int deg = 0; deg < 360; deg += 12) {
    float angle = radians(deg);
    float x = 50 + (cos(angle) * radius);
    float y = 50 + (sin(angle) * radius);
    ellipse(x, y, 4, 4);
  }
}
