PGraphics cube;

void setup() {
  size(100, 100);
  cube = createGraphics(width, height, P3D);  // Error
}

void draw() {
  cube.beginDraw();
  cube.box(40);
  cube.endDraw();
  image(cube, 0, 0);
}
