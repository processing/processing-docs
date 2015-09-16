void setup() {
  size(100, 100);
  textSize(24);
  textAlign(CENTER);
}

void draw() {
  background(204);
  text("avoid", width-mouseX, height-mouseY);
}

