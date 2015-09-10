PGraphics circle;

void setup() {
  size(100, 100);
  circle = createGraphics(100, 100);
}

void draw() {
  circle.beginDraw();
  circle.background(0);
  circle.ellipse(50, 50, 75, 75);
  circle.endDraw();
  image(circle, 0, 0);
}
