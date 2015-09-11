void setup() {
  size(100, 100, P3D);
  fill(153);
  strokeWeight(8);
}

void draw() {
  background(0);
  translate(width/2, height/2, -width);
  float rx = map(mouseY, 0, height, -PI, PI);
  float ry = map(mouseX, 0, width, -PI, PI); 
  rotateX(rx);
  rotateY(ry);
  noStroke();
  rect(-50, -50, 100, 100);
  stroke(255);
  line(0, 0, -50, 0, 0, 50);
}
