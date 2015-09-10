PImage img; 

void setup() {
  size(100, 100);
  img = loadImage("dwp-02.jpg"); 
}

void draw() {
  tint(0, 153, 204); // Tint blue 
  image(img, 0, 0); 
  noTint(); // Disable tint 
  image(img, 50, 0); 
}
