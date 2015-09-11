void setup() {
  size(100, 100, P3D);
  noStroke();
} 

void draw() {
  background(0);
  pointLight(255, 255, 255, width/2, mouseY, 0);
  translate(0, height/2, 0);
  sphere(30);
  translate(width, 0, 0);
  sphere(30);
}
