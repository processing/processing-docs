PImage img;

void setup() {
  size(100, 100);
  img = loadImage("dwp-01.jpg"); 
}

void draw() {
  imageMode(CORNER); 
  image(img, 40, 40, 60, 60);
  imageMode(CENTER); 
  image(img, 40, 40, 60, 60);
}
