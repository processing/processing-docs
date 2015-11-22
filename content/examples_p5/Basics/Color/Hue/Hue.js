/**
 * Hue. 
 * 
 * Hue is the color reflected from or transmitted through an object 
 * and is typically referred to as the name of the color (red, blue, yellow, etc.) 
 * Move the cursor vertically over each bar to alter its hue. 
 */
 
var barWidth = 20;
var lastBar = -1;

function setup() 
{
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  colorMode(HSB, height, height, height);  
  noStroke();
  background(0);
}

function draw() 
{
  var whichBar = mouseX / barWidth;
  if (whichBar != lastBar) {
    var barX = whichBar * barWidth;
    fill(mouseY, height, height);
    rect(barX, 0, barWidth, height);
    lastBar = whichBar;
  }
}

