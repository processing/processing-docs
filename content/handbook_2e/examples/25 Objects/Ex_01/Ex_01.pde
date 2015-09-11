float x = 33;
float y = 50;
float diameter = 30;
 
void setup() { 
  size(100, 100);
  noStroke(); 
} 
 
void draw() { 
  background(0); 
  ellipse(x, y, diameter, diameter);
}
