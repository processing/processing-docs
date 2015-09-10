PImage img;

void setup() {
  size(100, 100);
  // The GIF has 1-bit transparency 
  // so the edges are rough
  img = loadImage("dwp.gif");
}

void draw() {
  background(0);
  image(img, 5, 0);
  image(img, 5, 24);
}
