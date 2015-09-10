PImage img, maskImg;

void setup() {
  size(100, 100);
  img = loadImage("airport.jpg");
  maskImg = loadImage("airportmask.jpg");
  img.mask(maskImg);
}

void draw() {
  background(255);
  image(img, 0, 0);
}
