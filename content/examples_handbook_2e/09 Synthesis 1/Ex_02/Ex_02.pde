void setup() {
  size(600, 600);
  strokeWeight(2);
  noCursor();
}

void draw() {
  background(102);
  
  noStroke();
  fill(0);
  rect(150, 150, 300, 300);

  stroke(255);  
  if ((mouseX > 150) && (mouseX < 450) && 
      (mouseY > 150) && (mouseY < 450)) {
    line(0, 0, 150, 150);      // Upper-left
    line(600, 0, 450, 150);    // Upper-right
    line(450, 450, 600, 600);  // Lower-right
    line(0, 600, 150, 450);    // Lower-left
  } else {
    line(150, 150, 450, 450);  // Upper-left to lower-right
    line(150, 450, 450, 150);  // Lower-left to upper-right
  }
  
  noStroke();
  fill(0);
  ellipse(mouseX, mouseY, 12, 12);
}
