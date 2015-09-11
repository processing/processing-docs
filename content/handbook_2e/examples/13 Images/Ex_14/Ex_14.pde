void setup() {
  size(100, 100);
  strokeWeight(5);
  noFill();
}

void draw() {
  background(204);
  line(0, 30, 100, 60);
  filter(BLUR, 3); 
  line(0, 50, 100, 80);
}
