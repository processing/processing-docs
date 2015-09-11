int u = 5;
float threshold = 0.5;
noSmooth();
for (int y = 0; y < 100; y += u) {
  for (int x = 0; x < 100; x += u) {
    float r = random(1);
    if (r > threshold) {
      line(x, y, x+u, y+u);
    } else {
      line(x, y+u, x+u, y);
    }
  } 
}
