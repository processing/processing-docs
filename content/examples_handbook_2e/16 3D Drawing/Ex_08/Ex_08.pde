void setup() {
  size(100, 100, P3D);
  noStroke();
}

void draw() {
  background(0);
  if (mousePressed == true) {
    directionalLight(255, 255, 255, 0, 1, 0);
  } else {
    directionalLight(255, 255, 255, 1, 0, 0);
  }
  translate(width/2, height/2, 0);
  sphere(30);
}
