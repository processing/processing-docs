PImage img; 

void setup() {
  size(100, 100);
  // Image must be in the sketch's "data" folder 
  img = loadImage("dwp-01.jpg"); 
}

void draw() {
  image(img, 20, 20, 60, 60); 
}
