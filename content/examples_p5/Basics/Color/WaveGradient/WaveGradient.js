/**
 * Wave Gradient 
 * by Ira Greenberg.  
 * 
 * Generate a gradient along a sin() wave.
 */

var angle = 0;
var px = 0, py = 0;
var amplitude = 30;
var frequency = 0;
var fillGap = 2.5;
var c;

var gradient;

function setup() {
  var canvas = createCanvas(640, 360);
  pixelDensity(1);
  canvas.parent("p5container");
  background(200);
  gradient = createImage(width, height, RGB);
  noLoop();
}

function draw() {
  gradient.loadPixels();
  for (var i =- 75; i < height+75; i++){
    // Reset angle to 0, so waves stack properly
    angle = 0;
    // Increasing frequency causes more gaps
    frequency+=.002;
    for (var j = 0; j < width+75; j++){
      py = i + sin(radians(angle)) * amplitude;
      angle += frequency;
      // c =  color(abs(py-i)*255/amplitude;, 255-abs(py-i)*255/amplitude, j*(255.0/(width+50)));
      var r = int(abs(py-i)*255/amplitude);
      var g = int(255-abs(py-i)*255/amplitude);
      var b = int(j*(255.0/(width+50)));

      // Hack to fill gaps. Raise value of fillGap if you increase frequency
      for (var filler = 0; filler < fillGap; filler++){
        var x = int(j-filler);
        var y = int(py)-filler;

        var index = (x + y * width)*4;
        gradient.pixels[index] = r; gradient.pixels[index+1] = g; gradient.pixels[index+2] = b; gradient.pixels[index+3] = 255;

        x = int(j);
        y = int(py);
        index = (x + y * width)*4;
        gradient.pixels[index] = r; gradient.pixels[index+1] = g; gradient.pixels[index+2] = b; gradient.pixels[index+3] = 255;

        x = int(j+filler);
        y = int(py)+filler;
        index = (x + y * width)*4;
        gradient.pixels[index] = r; gradient.pixels[index+1] = g; gradient.pixels[index+2] = b; gradient.pixels[index+3] = 255;

        //set(int(j-filler), int(py)-filler, c);
        //set(int(j), int(py), c);
        //set(int(j+filler), int(py)+filler, c);
      }
    }
  }
  gradient.updatePixels();
  image(gradient, 0, 0);
  noLoop();
  //console.log('complete');
}
