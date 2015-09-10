float xnoise = 0.0;
float ynoise = 0.0;
float inc = 0.05;

background(0);
noSmooth();
translate(20, 20);
for (int y = 0; y < 60; y++) {
  for (int x = 0; x < 60; x++) {
    float n = noise(xnoise, ynoise) * 255.0;
    stroke(n);
    point(x, y);
    xnoise = xnoise + inc;
  }
  xnoise = 0.0;
  ynoise = ynoise + inc;
}
