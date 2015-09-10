void setup() {
  size(100, 100);
}

void draw() {
  drawX();
}

void drawX() {
  background(204);
  // Draw thick, light gray X
  stroke(160);
  strokeWeight(20);
  line(0, 5, 60, 65);
  line(60, 5, 0, 65);
}
