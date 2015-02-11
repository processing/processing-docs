/**
 * Create Image. 
 * 
 * The createImage() function provides a fresh buffer of pixels to play with.
 * This example creates an image gradient.
 */

PImage img;

function setup() {
  createCanvas(640, 360);  
  img = createImage(230, 230, ARGB);
  for(var i = 0; i < img.pixels.length; i++) {
    var a = map(i, 0, img.pixels.length, 255, 0);
    img.pixels[i] = color(0, 153, 204, a); 
  }
}

function draw() {
  background(0);
  image(img, 90, 80);
  image(img, mouseX-img.width/2, mouseY-img.height/2);
}
