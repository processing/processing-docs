int clickX, clickY;

void setup() {
  size(700, 100); 
}

void draw() {
  if (mousePressed == true) {
    float angle = atan2(mouseY-clickY, mouseX-clickX);
    pushMatrix();
    translate(mouseX, mouseY);
    rotate(angle);
    line(0, 0, 50, 0);
    popMatrix();
  } 
}

void mousePressed() {
  clickX = mouseX;
  clickY = mouseY; 
}
