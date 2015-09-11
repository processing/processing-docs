void setup() {
  size(100, 100);
  drawLines(5, 15);
}

void drawLines(int x, int num) {
  for (int i = 0; i < num; num -= 1) {
    line(x, 20, x, 80);
    x += 5;
  }
}
