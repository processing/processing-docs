PImage img;

void setup() {
  size(100, 100);
  img = loadImage("topanga.jpg");
}

void draw() {
  background(204);
  image(img, 0, 0); 
  copy(0, 0, 100, 50, 0, 50, 100, 50); 
}
