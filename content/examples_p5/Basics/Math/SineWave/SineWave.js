/**
 * Sine Wave
 * by Daniel Shiffman.  
 * 
 * Render a simple sine wave. 
 */
 
var xspacing = 16;   // How far apart should each horizontal location be spaced
var w;              // Width of entire wave

var theta = 0.0;  // Start angle at 0
var amplitude = 75.0;  // Height of wave
var period = 500.0;  // How many pixels before the wave repeats
var dx;  // Value for incrementing X, a function of period and xspacing
var yvalues;  // Using an array to store height values for the wave

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  w = width+16;
  dx = (TWO_PI / period) * xspacing;
  yvalues = new Array(w/xspacing);
}

function draw() {
  background(0);
  calcWave();
  renderWave();
}

function calcWave() {
  // Increment theta (try different values for 'angular velocity' here
  theta += 0.02;

  // For every x value, calculate a y value with sine function
  var x = theta;
  for (var i = 0; i < yvalues.length; i++) {
    yvalues[i] = sin(x)*amplitude;
    x+=dx;
  }
}

function renderWave() {
  noStroke();
  fill(255);
  // A simple way to draw the wave with an ellipse at each location
  for (var x = 0; x < yvalues.length; x++) {
    ellipse(x*xspacing, height/2+yvalues[x], 16, 16);
  }
}

