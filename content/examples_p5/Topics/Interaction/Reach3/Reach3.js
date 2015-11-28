/**
 * Reach 3  
 * based on code from Keith Peters.
 * 
 * The arm follows the position of the ball by
 * calculating the angles with atan2().
 */

var numSegments = 8;
var x = new Array(numSegments);
var y = new Array(numSegments);
var angle = new Array(numSegments);
var segLength = 26;
var targetX, targetY = 0;

var ballX = 50;
var ballY = 50;
var ballXDirection = 1;
var ballYDirection = -1;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  strokeWeight(20.0);
  stroke(255, 100);
  noFill();
  for (var i = 0 ; i < x.length; i++) {
    x[i] = 0;
    y[i] = 0;
  }
  x[x.length-1] = width/2;     // Set base x-coordinate
  y[x.length-1] = height;  // Set base y-coordinate
}

function draw() {
  background(0);
  
  strokeWeight(20);
  ballX = ballX + 1.0 * ballXDirection;
  ballY = ballY + 0.8 * ballYDirection;
  if(ballX > width-25 || ballX < 25) {
    ballXDirection *= -1; 
  }
  if(ballY > height-25 || ballY < 25) {
    ballYDirection *= -1; 
  }
  ellipse(ballX, ballY, 30, 30);
  
  reachSegment(0, ballX, ballY);
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
