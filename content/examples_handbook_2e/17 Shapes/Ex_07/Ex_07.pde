
PShape pot;
float angle = 0.0;

void setup() {
  size(100, 100, P3D);
  pot = loadShape("teapot.obj");
}

void draw() {
  background(0);
  lights();
  translate(50, 50);
  scale(12);
  rotateX(angle);
  shape(pot, 0, 0);
  angle += 0.05;
}

