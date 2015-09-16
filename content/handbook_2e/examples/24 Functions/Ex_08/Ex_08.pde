void setup() {
  size(100, 100);
}

void draw() {
  background(204);
  drawX(0, 30);  // Passes values to drawX(), runs drawX()
}

void drawX(int gray, int weight) {
  stroke(gray);
  strokeWeight(weight);
  line(0, 5, 60, 65);
  line(60, 5, 0, 65);
}
