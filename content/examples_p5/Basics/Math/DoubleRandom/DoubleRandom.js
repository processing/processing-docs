/**
 * Double Random 
 * by Ira Greenberg.  
 * 
 * Using two random() calls and the point() function 
 * to create an irregular sawtooth line.
 */

var totalPts = 300;
var steps = totalPts + 1;
  
function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  stroke(255);
  frameRate(1);
} 

function draw() {
  background(0);
  var rand = 0;
  for  (var i = 1; i < steps; i++) {
    point( (width/steps) * i, (height/2) + random(-rand, rand) );
    rand += random(-5, 5);
  }
}

