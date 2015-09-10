void setup() {
  size(100, 100);
}

void draw() {
  background(204);
  // Draw thick, light gray X
  stroke(160);          
  strokeWeight(20);
  line(0, 5, 60, 65);
  line(60, 5, 0, 65);
  // Draw medium, black X
  stroke(0);            
  strokeWeight(10);
  line(30, 20, 90, 80);
  line(90, 20, 30, 80);
  // Draw thin, white X
  stroke(255);          
  strokeWeight(2);
  line(20, 38, 80, 98);
  line(80, 38, 20, 98);
}
