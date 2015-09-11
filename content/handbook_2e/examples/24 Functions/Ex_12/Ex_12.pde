void setup() {
  size(600, 100);
  frameRate(4);
}

void draw() {
  background(204);
  for (int i = 0; i < 70; i++) {  // Draw 70 X shapes
    int grayValue = int(random(255));
    int thickness = int(random(30));
    int x = int(random(-50, width));
    int y = int(random(-50, height));
    drawX(grayValue, thickness, x, y, 100);
  }
}

void drawX(int gray, int weight, int x, int y, int size) {
  stroke(gray);
  strokeWeight(weight);
  line(x, y, x+size, y+size);
  line(x+size, y, x, y+size);
}
