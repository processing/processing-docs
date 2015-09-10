int power = 8;
int numPoints = 4000;
noSmooth();
for (int i = 0; i < numPoints; i++) {
  float x = random(20, 80);
  float y = random(1);
  y = 10 + (pow(y, power) * 80);
  point(x, y); 
}
