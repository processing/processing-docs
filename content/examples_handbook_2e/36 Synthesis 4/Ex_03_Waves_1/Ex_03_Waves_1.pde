float curveWidth = 30.0;
float curveThickness = 50.0; 

void setup() {
  size(200, 600);
  noFill();
  stroke(0);
}

void draw() {
  background(255);

  float angleIncrement = map(mouseY, 0, height, 0.0, 0.1);
  float angle = 0.0;

  beginShape(QUAD_STRIP);
  for (int y = 0; y <= height; y += 10) {
    float x = width/2 + (sin(angle)* curveWidth);
    vertex(x, y);
    vertex(x + curveThickness, y);
    angle += angleIncrement;
  }
  endShape();
}
