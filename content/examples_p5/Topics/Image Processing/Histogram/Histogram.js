/**
 * Histogram. 
 * 
 * Calculates the histogram of an image. 
 * A histogram is the frequency distribution 
 * of the gray levels with the number of pure black values
 * displayed on the left and number of pure white values on the right. 
 *
 * Note that this sketch will behave differently on Android, 
 * since most images will no longer be full 24-bit color.
 */

// The next line is needed if running in JavaScript Mode with Processing.js
/* @pjs preload="frontier.jpg"; */ 


// This needs to be resolved: https://github.com/processing/p5.js/issues/563

var img;

function preload() {
  img = loadImage("frontier.jpg");
}

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  // Load an image from the data directory
  // Load a different image by modifying the comments
  image(img, 0, 0);
  var hist = [];
  for (var i = 0; i < 256; i++) {
    hist[i] = 0;
  }
  img.loadPixels();
  // Calculate the histogram
  for (var i = 0; i < img.width; i++) {
    for (var j = 0; j < img.height; j++) {
      var index = (i + j * img.width) * 4;
      var r = img.pixels[index];
      var g = img.pixels[index+1];
      var b = img.pixels[index+2];
      //println(c,col);
      var bright = floor((r+g+b)/3);
      hist[bright]++; 
      //break;
    }
  }

  // Find the largest value in the histogram
  var histMax = max(hist);

  stroke(255);
  // Draw half of the histogram (skip every second value)
  for (var i = 0; i < img.width; i += 2) {
    // Map i (from 0..img.width) to a location in the histogram (0..255)
    var which = int(map(i, 0, img.width, 0, 255));
    // Convert the histogram value to a location between 
    // the bottom and the top of the picture
    var y = int(map(hist[which], 0, histMax, img.height, 0));
    line(i, img.height, i, y);
  }
}
