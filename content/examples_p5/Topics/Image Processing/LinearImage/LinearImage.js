/**
 * Linear Image. 
 * 
 * Click and drag mouse up and down to control the signal. 
 * Press and hold any key to watch the scanning. 
 */

// The next line is needed if running in JavaScript Mode with Processing.js
/* @pjs preload="sea.jpg"; */

// This needs to be resolved: https://github.com/processing/p5.js/issues/478

var img;
var direction = 1;

var signal = 0;

function preload() {
  img = loadImage("sea.jpg");
}

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  stroke(255);
  img.loadPixels();
  loadPixels();
}

function draw() {
  loadPixels();
  if (signal > img.height-1 || signal < 0) { 
    direction = direction * -1;
  }
  if (mouseIsPressed == true) {
    signal = abs(mouseY % img.height);
  } 
  else {
    signal += (0.3*direction);
  }

  if (keyIsPressed == true) {
    set(0, 0, img);
    line(0, signal, img.width, signal);
  } 
  else {
    var signalOffset = int(signal)*img.width;
    for (var y = 0; y < img.height; y++) {
      arrayCopy(img.pixels, signalOffset, pixels, y*width, img.width);
    }
    updatePixels();
  }
}

