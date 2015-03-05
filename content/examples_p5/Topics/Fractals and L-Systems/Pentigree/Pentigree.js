/** 
 * Pentigree L-System 
 * by Geraldine Sarmiento. 
 * 
 * This code was based on Patrick Dwyer's L-System class. 
 */
 

var ps;

function setup() {
  createCanvas(640, 360);
  ps = new PentigreeLSystem();
  ps.simulate(3);
}

function draw() {
  background(0);
  ps.render();
}

