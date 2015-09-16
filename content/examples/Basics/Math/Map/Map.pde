/**
* Map()
*
* Using the map() function allows you to take any number,
* and scale it to a number that is more useful to the project
* that you are working on. Say you want to map mouse movement
* to the size or color (as seen above) of an object. 
* In this example, we are taking the mouse’s x position (which can 
* be between 0 and the width, 640) and we are scaling that to another
* range (40 to 300 for size, and 0 to 175 for color). 
*
*/
void setup() {
  size(640, 360);
  noStroke();
}

void draw() {
  background(0);
  // mouseX has a min of 0 and a max of 640 (the width of the window)
  // here we are scaling that variable from 0 to 640 to a number between 0 and 255
  float c = map(mouseX, 0, width, 0, 175);
  // here we are scaling that same variable to a range between 40 and 440
  float d = map(mouseX, 0, width, 40, 300);
  fill(255, c, 0);
  ellipse(width/2, height/2, d, d);   
}
