void setup() {
  size(100, 100);
}

void draw() {  
  // Constrain to not exceed the boundary of the array
  int x = constrain(mouseX, 0, 99);
  int y = constrain(mouseY, 0, 99);
  loadPixels();
  pixels[y*width + x] = color(0);
  updatePixels();            
}
