void setup() {
  size(100, 100, P3D);
  noStroke();
} 

void draw() {
  background(0);
  lights(); // Default lights
  // The sphere is white by default so 
  // the ambient light changes the color
  float r = map(mouseX, 0, width, 0, 255);
  ambient(r, r, 126);
  translate(width/2, height/2, 0);
  sphere(33);
}
