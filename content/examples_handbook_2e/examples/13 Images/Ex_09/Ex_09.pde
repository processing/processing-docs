PImage img;

void setup() {
  size(100, 100);
  img = loadImage("dwp-03.jpg");
}

void draw() {  
  background(255);   
  tint(255, 102); 
  // Draw the image 5 times, moving each to the right 
  for (int i = 0; i < 5; i++) { 
    image(img, i*20, 0); 
  }
} 
