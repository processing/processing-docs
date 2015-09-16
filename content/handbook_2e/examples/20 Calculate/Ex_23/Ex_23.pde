void setup() { 
  size(100, 100); 
} 
 
void draw() { 
  background(0); 
  float r = dist(width/2, height/2, mouseX, mouseY);
  ellipse(width/2, height/2, r*2, r*2);
}
