/**
 * Continuous Lines. 
 * 
 * Click and drag the mouse to draw a line. 
 */

function setup() {
  createCanvas(640, 360);
  background(102);
}

function draw() {
  stroke(255);
  if (mouseIsPressed == true) {
    line(mouseX, mouseY, pmouseX, pmouseY);
  }
}
