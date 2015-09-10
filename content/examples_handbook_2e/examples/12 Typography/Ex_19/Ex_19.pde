float x = 33; 
float y = 60;
  
void setup() {
  size(100, 100);
  textSize(24);
  noStroke();
}

void draw() {
  fill(204, 120);
  rect(0, 0, width, height);
  fill(0);
  // If the cursor is over the text, change the position 
  if ((mouseX >= x) && (mouseX <= x+55) && 
      (mouseY >= y-24) && (mouseY <= y)) {
    x += random(-2, 2);
    y += random(-2, 2);
  }
  text("tickle", x, y);
}
