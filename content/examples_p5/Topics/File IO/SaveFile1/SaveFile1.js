/**
 * SaveFile 1
 * 
 * Saving files is a useful way to store data so it can be viewed after a 
 * program has stopped running. The saveStrings() function writes an array 
 * of strings to a file, with each string written to a new line. This file 
 * is saved to the sketch's folder.
 */

var x = [];
var y = [];

function setup() {
  var canvas = createCanvas(200, 200);
  canvas.parent("p5container");
}

function draw() {
  background(204);
  stroke(0);
  noFill();
  beginShape();
  for (var i = 0; i < x.length; i++) {
    vertex(x[i], y[i]);
  }
  endShape();
  // Show the next segment to be added
  if (x.length >= 1) {
    stroke(255);
    line(mouseX, mouseY, x[x.length-1], y[x.length-1]);
  }
}

function mousePressed() { // Click to add a line segment
  x.push(mouseX);
  y.push(mouseY);
}

function keyPressed() { // Press a key to save the data
  var lines = new Array(x.length);
  for (var i = 0; i < x.length; i++) {
    lines[i] = x[i] + "\t" + y[i];
  }
  saveStrings(lines, "lines.txt");
  //exit(); // Stop the program
}

