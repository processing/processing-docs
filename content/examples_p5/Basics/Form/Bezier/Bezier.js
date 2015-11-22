/**
 * Bezier. 
 * 
 * The first two parameters for the bezier() function specify the 
 * first point in the curve and the last two parameters specify 
 * the last point. The middle parameters set the control points
 * that define the shape of the curve. 
 */

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container"); 
  stroke(255);
  noFill();
}

function draw() {
  background(0);
  for (var i = 0; i < 200; i += 20) {
    bezier(mouseX-(i/2.0), 40+i, 410, 20, 440, 300, 240-(i/16.0), 300+(i/8.0));
  }
}

