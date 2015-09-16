void setup() {
  size(240, 120);
  strokeWeight(12);
}

void draw() {
  background(204);
  stroke(102);
  line(mouseX, 0, mouseX, height); // Gray line
  stroke(0);
  float mx = mouseX/2 + 60;
  line(mx, 0, mx, height); // Black line
}