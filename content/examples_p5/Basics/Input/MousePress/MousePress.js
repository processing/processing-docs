/**
 * Mouse Press. 
 * 
 * Move the mouse to position the shape. 
 * Press the mouse button to invert the color. 
 */


function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  noSmooth();
  fill(126);
  background(102);
}

function draw() {
  if (mouseIsPressed) {
    stroke(255);
  } else {
    stroke(0);
  }
  line(mouseX-66, mouseY, mouseX+66, mouseY);
  line(mouseX, mouseY-66, mouseX, mouseY+66); 
}
