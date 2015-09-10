PImage img;

void setup() {
  size(100, 100);
  img = loadImage("airport.jpg");
}

void draw() {
  img.copy(50, 0, 50, 100, 0, 0, 50, 100); 
  image(img, 0, 0);
}
