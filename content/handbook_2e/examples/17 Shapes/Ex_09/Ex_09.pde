PShape zig;

void setup() {
  size(100, 100);
  zig = createShape();
  zig.beginShape();
  zig.fill(0);
  zig.noStroke();
  zig.vertex(10, 0);
  zig.vertex(100, 30);
  zig.vertex(90, 70);
  zig.vertex(100, 70);
  zig.vertex(10, 90);
  zig.vertex(50, 40);
  zig.endShape();
}

void draw() {
  background(204);
  shape(zig, 0, 0);
}
