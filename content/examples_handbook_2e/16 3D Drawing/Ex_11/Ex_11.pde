void setup() {
  size(100, 100, P3D);
  noStroke();
} 

void draw() {
  background(0);
  float angle = map(mouseY, 0, height, PI/8, PI/2);
  float concentration = map(mouseX, 0, width, 1, 20);
  spotLight(255, 255, 255, 0, height/2, 0, 
            1, 0, 0, angle, concentration);
  translate(width, height/2, -10);
  sphere(50);
}
