float curveWidth = 30.0;
float curveThickness = 50.0;
float angleOffset = 0.9;

void setup() {
  size(200, 600);
  noFill();
  stroke(0);
}

void draw() {
  background(255);

  float angleIncrement = map(mouseY, 0, height, 0.0, 0.1);
  float angleA = 0.0;
  float angleB = angleA + angleOffset;

  beginShape(QUAD_STRIP);
  for (int y = 0; y <= height; y += 10) {
    float x1 = width/2 + (sin(angleA)* curveWidth);
    float x2 = width/2 + (sin(angleB)* curveWidth);
    vertex(x1, y);
    vertex(x2 + curveThickness, y);
    angleA += angleIncrement;
    angleB = angleA + angleOffset;
  }
  endShape();
}
