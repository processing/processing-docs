float inc = 0.0;

void setup() {
  size(100, 100);
  stroke(255, 204);
}

void draw() {
  background(0);
  float angle = sin(inc)/10.0 + sin(inc*1.2)/20.0;
  tail(18, 9, angle/1.3);
  tail(33, 12, angle);
  tail(44, 10, angle/1.3);
  tail(62, 5, angle);
  tail(88, 7, angle*2);
  inc += 0.01;
}

void tail(int xpos, int units, float angle) {
  pushMatrix();
  translate(xpos, 0);
  for (int i = units; i > 0; i--) {  // Count in reverse
    strokeWeight(i);
    line(0, 0, 0, 8);
    translate(0, 8);
    rotate(angle);
  }
  popMatrix();
}
