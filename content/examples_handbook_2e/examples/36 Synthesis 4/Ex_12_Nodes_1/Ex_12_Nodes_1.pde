int x1, y1;
int x2, y2;
int radius = 50;

void setup() {
  size(300, 300);
  ellipseMode(RADIUS);
  x1 = width/2;
  y1 = width/2;
}

void draw() {
  x2 = mouseX;
  y2 = mouseY;
  background(204);
  noStroke();
  fill(0, 40);
  ellipse(x1, y1, radius, radius);
  ellipse(x2, y2, radius, radius);
  if (overlap() == true) {
    stroke(0);
    line(x1, y1, x2, y2); 
  }
}

boolean overlap() {
  float distanceFromCenters = dist(x1, y1, x2, y2);
  float diameter = radius*2;
  if (distanceFromCenters < diameter) {
    return true;
  } else {
    return false;
  }
}
