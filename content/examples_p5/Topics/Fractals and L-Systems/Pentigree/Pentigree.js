/** 
 * Pentigree L-System 
 * by Geraldine Sarmiento. 
 * 
 * This code was based on Patrick Dwyer's L-System class. 
 */
 

var ps;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  ps = new PentigreeLSystem();
  ps.simulate(3);
}

function draw() {
  background(0);
  ps.render();
}

