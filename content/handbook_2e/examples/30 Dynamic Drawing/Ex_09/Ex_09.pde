PImage alphaImg;

void setup() {
  size(100, 100);
  // This image is partially transparent
  alphaImg = loadImage("dwp.png");
  background(0);
} 

void draw() { 
  int ix = mouseX - alphaImg.width/2;
  int iy = mouseY - alphaImg.height/2;
  image(alphaImg, ix, iy);
} 
