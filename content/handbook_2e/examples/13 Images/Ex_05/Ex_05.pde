PImage img; 

void setup() {
  size(100, 100);
  img = loadImage("dwp-02.jpg"); 
}

void draw() {
  tint(102); // Tint gray
  image(img, 0, 0); 
  noTint(); // Disable tint 
  image(img, 50, 0); 
}

