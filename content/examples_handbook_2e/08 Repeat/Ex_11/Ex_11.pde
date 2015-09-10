void setup() {
  size(100, 100); 
  strokeWeight(2);
}

void draw() {
  background(204);
  // Draw more lines as mouseX increases
  for (int i = 10; i < mouseX; i+=5) {
    line(i, 10, i, 90);
  }
}
