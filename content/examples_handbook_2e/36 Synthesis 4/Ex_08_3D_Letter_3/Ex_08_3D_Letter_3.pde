PShape k;    // The letter K
PShape k3D;  // Extruded letter K

void setup() {
  size(600, 600, P3D);
  k = loadShape("K.svg");  // Load the file
  k = k.getChild("Path");  // Get the path data
  k3D = extrudeShape(k);   // Construct 3D letter
}

void draw() {
  float ry = map(mouseX, 0, width, 0, TWO_PI);
  background(0);
  lights();
  translate(width/2, height/2);
  scale(1.5);
  rotateY(ry);
  shape(k3D, 0, 0);
}

PShape extrudeShape(PShape in) {
  PShape out = createShape();
  out.beginShape(QUAD_STRIP);
  out.noStroke();
  for (int i = 0; i < in.getVertexCount(); i++) {
    int offset = 200;
    float x = in.getVertexX(i)-offset;
    float y = in.getVertexY(i)-offset;
    out.vertex(x, y, 25);
    out.vertex(x, y, -25);
  }
  out.endShape(CLOSE);
  return out;
}

