PShape k;

void setup() {
  size(600, 600, P3D);
  k = loadShape("K.svg");  // Load the file
  k = k.getChild("Path");  // Get the path data
}

void draw() {
  float ry = map(mouseY, 0, height, 0, TWO_PI);
  float d = map(mouseX, 0, width, 2, 100);

  background(0);
  lights();  
  translate(width/2, height/2);
  scale(1.5);
  rotateY(ry);
  
  noStroke();
  beginShape(QUAD_STRIP);
  for (int i = 0; i < k.getVertexCount(); i++) {
    int offset = 200;
    float x = k.getVertexX(i)-offset;
    float y = k.getVertexY(i)-offset;
    vertex(x, y, d);
    vertex(x, y, -d);
  }
  endShape();
}
