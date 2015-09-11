PShape pot;

void setup() {
  size(100, 100, P3D);
  pot = loadShape("teapot.obj");
  pot.scale(12);
}

void draw() {
  background(0);
  lights();
  translate(50, 50);
  pot.rotateX(0.05);
  shape(pot, 0, 0);
}
