float x = 20.0;       // Initial x-coordinate
float y = 10.0;       // Initial y-coordinate
float endX = 70.0;    // Destination x-coordinate
float endY = 80.0;    // Destination y-coordinate
float easing = 0.05;  // Size of each step along the path

void setup() {
  size(100, 100);
  noStroke();
}

void draw() { 
  fill(0, 12);
  rect(0, 0, width, height);
  float d = dist(x, y, endX, endY);
  if (d > 1.0) {
    x += (endX - x) * easing;
    y += (endY - y) * easing;
  }
  fill(255);
  ellipse(x, y, 20, 20);
}
