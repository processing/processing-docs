/**
 * Alpha Mask. 
 * 
 * Loads a "mask" for an image to specify the transparency 
 * in different parts of the image. The two images are blended
 * together using the mask() method of PImage. 
 */

// The next line is needed if running in JavaScript Mode with Processing.js
/* @pjs preload="moonwalk.jpg,mask.jpg"; */ 

var img;
var imgMask;

function preload() {
  img = loadImage("data/moonwalk.jpg");
  imgMask = loadImage("data/mask.png");  
}

function setup() {
  createCanvas(640, 360);
  //img.loadPixels();
  img.mask(imgMask);
  //img.updatePixels();
  imageMode(CENTER);
}

function draw() {
  background(0, 102, 153);
  image(img, width/2, height/2);
  image(img, mouseX, mouseY);
}
