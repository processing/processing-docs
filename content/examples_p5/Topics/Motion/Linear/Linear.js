/**
 * Linear Motion. 
 * 
 * Changing a variable to create a moving line.  
 * When the line moves off the edge of the window, 
 * the variable is set to 0, which places the line
 * back at the bottom of the screen. 
 */
 
var a;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  stroke(255);
  a = height/2;
}

function draw() {
  background(51);
  line(0, a, width, a);  
  a = a - 0.5;
  if (a < 0) { 
    a = height; 
  }
}
