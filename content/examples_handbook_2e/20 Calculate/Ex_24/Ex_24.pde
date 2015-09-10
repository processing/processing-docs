float maxDistance;

void setup() {
  size(100, 100); 
  noStroke();
  fill(0);
  maxDistance = dist(0, 0, width, height);
}

void draw() {
  background(204);
  for (int i = 0; i <= width; i += 20) {
    for (int j = 0; j <= height; j += 20) {
      float mouseDist = dist(mouseX, mouseY, i, j);
      float diameter = (mouseDist / maxDistance) * 66.0;
      ellipse(i, j, diameter, diameter);
    }
  }
}
