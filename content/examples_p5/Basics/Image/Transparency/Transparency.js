/**
 * Transparency. 
 * 
 * Move the pointer left and right across the image to change
 * its position. This program overlays one image over another 
 * by modifying the alpha value of the image with the tint() function. 
 */

// The next line is needed if running in JavaScript Mode with Processing.js
/* @pjs preload="moonwalk.jpg"; */ 

var img;
var offset = 0;
var easing = 0.05;

function preload() {
  img = loadImage("moonwalk.jpg");  // Load an image into the program 
}

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
}

function draw() { 
  image(img, 0, 0);  // Display at full opacity
  var dx = (mouseX-img.width/2) - offset;
  offset += dx * easing; 
  tint(255, 127);  // Display at half opacity
  image(img, offset, 0);
}





