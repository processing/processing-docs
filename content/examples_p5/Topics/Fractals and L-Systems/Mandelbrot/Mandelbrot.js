/**
 * The Mandelbrot Set
 * by Daniel Shiffman.  
 * 
 * Simple rendering of the Mandelbrot set.
 */

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  pixelDensity(1);
  noLoop();
  background(255);

  // Establish a range of values on the complex plane
  // A different range will allow us to "zoom" in or out on the fractal

  // It all starts with the width, try higher or lower values
  var w = 5;
  var h = (w * height) / width;

  // Start at negative half the width and height
  var xmin = -w/2;
  var ymin = -h/2;

  // Make sure we can write to the pixels[] array.
  // Only need to do this once since we don't do any other drawing.
  loadPixels();

  // Maximum number of iterations for each point on the complex plane
  var maxiterations = 100;

  // x goes from xmin to xmax
  var xmax = xmin + w;
  // y goes from ymin to ymax
  var ymax = ymin + h;

  // Calculate amount we increment x,y for each pixel
  var dx = (xmax - xmin) / (width);
  var dy = (ymax - ymin) / (height);

  // Start y
  var y = ymin;
  for (var j = 0; j < height; j++) {
    // Start x
    var x = xmin;
    for (var i = 0; i < width; i++) {

      // Now we test, as we iterate z = z^2 + cm does z tend towards infinity?
      var a = x;
      var b = y;
      var n = 0;
      while (n < maxiterations) {
        var aa = a * a;
        var bb = b * b;
        var twoab = 2.0 * a * b;
        a = aa - bb + x;
        b = twoab + y;
        // Infinty in our finite world is simple, let's just consider it 16
        if (aa + bb > 16.0) {
          break;  // Bail
        }
        n++;
      }

      // We color each pixel based on how long it takes to get to infinity
      // If we never got there, let's pick the color black
      var loc = (i+j*width)*4
      if (n == maxiterations) {
        pixels[loc] = 0;
        pixels[loc+1] = 0;
        pixels[loc+2] = 0;
        pixels[loc+3] = 255;
      } else {
        // Gosh, we could make fancy colors here if we wanted
        pixels[loc] = n*16 % 255;
        pixels[loc+1] = n*16 % 255;
        pixels[loc+2] = n*16 % 255;
        pixels[loc+3] = 255;
      }
      x += dx;
    }
    y += dy;
  }
  updatePixels();

}
