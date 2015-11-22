/**
 * Brightness 
 * by Rusty Robison. 
 * 
 * Brightness is the relative lightness or darkness of a color.
 * Move the cursor vertically over each bar to alter its brightness. 
 */
 
var barWidth = 20;
var lastBar = -1;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  colorMode(HSB, width, 100, width);
  noStroke();
  background(0);
}

function draw() {
  var whichBar = mouseX / barWidth;
  if (whichBar != lastBar) {
    var barX = whichBar * barWidth;
    fill(barX, 100, mouseY);
    rect(barX, 0, barWidth, height);
    lastBar = whichBar;
  }
}
