PImage img;

void setup() {
  size(100, 100);
  img = loadImage("dwp-03.jpg"); 
}

void draw() { 
  background(255);
  tint(255, 102);  // Alpha 102 without changing the tint 
  image(img, 0, 0, 100, 100); 
  tint(255, 102, 0, 204);  // Tint orange, alpha to 204 
  image(img, 20, 20, 100, 100);
} 
