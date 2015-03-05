/** 
 * Penrose Tile L-System 
 * by Geraldine Sarmiento.
 *  
 * This code was based on Patrick Dwyer's L-System class. 
 */

var ds;

function setup() {
  createCanvas(640, 360);
  ds = new PenroseLSystem();
  ds.simulate(4);
}

function draw() {
  background(0);
  ds.render();
}






