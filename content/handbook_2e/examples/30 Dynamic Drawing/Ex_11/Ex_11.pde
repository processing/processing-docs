void setup() {
  size(700, 100); 
  stroke(0, 102);
}

void draw() {
  if (mousePressed == true) {
    float weight = dist(mouseX, mouseY, pmouseX, pmouseY);
    strokeWeight(weight);
    line(mouseX, mouseY, pmouseX, pmouseY);
  }
}
