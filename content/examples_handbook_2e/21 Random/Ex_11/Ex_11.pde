int d = 2;
noSmooth();
for (int y = 10; y <= 90; y+=4) {
  for (int x = 10; x <= 90; x+=4) {
    float dx = random(-d, d);
    float dy = random(-d, d);
    point(x+dx, y+dy);
  } 
}
