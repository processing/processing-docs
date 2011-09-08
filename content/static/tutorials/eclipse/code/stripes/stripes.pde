// Daniel Shiffman
// Book 2006
// Simple while loop with interactivity

void setup() {
  size(255,255);
  background(0);
}

void draw() {
  background(0);
  // start with i as 0
  int i = 0;
  // while i is less than the width of the window
  while (i < width) {
    noStroke();
    // calculate the absolute value of the 
    // distance between i and the mouse
    float distance = abs(mouseX - i);  
    // use the distance for the fill color
    fill(distance);
    // display a rectangle at x location i
    rect(i,0,10,height);
    // increase i by 10
    i += 10;
  }
}
