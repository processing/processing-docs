/**
 * Noise Wave
 * by Daniel Shiffman.  
 * 
 * Using Perlin Noise to generate a wave-like pattern. 
 */

var yoff = 0.0;        // 2nd dimension of perlin noise

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
}

function draw() {
  background(51);

  fill(255);
  // We are going to draw a polygon out of the wave points
  beginShape(); 
  
  var xoff = 0;       // Option #1: 2D Noise
  // var xoff = yoff; // Option #2: 1D Noise
  
  // Iterate over horizontal pixels
  for (var x = 0; x <= width; x += 10) {
    // Calculate a y value according to noise, map to 
    var y = map(noise(xoff, yoff), 0, 1, 200,300); // Option #1: 2D Noise
    // var y = map(noise(xoff), 0, 1, 200,300);    // Option #2: 1D Noise
    
    // Set the vertex
    vertex(x, y); 
    // Increment x dimension for noise
    xoff += 0.05;
  }
  // increment y dimension for noise
  yoff += 0.01;
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);
}
