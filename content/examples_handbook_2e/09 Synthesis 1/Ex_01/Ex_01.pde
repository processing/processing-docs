void setup() {
  size(600, 600); 
}

void draw() {   
  background(0);
  stroke(102);
  line(0, height/2, width, height/2);
  noStroke(); 
  fill(255, 204);
  int d = mouseY/2+10; // Diameter
  ellipse(mouseX, height/2, d, d);
  fill(255, 204);
  int iX = width-mouseX;   // Inverse X
  int iY = height-mouseY;  // Inverse Y
  int iD = (iY/2)+10;  // Inverse diameter
  ellipse(iX, height/2, iD, iD);
}

