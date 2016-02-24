/**
 * Pixel Array. 
 * 
 * Click and drag the mouse up and down to control the signal and 
 * press and hold any key to see the current pixel being read. 
 * This program sequentially reads the color of every pixel of an image
 * and displays this color to fill the window.  
 */

// The next line is needed if running in JavaScript Mode with Processing.js
/* @pjs preload="sea.jpg"; */ 

var img;
var direction = 1;
var signal = 0;

function preload() {
  img = loadImage("sea.jpg");  
}

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  noFill();
  stroke(255);
  frameRate(30);
}

function draw() {
  if (signal > img.width*img.height-1 || signal < 0) { 
    direction = direction * -1; 
  }

  if (mouseIsPressed) {
    var mx = constrain(mouseX, 0, img.width-1);
    var my = constrain(mouseY, 0, img.height-1);
    signal = my*img.width + mx;
  } else {
    signal += 0.33*direction;
  }

  var sx = int(signal) % img.width;
  var sy = int(signal) / img.width;

  if (keyIsPressed) {
    set(0, 0, img);  // fast way to draw an image
    point(sx, sy);
    rect(sx - 5, sy - 5, 10, 10);
  } else {
    var c = img.get(sx, sy);
    background(c);
  }
}
