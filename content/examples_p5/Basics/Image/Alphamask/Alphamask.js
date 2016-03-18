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
  img = loadImage("moonwalk.jpg");
  imgMask = loadImage("mask.png");  
}

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  // Temporary fix until https://github.com/lmccart/p5.js/pull/533
  imgMask.loadPixels();
  for (var i = 0; i < imgMask.pixels.length; i+=4) {
    imgMask.pixels[i] = 255;
    imgMask.pixels[i+1] = 255;
    imgMask.pixels[i+2] = 255;
    imgMask.pixels[i+3] = 255-imgMask.pixels[i+3];
  }
  imgMask.updatePixels();
  img.mask(imgMask);
  imageMode(CENTER);
}

function draw() {
  background(0, 102, 153);
  image(img, width/2, height/2);
  image(img, mouseX, mouseY);
}
