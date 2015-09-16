float cx = 33.0;  // Center x-coordinate
float cy = 66.0;  // Center y-coordinate

void setup() {
  size(100, 100);
}

void draw() {
  background(204);
  float radius = 0.15;
  float radVal = map(mouseX, 0, width, 1.05, 1.1);
  for (int deg = 0; deg < 360*5; deg += 12) {
    float angle = radians(deg);
    float x = cx + (cos(angle) * radius);
    float y = cy + (sin(angle) * radius);
    line(x, y, x, y+2);
    radius = radius * radVal;
  }
}  
