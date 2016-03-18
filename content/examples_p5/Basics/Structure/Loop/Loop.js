/**
 * Loop. 
 * 
 * The loop() function causes draw() to execute
 * continuously. If noLoop is called in setup()
 * the draw() is only executed once. In this example
 * click the mouse to execute loop(), which will
 * cause the draw() the execute continuously. 
 */

var y = 100;
 
// The statements in the setup() function 
// run once when the program begins
function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");  // Size should be the first statement
  stroke(255);     // Set stroke color to white
  noLoop();
  
  y = height * 0.5;
}

// The statements in draw() are run until the 
// program is stopped. Each statement is run in 
// sequence and after the last line is read, the first 
// line is run again.
function draw() { 
  background(0);   // Set the background to black
  line(0, y, width, y);  
  
  y = y - 1; 
  if (y < 0) { 
    y = height; 
  } 
} 

function mousePressed() {
  loop();
}
