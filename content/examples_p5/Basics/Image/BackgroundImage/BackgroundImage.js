/**
 * Background Image. 
 * 
 * This example presents the fastest way to load a background image
 * into Processing. To load an image as the background, it must be
 * the same width and height as the program.
 */
 
// The next line is needed if running in JavaScript Mode with Processing.js
/* @pjs preload="moonwalk.jpg"; */ 

var bg;
var y = 0;

function preload() {
  // The background image must be the same size as the parameters
  // into the size() method. In this program, the size of the image
  // is 640 x 360 pixels.
  bg = loadImage("moonwalk.jpg");
}

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
}

function draw() {
  background(bg);
  
  stroke(226, 204, 0);
  line(0, y, width, y);
  
  y++;
  if (y > height) {
    y = 0; 
  }
}
