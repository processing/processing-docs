float threshold = 0.2;
noSmooth();
for (int y = 10; y <= 90; y+=4) {
  for (int x = 10; x <= 90; x+=4) {
    float r = random(1);
    if (r > threshold) {
      point(x, y);
    }
  } 
}

