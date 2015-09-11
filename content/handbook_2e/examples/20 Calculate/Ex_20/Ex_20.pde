void setup() { 
  size(100, 100); 
  noStroke(); 
} 

void draw() { 
  background(0); 
  // Limits variable mx between 35 and 65
  int mx = constrain(mouseX, 35, 65); 
  // Limits variable my between 40 and 60      
  int my = constrain(mouseY, 40, 60);
  fill(102); 
  rect(20, 25, 60, 50); 
  fill(255);  
  ellipse(mx, my, 30, 30); 
}
