void setup() {
  size(100, 100);
  stroke(255);
  frameRate(2);
}

void draw() {
  background(0);
  int num = int(random(50)) + 1;
  for (int i = 0; i < num; i++) {
    line(i * 2, 0, i * 2, 100);
  }
}
