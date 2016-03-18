/**
 * Constrain. 
 * 
 * Move the mouse across the screen to move the circle. 
 * The program constrains the circle to its box. 
 */
 
var mx = 0;
var my = 0;
var easing = 0.05;
var radius = 24;
var edge = 100;
var inner = edge + radius;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  noStroke(); 
  ellipseMode(RADIUS);
  rectMode(CORNERS);
}

function draw() { 
  background(51);
  
  if (abs(mouseX - mx) > 0.1) {
    mx = mx + (mouseX - mx) * easing;
  }
  if (abs(mouseY - my) > 0.1) {
    my = my + (mouseY- my) * easing;
  }
  
  mx = constrain(mx, inner, width - inner);
  my = constrain(my, inner, height - inner);
  fill(76);
  rect(edge, edge, width-edge, height-edge);
  fill(255);  
  ellipse(mx, my, radius, radius);
}
