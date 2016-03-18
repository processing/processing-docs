/**
 * Reach 1 
 * based on code from Keith Peters.
 * 
 * The arm follows the position of the mouse by
 * calculating the angles with atan2(). 
 */

 
var segLength = 80;
var x, y, x2, y2;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  strokeWeight(20.0);
  stroke(255, 100);
  
  x = width/2;
  y = height/2;
  x2 = x;
  y2 = y;
}

function draw() {
  background(0);
  
  var dx = mouseX - x;
  var dy = mouseY - y;
  var angle1 = atan2(dy, dx);  
  
  var tx = mouseX - cos(angle1) * segLength;
  var ty = mouseY - sin(angle1) * segLength;
  dx = tx - x2;
  dy = ty - y2;
  var angle2 = atan2(dy, dx);  
  x = x2 + cos(angle2) * segLength;
  y = y2 + sin(angle2) * segLength;
  
  segment(x, y, angle1); 
  segment(x2, y2, angle2); 
}

function segment(x,y,a) {
  push();
  translate(x, y);
  rotate(a);
  line(0, 0, segLength, 0);
  pop();
}

