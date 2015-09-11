int gap = 20;  // Distance between arcs
int thickness = 2;  // Thickness of each arc 

void setup() {
  size(600, 600);
  noFill();
  strokeWeight(thickness);
  stroke(0);
}

void draw() {
  background(255);
  float arcLength = mouseX / 95.0;
  for (int i = gap; i < width-gap; i += gap) {
    float angle = radians(i);
    arc(width/2, height/2, i, i, angle, angle + arcLength);
  }
}
