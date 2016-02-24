/**
 * Noise2D 
 * by Daniel Shiffman.  
 * 
 * Using 2D noise to create simple texture. 
 */
 
var increment = 0.02;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  pixelDensity(1);
}

function draw() {
  
  loadPixels();

  var xoff = 0.0; // Start xoff at 0
  var detail = map(mouseX, 0, width, 0.1, 0.6);
  noiseDetail(8, detail);
  
  // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
  for (var x = 0; x < width; x++) {
    xoff += increment;   // Increment xoff 
    var yoff = 0.0;   // For every xoff, start yoff at 0
    for (var y = 0; y < height; y++) {
      yoff += increment; // Increment yoff
      
      // Calculate noise and scale by 255
      var bright = noise(xoff, yoff) * 255;

      // Try using this line instead
      //var bright = random(0,255);
      
      // Set each pixel onscreen to a grayscale value
      var loc = (x + y*width)*4;
      pixels[loc]   = bright;
      pixels[loc+1] = bright;
      pixels[loc+2] = bright;
      pixels[loc+3] = 255;     // Scale to between 0 and 255
    }
  }
  
  updatePixels();
}



