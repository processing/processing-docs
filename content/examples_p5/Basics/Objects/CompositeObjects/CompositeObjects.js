/**
 * Composite Objects
 * 
 * An object can include several other objects. Creating such composite objects 
 * is a good way to use the principles of modularity and build higher levels of 
 * abstraction within a program.
 */

var er1, er2;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  er1 = new EggRing(width*0.45, height*0.5, 0.1, 120);
  er2 = new EggRing(width*0.65, height*0.8, 0.05, 180);
}


function draw() {
  background(0);
  er1.transmit();
  er2.transmit();
}
