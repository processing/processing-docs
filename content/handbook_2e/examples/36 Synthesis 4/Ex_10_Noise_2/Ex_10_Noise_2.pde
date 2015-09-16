float xnoise = 0.0;
float ynoise = 0.0;
float inc = 0.05;
float yOffset = 0.0;
int gridSize = 10;

void setup() {
  size(600, 600);
}

void draw() {
  background(0);
  
  xnoise = 0.0;
  ynoise = yOffset;

  for (int y = 0; y < 60; y++) {
    for (int x = 0; x < 60; x++) {
      float n = noise(xnoise, ynoise) * 255.0;
      fill(n);
      rect(x*gridSize, y*gridSize, gridSize, gridSize);
      xnoise = xnoise + inc;
    }
    xnoise = 0.0;
    ynoise = ynoise + inc;
  }
  
  yOffset += inc/6.0;
}
