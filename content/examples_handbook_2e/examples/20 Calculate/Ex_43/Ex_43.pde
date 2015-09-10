void setup() {
  size(100, 100);
  fill(0);
}

void draw() {
  float angle = atan2(mouseY, mouseX);
  float deg = degrees(angle);
  background(204);
  text(int(deg), 50, 50);
  ellipse(mouseX, mouseY, 8, 8);
  rotate(angle);
  line(0, 0, 150, 0);
}
