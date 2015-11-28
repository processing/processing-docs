/**
 * Follow 1  
 * based on code from Keith Peters. 
 * 
 * A line segment is pushed and pulled by the cursor.
 */

var x = 100;
var y = 100;
var angle1 = 0.0;
var segLength = 50;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  strokeWeight(20.0);
  stroke(255, 100);
}

function draw() {
  background(0);
  
  var dx = mouseX - x;
  var dy = mouseY - y;
  angle1 = atan2(dy, dx);  
  x = mouseX - (cos(angle1) * segLength);
  y = mouseY - (sin(angle1) * segLength);
 
  segment(x, y, angle1); 
  ellipse(x, y, 20, 20);
}

function segment(x, y, a) {
  push();
  translate(x, y);
  rotate(a);
  line(0, 0, segLength, 0);
  pop();
}
