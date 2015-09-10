PShape k;

void setup() {
  size(600, 600);
  k = loadShape("K.svg");  // Load the file
  k = k.getChild("Path");  // Get the path data
}

void draw() {
  background(204);
  strokeWeight(2);
  noFill();
  translate(width/2, height/2);
  scale(1.5);
  beginShape();
  for (int i = 0; i < k.getVertexCount(); i++) {
    int offset = 200;
    float x = k.getVertexX(i)-offset;
    float y = k.getVertexY(i)-offset;
    vertex(x, y);
  }
  endShape();
}
