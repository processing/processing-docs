float xnoise = 0.0;
float ynoise = 0.0;
float inc = 0.05;
float yOffset = 0.0;
int gridSize = 10;

void setup() {
  size(600, 600, P3D);
  strokeWeight(2);
}

void draw() {
  background(0);

  xnoise = 0.0;
  ynoise = yOffset;

  translate(0, 120, -300);
  rotateX(0.7);

  for (int y = 0; y < 60; y++) {
    noFill();
    beginShape();
    for (int x = 0; x < 60; x++) {
      float z = noise(xnoise, ynoise) * 255.0;
      float alpha = map(y, 0, 60, 0, 255);
      stroke(255, alpha);
      vertex(x*gridSize, y*gridSize, z);
      xnoise = xnoise + inc;
    }
    xnoise = 0.0;
    ynoise = ynoise + inc;
    endShape();
  }
  
  yOffset += inc/6.0;
}
