/**
 * Multiple constructors
 * 
 * A class can have multiple constructors that assign the fields in different ways. 
 * Sometimes it's beneficial to specify every aspect of an object's data by assigning 
 * parameters to the fields, but other times it might be appropriate to define only 
 * one or a few.
 */

var sp1, sp2;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  background(204);
  noLoop();
  // Run the constructor without parameters
  sp1 = new Spot();
  // Run the constructor with three parameters
  sp2 = new Spot(width*0.5, height*0.5, 120);
}

function draw() {
  sp1.display();
  sp2.display();
} 

// First version of the Spot constructor;
// the fields are assigned default values
// Second version of the Spot constructor;
// the fields are assigned with parameters
function Spot(xpos, ypos, r) {
  this.radius = r || 40;
  this.x = xpos || width*0.25;
  this.y = ypos || height*0.5;
  
  this.display = function() {
    ellipse(this.x, this.y, this.radius*2, this.radius*2);
  }
  
}
