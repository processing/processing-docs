int x = 63;  // X-coordinate
int r = 85;  // Starting radius
int n = 5;   // Number of recursions

void setup() { 
  size(100, 100); 
  noStroke(); 
} 
 
void draw() { 
  background(204);
  drawCircle(x, r, n); 
} 
 
void drawCircle(int x, int radius, int num) {                    
  float tt = 126 * num/4.0; 
  fill(tt); 
  ellipse(x, 50, radius*2, radius*2);      
  if (num > 0) { 
    drawCircle(x - radius/2, radius/2, num-1); 
    drawCircle(x + radius/2, radius/2, num-1); 
  } 
}
