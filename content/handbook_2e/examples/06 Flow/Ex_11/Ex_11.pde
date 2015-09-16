float y = 0.0;

void draw() {
  background(204);
  line(0, y, 100, y);
  y = y + 0.5;
  if (y > height) {
    y = 0.0; 
  }
  println(y);  // Print value of y to the console
}
