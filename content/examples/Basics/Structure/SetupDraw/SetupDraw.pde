/**
 * Setup and Draw. 
 * 
 * The code inside the draw() function runs continuously
 * from top to bottom until the program is stopped. The
 * code in setup() is run once when the program starts.
 */

int y = 180;

// The statements in the setup() block run once 
// when the program begins
void setup() {
  size(640, 360);  // Size must be the first statement
  stroke(255);  // Set line drawing color to white
}

// The statements in draw() are run until the program 
// is stopped. Each statement is run in sequence from top 
// to bottom and after the last line is read, the 
// first line is run again.
void draw() { 
  background(0);  // Clear the screen with a black background
  line(0, y, width, y); 
  y = y - 1; 
  if (y < 0) { 
    y = height;
  }
} 
