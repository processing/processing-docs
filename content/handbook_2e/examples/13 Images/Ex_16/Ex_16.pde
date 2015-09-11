PImage img1, img2;

void setup() {
  size(100, 100);  
  img1 = loadImage("dwp-01.jpg");
  img2 = loadImage("dwp-01.jpg");
  img2.filter(INVERT);
}

void draw() {
 image(img1, 0, 0);
 image(img2, 50, 0);
}
