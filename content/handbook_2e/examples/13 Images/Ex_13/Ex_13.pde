PImage img;

void setup() {
  size(100, 100);
  img = loadImage("topanga.jpg");
}

void draw() {
  image(img, 0, 0); 
  float v = mouseX / 100.0;
  filter(THRESHOLD, v); 
}
