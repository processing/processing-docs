PImage img;

void setup() {
  size(100, 100);
  // The PNG has 8-bit transparency 
  // so the edges are smooth
  img = loadImage("dwp.png");
}

void draw() {
  background(0);
  image(img, 5, 0);
  image(img, 5, 24);
}
