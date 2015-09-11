PImage tex;

void setup() {
  size(100, 100, P3D);
  tex = loadImage("dwp-parallel.png");
  noStroke();
  textureMode(NORMAL);
}

void draw() {
  background(0);
  translate(0, 0, -height/4);
  float ry = map(mouseX, 0, width, 0, TWO_PI); 
  rotateY(ry);
  beginShape();
  texture(tex);
  vertex(0, 0, 0, 0, 0);
  vertex(100, 0, 0, 1, 0);
  vertex(100, 100, 0, 1, 1);
  vertex(0, 100, 0, 0, 1);
  endShape(); 
}
