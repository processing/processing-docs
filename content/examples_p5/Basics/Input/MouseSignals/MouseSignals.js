/**
 * Mouse Signals. 
 * 
 * Move and click the mouse to generate signals. 
 * The top row is the signal from "mouseX", 
 * the middle row is the signal from "mouseY",
 * and the bottom row is the signal from "mousePressed". 
 */
 
var xvals;
var yvals;
var bvals;

function setup() 
{
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  noSmooth();
  xvals = [];
  yvals = [];
  bvals = [];
  for (var i = 0; i < width; i++) {
    xvals[i] = 0;
    yvals[i] = 0;
    bvals[i] = 0;
  }
}

var arrayindex = 0;

function draw() {
  background(102);
  
  for(var i = 1; i < width; i++) { 
    xvals[i-1] = xvals[i]; 
    yvals[i-1] = yvals[i];
    bvals[i-1] = bvals[i];
  } 
  // Add the new values to the end of the array 
  xvals[width-1] = mouseX; 
  yvals[width-1] = mouseY;
  if(mouseIsPressed) {
    bvals[width-1] = 0;
  } else {
    bvals[width-1] = 255;
  }
  
  fill(255);
  noStroke();
  rect(0, height/3, width, height/3+1);

  for(var i=1; i<width; i++) {
    stroke(255);
    point(i, map(xvals[i], 0, width, 0, height/3-1));
    stroke(0);
    point(i, height/3+yvals[i]/3);
    stroke(255);
    line(i, (2*height/3) + bvals[i], i, (2*height/3) + bvals[i-1]);
  }
}
