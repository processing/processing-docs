/**
 * Radial Gradient. 
 * 
 * Draws a series of concentric circles to create a gradient 
 * from one color to another.
 */

var dim;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  dim = width/2;
  background(0);
  colorMode(HSB, 360, 100, 100);
  noStroke();
  ellipseMode(RADIUS);
  frameRate(1);
}

function draw() {
  background(0);
  for (var x = 0; x <= width; x+=dim) {
    drawGradient(x, height/2);
  } 
}

function drawGradient(x, y) {
  var radius = dim/2;
  var h = random(0, 360);
  for (var r = radius; r > 0; --r) {
    fill(h, 90, 90);
    ellipse(x, y, r, r);
    h = (h + 1) % 360;
  }
}

