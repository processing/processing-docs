PShape dino;

void setup() {
  size(480, 120);
  dino = createShape();
  dino.beginShape();
  dino.fill(153, 176, 180);
  dino.vertex(50, 120);
  dino.vertex(100, 90);
  dino.vertex(110, 60);
  dino.vertex(80, 20);
  dino.vertex(210, 60);
  dino.vertex(160, 80);
  dino.vertex(200, 90);
  dino.vertex(140, 100);
  dino.vertex(130, 120);
  dino.endShape();
}

void draw() {
  background(204);
  translate(mouseX - 120, 0);
  shape(dino, 0, 0);
}