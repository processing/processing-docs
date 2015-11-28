/**
 * Easing. 
 * 
 * Move the mouse across the screen and the symbol will follow.  
 * Between drawing each frame of the animation, the program
 * calculates the difference between the position of the 
 * symbol and the cursor. If the distance is larger than
 * 1 pixel, the symbol moves part of the distance (0.05) from its
 * current position toward the cursor. 
 */
 
var x = 0;
var y = 0;
var easing = 0.05;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container"); 
  noStroke();  
}

function draw() { 
  background(51);
  
  var targetX = mouseX;
  var dx = targetX - x;
  if(abs(dx) > 1) {
    x += dx * easing;
  }
  
  var targetY = mouseY;
  var dy = targetY - y;
  if(abs(dy) > 1) {
    y += dy * easing;
  }
  
  ellipse(x, y, 66, 66);
}
