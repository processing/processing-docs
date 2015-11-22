/**
 * Animated Sprite (Shifty + Teddy)
 * by James Paterson. 
 * 
 * Press the mouse button to change animations.
 * Demonstrates loading, displaying, and animating GIF images.
 * It would be easy to write a program to display 
 * animated GIFs, but would not allow as much control over 
 * the display sequence and rate of display. 
 */

var animation1, animation2;

var xpos = 0;
var ypos = 0;
var drag = 30.0;

function preload() {
  animation1 = new Animation("PT_Shifty_", 38);
  animation2 = new Animation("PT_Teddy_", 60);
}

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  background(255, 204, 0);
  frameRate(24);
  ypos = height * 0.25;
}

function draw() { 
  var dx = mouseX - xpos;
  xpos = xpos + dx/drag;

  // Display the sprite at the position xpos, ypos
  if (mouseIsPressed) {
    background(153, 153, 0);
    animation1.display(xpos-animation1.getWidth()/2, ypos);
  } else {
    background(255, 204, 0);
    animation2.display(xpos-animation1.getWidth()/2, ypos);
  }
}
