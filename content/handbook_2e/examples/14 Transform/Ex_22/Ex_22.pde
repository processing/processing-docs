void setup() {
  size(100, 100);
  noStroke();
}

void draw() {
  background(126);
  translate(mouseX, mouseY);
  ellipse(0, 0, 33, 33);
}
