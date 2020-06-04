/**
 * No Loop. 
 * 
 * The noLoop() function causes draw() to only run once. 
 * Without calling noLoop(), the code inside draw() is 
 * run continually. 
 */

float y = 180;

// The statements in the setup() block 
// run once when the program begins
void setup() {
  size(640, 360);  // Size should be the first statement
  stroke(255);  // Set line drawing color to white
  noLoop();
}

// In this example, the code in the draw() block 
// runs only once because of the noLoop() in setup()
void draw() { 
  background(0);   // Set the background to black
  line(0, y, width, y);  
  y = y - 1; 
  if (y < 0) { y = height; } 
} 
