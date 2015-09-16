void setup() {
  size(100, 100);
}

void draw() {
  background(204);
  float x1 = map(mouseX, 0, width, 0, 20);
  float x2 = map(mouseX, 0, width, -20, 80);
  float x3 = map(mouseX, 0, width, 20, 60);
  ellipse(x1, 25, 40, 40);
  ellipse(x2, 50, 40, 40);
  ellipse(x3, 75, 40, 40);
}
