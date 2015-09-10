float x, y;
float px, py;
float easing = 0.1;

void setup() {
  size(600, 100); 
  stroke(0, 102);
}

void draw() {
  float targetX = mouseX;
  float targetY = mouseY;
  x += (targetX - x) * easing;
  y += (targetY - y) * easing;
  float weight = dist(x, y, px, py);
  strokeWeight(weight);
  if (mousePressed == true) {
    line(x, y, px, py);
  }
  py = y;
  px = x;
}
