/**
 * Noise1D. 
 * 
 * Using 1D Perlin Noise to assign location. 
 */
 
var xoff = 0.0;
var xincrement = 0.01; 

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  background(0);
  noStroke();
}

function draw()
{
  // Create an alpha blended background
  fill(0, 10);
  rect(0,0,width,height);
  
  //var n = random(0,width);  // Try this line instead of noise
  
  // Get a noise value based on xoff and scale it according to the window's width
  var n = noise(xoff)*width;
  
  // With each cycle, increment xoff
  xoff += xincrement;
  
  // Draw the ellipse at the value produced by perlin noise
  fill(200);
  ellipse(n,height/2, 64, 64);
}


