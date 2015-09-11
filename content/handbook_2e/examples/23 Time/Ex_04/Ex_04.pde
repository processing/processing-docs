void setup() {
  size(100, 100);
  noSmooth();
  stroke(255);
}

void draw() {
  background(0);
  float s = map(second(), 0, 59, 0, 99);
  float m = map(minute(), 0, 59, 0, 99);
  float h = map(hour(), 0, 23, 0, 99);
  line(s, 0, s, 33);
  line(m, 34, m, 66);
  line(h, 67, h, 100);
}
