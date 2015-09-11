void setup() {
  size(100, 100);
}

void draw() {
  background(204);
  drawX(0, 30, 40, 30, 36);
}  

void drawX(int gray, int weight, int x, int y, int size) {
  stroke(gray);
  strokeWeight(weight);
  line(x, y, x+size, y+size);
  line(x+size, y, x, y+size);
}

