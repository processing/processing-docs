/**
 * Koch Curve
 * by Daniel Shiffman.
 * 
 * Renders a simple fractal, the Koch snowflake. 
 * Each recursive level is drawn in sequence. 
 */
 

var k;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  frameRate(1);  // Animate slowly
  k = new KochFractal();
}

function draw() {
  background(0);
  // Draws the snowflake!
  k.render();
  // Iterate
  k.nextLevel();
  // Let's not do it more than 5 times. . .
  if (k.getCount() > 5) {
    k.restart();
  }
}


