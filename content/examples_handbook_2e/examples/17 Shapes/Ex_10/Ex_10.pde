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
  zig.scale(0.7);
  zig.translate(-50, -50);
}

void draw() {
  background(204);
  shape(zig, 50, 50);
  zig.rotate(0.01);
}
