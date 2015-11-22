/**
 * Create Image. 
 * 
 * The createImage() function provides a fresh buffer of pixels to play with.
 * This example creates an image gradient.
 */

var img;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");  
  img = createImage(230, 230);
  img.loadPixels();
  for(var i = 0; i < img.pixels.length; i+=4) {
    var a = map(i, 0, img.pixels.length, 255, 0);
    img.pixels[i] = 0;
    img.pixels[i+1] = 153;
    img.pixels[i+2] = 204;
    img.pixels[i+3] = a; 
  }
  img.updatePixels();
}

function draw() {
  background(0);
  image(img, 90, 80);
  image(img, mouseX-img.width/2, mouseY-img.height/2);
}
