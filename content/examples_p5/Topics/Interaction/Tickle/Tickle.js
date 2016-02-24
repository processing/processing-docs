/**
 * Tickle. 
 * 
 * The word "tickle" jitters when the cursor hovers over.
 * Sometimes, it can be tickled off the screen.
 */

// The next line is needed if running in JavaScript Mode with Processing.js
/* @pjs font="Georgia.ttf"; */

var message = "tickle";
var x, y; // X and Y coordinates of text
var hr, vr;  // horizontal and vertical radius of the text

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  
  // Create the font
  textFont("Source Code Pro", 36);
  textAlign(CENTER, CENTER);
  
  hr = textWidth(message) / 2;
  vr = (textAscent() + textDescent()) / 2;
  noStroke();
  x = width / 2;
  y = height / 2;
}

function draw() {
  // Instead of clearing the background, fade it by drawing
  // a semi-transparent rectangle on top
  fill(204, 120);
  rect(0, 0, width, height);
  
  // If the cursor is over the text, change the position
  if (abs(mouseX - x) < hr &&
      abs(mouseY - y) < vr) {
    x += random(-5, 5);
    y += random(-5, 5);
  }
  fill(0);
  text("tickle", x, y);
}
