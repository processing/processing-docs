void setup() {
  size(100, 100, P3D);
  fill(204);
  strokeWeight(2);
}

void draw() {
  lights();
  background(0);
  // Change height of the camera with mouseY
  camera(0.0, mouseY*2, 120.0, // eyeX, eyeY, eyeZ
         0.0, 0.0, 0.0, // centerX, centerY, centerZ
         0.0, 1.0, 0.0); // upX, upY, upZ
  noStroke();
  box(60);
  stroke(255);
  line(-80, 0, 0, 80, 0, 0);
  line(0, -80, 0, 0, 80, 0);
  line(0, 0, -80, 0, 0, 80);
}
