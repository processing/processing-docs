/** 
 * Penrose Snowflake L-System 
 * by Geraldine Sarmiento. 
 * 
 * This code was based on Patrick Dwyer's L-System class. 
 */

var ps;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  stroke(255);
  noFill();
  ps = new PenroseSnowflakeLSystem();
  ps.simulate(4);
}

function draw() {
  background(0);
  ps.render();
}


