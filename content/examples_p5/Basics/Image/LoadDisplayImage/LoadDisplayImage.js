/**
 * Load and Display 
 * 
 * Images can be loaded and displayed to the screen at their actual size
 * or any other size. 
 */
 
var img;  // Declare variable "a" of type PImage

function preload() {
  // The image file must be in the data folder of the current sketch 
  // to load successfully
  img = loadImage("moonwalk.jpg");
}

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
}

function draw() {
  // Displays the image at its actual size at point (0,0)
  image(img, 0, 0);
  // Displays the image at point (0, height/2) at half of its size
  image(img, 0, height/2, img.width/2, img.height/2);
  noLoop();
}
