/**
 * Edge Detection. 
 * 
 * A high-pass filter sharpens an image. This program analyzes every
 * pixel in an image in relation to the neighboring pixels to sharpen 
 * the image. This example is currently not accurate in JavaScript mode.
 */

// The next line is needed if running in JavaScript Mode with Processing.js
/* @pjs preload="moon.jpg"; */


var kernel = [[ -1, -1, -1 ], 
                    [ -1, 9, -1 ], 
                    [ -1, -1, -1 ]];
                    
var img;

function preload() {
  img = loadImage("moon.jpg"); // Load the original image
}

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  pixelDensity(1);
  noLoop();
} 

function draw() {
  image(img, 0, 0); // Displays the image from point (0,0) 
  img.loadPixels();

  // Create an opaque image of the same size as the original
  var edgeImg = createImage(img.width, img.height, RGB);
  edgeImg.loadPixels();

  // Loop through every pixel in the image
  for (var y = 1; y < img.height-1; y++) {   // Skip top and bottom edges
    for (var x = 1; x < img.width-1; x++) {  // Skip left and right edges
      var sum = 0; // Kernel sum for this pixel
      for (var ky = -1; ky <= 1; ky++) {
        for (var kx = -1; kx <= 1; kx++) {
          // Calculate the adjacent pixel for this kernel point
          var pos = ((y + ky)*img.width + (x + kx))*4;
          // Image is grayscale, red/green/blue are identical
          var val = img.pixels[pos];
          // Multiply adjacent pixels based on the kernel values
          sum += kernel[ky+1][kx+1] * val;
        }
      }
      // For this pixel in the new image, set the gray value
      // based on the sum from the kernel
      var pos = (y*img.width + x)*4;
      edgeImg.pixels[pos] = sum;
      edgeImg.pixels[pos+1] = sum;
      edgeImg.pixels[pos+2] = sum;
      edgeImg.pixels[pos+3] = 255;
    }
  }
  // State that there are changes to edgeImg.pixels[]
  edgeImg.updatePixels();

  image(edgeImg, width/2, 0); // Draw the new image
}

