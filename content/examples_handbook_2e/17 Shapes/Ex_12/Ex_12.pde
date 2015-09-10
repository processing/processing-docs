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
  frameRate(4);
}

void draw() {
  background(204);
  color strokeVal = color(random(255));
  color fillVal = color(random(255));
  zig.setStroke(strokeVal);
  zig.setFill(fillVal);
  shape(zig, 0, 0);
}
