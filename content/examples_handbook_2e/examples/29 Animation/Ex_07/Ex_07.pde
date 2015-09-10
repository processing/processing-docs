// Save the first 50 frames
void draw() {
  background(0);
  ellipse(mouseX, 50, 40, 40);
  if (frameCount <= 50) {
    saveFrame("circles-####.tif");
  }
}
