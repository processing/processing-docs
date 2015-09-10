void setup() {
  size(100, 100);
  fill(0);
  noStroke();
}

void draw() {
  background(204);
  float scalar = map(mouseX, 0, width, 4, 20);
  float radius = 1.0;
  for (int deg = 0; deg < 360*6; deg += scalar) {
    float angle = radians(deg);
    float x = 75 + (cos(angle) * radius);
    float y = 42 + (sin(angle) * radius);
    ellipse(x, y, 4, 4);
    radius = radius + 0.34;
  }
}
