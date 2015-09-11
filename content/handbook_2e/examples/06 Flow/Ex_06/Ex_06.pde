float y = 0.0;

void setup() {
  size(100, 100);
  fill(0);
}

void draw() {
  background(204);
  ellipse(50, y, 70, 70);
  y = y + 0.5;
}
