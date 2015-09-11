
PShape pot;

void setup() {
  size(100, 100, P3D);
  pot = loadShape("teapot.obj");
}

void draw() {
  background(0);
  float scalar = 12.0; // Scalar
  shape(pot, 50, 70, pot.width*scalar, 
        pot.height*scalar);
}
