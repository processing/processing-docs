float angle = 0.0;
float speed = 0.05;

void setup() {
  size(100, 100);
  noStroke();
  fill(255, 180);
}

void draw() {
  background(0);
  float d1 = 65 + (sin(angle) * 45);
  ellipse(50, 50, d1, d1);
  float d2 = 65 + (sin(angle + QUARTER_PI) * 45);
  ellipse(50, 50, d2, d2);
  float d3 = 65 + (sin(angle + HALF_PI) * 45);
  ellipse(50, 50, d3, d3);
  angle += speed;
}
