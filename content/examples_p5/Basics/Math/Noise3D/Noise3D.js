/**
 * Noise3D. 
 * 
 * Using 3D noise to create simple animated texture. 
 * Here, the third dimension ('z') is treated as time. 
 */
 
var increment = 0.01;
// The noise function's 3rd argument, a global variable that increments once per cycle
var zoff = 0.0;  
// We will increment zoff differently than xoff and yoff
var zincrement = 0.02; 

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  frameRate(30);
  pixelDensity(1);
}

function draw() {
  
  // Optional: adjust noise detail here
  // noiseDetail(8,0.65f);
  
  loadPixels();

  var xoff = 0.0; // Start xoff at 0
  
  // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
  for (var x = 0; x < width; x++) {
    xoff += increment;   // Increment xoff 
    var yoff = 0.0;   // For every xoff, start yoff at 0
    for (var y = 0; y < height; y++) {
      yoff += increment; // Increment yoff
      
      // Calculate noise and scale by 255
      var bright = noise(xoff,yoff,zoff)*255;

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
  
  zoff += zincrement; // Increment zoff
  
  
}



