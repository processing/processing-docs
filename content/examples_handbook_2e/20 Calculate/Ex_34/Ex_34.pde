float offset = 50.0;       // Y offset
float scaleVal = 35.0;     // Scale value for the wave magnitude
float angleInc = PI/28.0;  // Increment between the next angle  

void setup() {
  size(700, 100);
  noStroke();
  fill(0);  
}

void draw() {
  background(204);
  float angle = 0.0;
  for (int x = 0; x < width; x += 5) {
    float y = offset + (sin(angle) * scaleVal);
    rect(x, y, 2, 4);
    angle += angleInc;
  }
}
