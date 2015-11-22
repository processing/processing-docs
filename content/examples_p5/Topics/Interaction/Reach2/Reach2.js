/**
 * Reach 2  
 * based on code from Keith Peters.
 * 
 * The arm follows the position of the mouse by
 * calculating the angles with atan2(). 
 */

var numSegments = 10;
var x = new Array(numSegments);
var y = new Array(numSegments);
var angle = new Array(numSegments);
var segLength = 26;
var targetX, targetY = 0;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  strokeWeight(20.0);
  stroke(255, 100);
  for (var i = 0 ; i < x.length; i++) {
    x[i] = 0;
    y[i] = 0;
  }
  x[x.length-1] = width/2;     // Set base x-coordinate
  y[x.length-1] = height;  // Set base y-coordinate
}

function draw() {
  background(0);
  
  reachSegment(0, mouseX, mouseY);
  for(var i=1; i<numSegments; i++) {
    reachSegment(i, targetX, targetY);
  }
  for(var i=x.length-1; i>=1; i--) {
    positionSegment(i, i-1);  
  } 
  for(var i=0; i<x.length; i++) {
    segment(x[i], y[i], angle[i], (i+1)*2); 
  }
}

function positionSegment(a,b) {
  x[b] = x[a] + cos(angle[a]) * segLength;
  y[b] = y[a] + sin(angle[a]) * segLength; 
}

function reachSegment(i, xin, yin) {
  var dx = xin - x[i];
  var dy = yin - y[i];
  angle[i] = atan2(dy, dx);  
  targetX = xin - cos(angle[i]) * segLength;
  targetY = yin - sin(angle[i]) * segLength;
}

function segment(x, y, a, sw) {
  strokeWeight(sw);
  push();
  translate(x, y);
  rotate(a);
  line(0, 0, segLength, 0);
  pop();
}
