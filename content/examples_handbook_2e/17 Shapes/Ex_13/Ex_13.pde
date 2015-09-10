PShape zig;

void setup() {
  size(100, 100);
  zig = createShape();
  zig.beginShape();
  zig.fill(0);
  zig.vertex(10, 0);
  zig.vertex(100, 30);
  zig.vertex(90, 70);
  zig.vertex(100, 70);
  zig.vertex(10, 90);
  zig.vertex(50, 40);
  zig.endShape(CLOSE);
}

void draw() {
  background(204);
  for (int i = 0; i < zig.getVertexCount(); i++) {
    float x = zig.getVertexX(i);
    float y = zig.getVertexY(i);
    x += random(-1, 1);
    y += random(-1, 1);
    zig.setVertex(i, x, y);
  }
  shape(zig, 0, 0);
}
