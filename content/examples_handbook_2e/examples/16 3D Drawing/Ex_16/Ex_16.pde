PImage tex;

void setup() {
  size(100, 100, P3D);
  tex = loadImage("dwp-parallel.png");
  noStroke();
}

void draw() {
  background(0);
  translate(0, 0, -height/4);
  float ry = map(mouseX, 0, width, 0, TWO_PI); 
  rotateY(ry);
  beginShape();
  texture(tex);
  vertex(0, 6, 0, 0, 12);
  vertex(100, 45, 0, 200, 90);
  vertex(100, 80, 0, 200, 160);
  vertex(0, 44, 0, 0, 88);
  endShape(); 
}
