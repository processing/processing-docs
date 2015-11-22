/**
 * Moving On Curves. 
 * 
 * In this example, the circles moves along the curve y = x^4.
 * Click the mouse to have it move to a new position.
 */

var beginX = 20.0;  // Initial x-coordinate
var beginY = 10.0;  // Initial y-coordinate
var endX = 570.0;   // Final x-coordinate
var endY = 320.0;   // Final y-coordinate
var distX;          // X-axis distance to move
var distY;          // Y-axis distance to move
var exponent = 4;   // Determines the curve
var x = 0.0;        // Current x-coordinate
var y = 0.0;        // Current y-coordinate
var step = 0.01;    // Size of each step along the path
var pct = 0.0;      // Percentage traveled (0.0 to 1.0)

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  noStroke();
  distX = endX - beginX;
  distY = endY - beginY;
}

function draw() {
  fill(0, 2);
  rect(0, 0, width, height);
  pct += step;
  if (pct < 1.0) {
    x = beginX + (pct * distX);
    y = beginY + (pow(pct, exponent) * distY);
  }
  fill(255);
  ellipse(x, y, 20, 20);
}

function mousePressed() {
  pct = 0.0;
  beginX = x;
  beginY = y;
  endX = mouseX;
  endY = mouseY;
  distX = endX - beginX;
  distY = endY - beginY;
}
