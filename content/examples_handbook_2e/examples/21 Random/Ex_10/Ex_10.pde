int numPoints = 900;
noSmooth();
for (int i = 0; i < numPoints; i++) {
  float angle = random(0, TWO_PI);
  float scalar = random(10, 40);
  float x = 50 + (cos(angle) * scalar);
  float y = 50 + (sin(angle) * scalar);
  point(x, y); 
}
