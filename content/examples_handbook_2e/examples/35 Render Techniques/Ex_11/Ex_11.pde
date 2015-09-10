PGraphics cubeA;
PGraphics cubeB;

void setup() {
  size(200, 200, P3D);
  cubeA = createGraphics(width, height, P3D);
  cubeB = createGraphics(width, height, P3D);
  blendMode(DARKEST);
}

void draw() {
  background(255);
  drawCube(cubeA, 100, 200);
  drawCube(cubeB, 150, 250);
  image(cubeA, 0, 0);
  image(cubeB, 0, 0);
}

void drawCube(PGraphics cube, float xd, float yd) {
  cube.beginDraw();
  cube.lights();
  cube.clear();
  cube.noStroke();
  cube.translate(cube.width/2, cube.height/2);
  cube.rotateX(frameCount/xd);
  cube.rotateY(frameCount/yd);
  cube.box(80);
  cube.endDraw();
}
