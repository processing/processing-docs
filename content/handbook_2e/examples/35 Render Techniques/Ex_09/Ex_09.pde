PGraphics cubeA;
PGraphics cubeB;

void setup() {
  size(200, 200, P3D);
  cubeA = createGraphics(width, height, P3D);
  cubeB = createGraphics(width, height, P3D);
}

void draw() {
  background(0);
  drawCubeA();
  drawCubeB();
  float alphaA = map(mouseX, 0, width, 0, 255);
  float alphaB = map(mouseY, 0, height, 0, 255);
  tint(255, alphaA);
  image(cubeA, 0, 0);
  tint(255, alphaB);
  image(cubeB, 0, 0);
}

void drawCubeA() {
  cubeA.beginDraw();
  cubeA.lights();
  cubeA.clear();
  cubeA.noStroke();
  cubeA.translate(width/2, height/2);
  cubeA.rotateX(frameCount/100.0);
  cubeA.rotateY(frameCount/200.0);
  cubeA.box(80);
  cubeA.endDraw();
}

void drawCubeB() {
  cubeB.beginDraw();
  cubeB.lights();
  cubeB.clear();
  cubeB.noStroke();
  cubeB.translate(width/2, height/2);
  cubeB.rotateX(frameCount/150.0);
  cubeB.rotateY(frameCount/250.0);
  cubeB.box(80);
  cubeB.endDraw();
}
