PGraphics cubeA;
PGraphics cubeB;

void setup() {
  size(200, 200, P3D);
  cubeA = createGraphics(width, height, P3D);
  cubeB = createGraphics(width, height, P3D);
}

void draw() {
  background(0);
  drawCube(cubeA, 100, 200);
  drawCube(cubeB, 150, 250);
  float alphaA = map(mouseX, 0, width, 0, 255);
  float alphaB = map(mouseY, 0, height, 0, 255);
  tint(255, alphaA);
  image(cubeA, 0, 0);
  tint(255, alphaB);
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
