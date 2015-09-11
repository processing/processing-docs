float y = 0.0;

void draw() {
  background(y * 2.5);
  line(0, y, 100, y);
  y = y + 0.5;
}
