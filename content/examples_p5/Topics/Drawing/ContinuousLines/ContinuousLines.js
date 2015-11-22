/**
 * Continuous Lines. 
 * 
 * Click and drag the mouse to draw a line. 
 */

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  background(102);
}

function draw() {
  stroke(255);
  if (mouseIsPressed == true) {
    line(mouseX, mouseY, pmouseX, pmouseY);
  }
}
