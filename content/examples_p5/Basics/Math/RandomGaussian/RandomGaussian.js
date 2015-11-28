/**
 * Random Gaussian. 
 * 
 * This sketch draws ellipses with x and y locations tied to a gaussian distribution of random numbers.
 */

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  background(0);
}

function draw() {

  // Get a gaussian random number w/ mean of 0 and standard deviation of 1.0
  var val = randomGaussian();

  var sd = 60;                  // Define a standard deviation
  var mean = width/2;           // Define a mean value (middle of the screen along the x-axis)
  var x = ( val * sd ) + mean;  // Scale the gaussian random number by standard deviation and mean

  noStroke();
  fill(255, 10);
  noStroke();
  ellipse(x, height/2, 32, 32);   // Draw an ellipse at our "normal" random location
}



