void setup() {
  size(700, 100); 
}

void draw() {
  if (mousePressed == true) {
    float angle = atan2(mouseY-height/2, mouseX-width/2);
    pushMatrix();
    translate(mouseX, mouseY);
    rotate(angle);
    line(0, 0, 50, 0);
    popMatrix();
  } 
}
