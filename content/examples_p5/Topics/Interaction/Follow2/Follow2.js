/**
 * Follow 2  
 * based on code from Keith Peters. 
 * 
 * A two-segmented arm follows the cursor position. The relative
 * angle between the segments is calculated with atan2() and the
 * position calculated with sin() and cos().
 */

var x = [0,0];
var y = [0,0];
var segLength = 50;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  strokeWeight(20.0);
  stroke(255, 100);
}

function draw() {
  background(0);
  dragSegment(0, mouseX, mouseY);
  dragSegment(1, x[0], y[0]);
}

function dragSegment(i, xin, yin) {
  var dx = xin - x[i];
  var dy = yin - y[i];
  var angle = atan2(dy, dx);  
  x[i] = xin - cos(angle) * segLength;
  y[i] = yin - sin(angle) * segLength;
  segment(x[i], y[i], angle);
}

function segment(x, y, a) {
  push();
  translate(x, y);
  rotate(a);
  line(0, 0, segLength, 0);
  pop();
}
