/**
 * Redraw. 
 * 
 * The redraw() function makes draw() execute once.  
 * In this example, draw() is executed once every time 
 * the mouse is clicked. 
 */
 
var y;
 
// The statements in the setup() function 
// execute once when the program begins
function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");  // Size should be the first statement
  stroke(255);     // Set line drawing color to white
  noLoop();
  y = height * 0.5;
}

// The statements in draw() are executed until the 
// program is stopped. Each statement is executed in 
// sequence and after the last line is read, the first 
// line is executed again.
function draw() { 
  background(0);   // Set the background to black
  y = y - 4; 
  if (y < 0) { y = height; } 
  line(0, y, width, y);  
} 

function mousePressed() {
  redraw();
}


