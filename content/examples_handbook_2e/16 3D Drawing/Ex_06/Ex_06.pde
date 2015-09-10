int topRadius = 70;
int bottomRadius = 70;
int tall = 120;
int sides = 32;
float angleIncrement = TWO_PI / sides;

void setup() {
  size(100, 100, P3D);
}

void draw() {
  background(0);
  if (mousePressed) {
    noFill();
    stroke(255);
  } else {
    lights();
    noStroke();
    fill(255);
  }
  translate(width/2, height/2, -40);
  rotateY(map(mouseX, 0, width, 0, PI));
  rotateZ(map(mouseY, 0, height, 0, -PI));
  float angle = 0;
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= sides; i++) {
    float ca = cos(angle);
    float sa = sin(angle);
    vertex(topRadius * ca, 0, topRadius * sa);
    vertex(bottomRadius * ca, tall, bottomRadius * sa);
    angle += angleIncrement;
  }
  endShape();
}
