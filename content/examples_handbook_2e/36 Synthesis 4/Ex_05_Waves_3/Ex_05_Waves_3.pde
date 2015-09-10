float curveWidth = 10.0;
float curveThickness = 10.0;
float angleOffset = 0.9;

void setup() {
  size(1200, 600);
}

void draw() {
  background(255);

  float angleIncrement = map(mouseY, 0, height, 0.0, 0.2);
  float angleA = 0.0;
  float angleB = angleA + angleOffset;

  for (int mx = 0; mx < width; mx += curveWidth*3) {
    float gray = map(mx, 0, width, 0, 255);
    noStroke();
    fill(gray);
    beginShape(QUAD_STRIP);
    for (int y = 0; y <= height; y += 10) {
      float x1 = mx + (sin(angleA)* curveWidth);
      float x2 = mx + (sin(angleB)* curveWidth);
      vertex(x1, y);
      vertex(x2 + curveThickness, y);
      angleA += angleIncrement;
      angleB = angleA + angleOffset;
    }
    endShape();
  }
}
