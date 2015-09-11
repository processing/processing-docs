PImage img; 
color yellow, green, tan;

void setup() {
  size(100, 100);
  img = loadImage("dwp-02.jpg");
  yellow = color(220, 214, 41);
  green = color(110, 164, 32);
  tan = color(180, 177, 132); 
}

void draw() {
  tint(yellow);  
  image(img, 0, 0); 
  tint(green); 
  image(img, 33, 0); 
  tint(tan); 
  image(img, 66, 0); 
}
