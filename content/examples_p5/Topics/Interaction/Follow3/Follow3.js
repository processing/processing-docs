/**
 * Follow 3  
 * based on code from Keith Peters. 
 * 
 * A segmented line follows the mouse. The relative angle from
 * each segment to the next is calculated with atan2() and the
 * position of the next is calculated with sin() and cos().
 */

var x = new Array(20);
var y = new Array(20);
var segLength = 18;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  strokeWeight(9);
  stroke(255, 100);
  for (var i = 0; i < x.length; i++) {
    x[i] = 0;
    y[i] = 0;
  }
}

function draw() {
  background(0);
  dragSegment(0, mouseX, mouseY);
  for(var i=0; i<x.length-1; i++) {
    dragSegment(i+1, x[i], y[i]);
  }
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
