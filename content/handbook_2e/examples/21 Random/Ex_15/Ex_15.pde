float v = 0.0;
float inc = 0.1;

void setup() {
  size(700, 100);
  noStroke();
  fill(0);
  noiseSeed(0);
  noLoop();
}

void draw() {
  for (int i = 0; i < width; i = i+4) {
    float n = noise(v) * 70.0;
    rect(i, 10 + n, 3, 20);
    v = v + inc;
  }
}
