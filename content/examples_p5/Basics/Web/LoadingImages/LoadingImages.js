/**
 * Loading Images. 
 * 
 * Processing applications can only load images from the network
 * while running in the Processing environment. 
 * 
 * This example will only work when the computer is connected to the Internet. 
 */

var img;

function setup() {
  createCanvas(640, 360);
  img = createImg("http://processing.org/img/processing-web.png");
  img.hide();
  // This needs to be resolved: https://github.com/processing/p5.js/issues/561
  // noLoop();
  // Also: https://github.com/processing/processing-docs/issues/218
}

function draw() {
  background(0);
  for (var i = 0; i < 5; i++) {
    image(img, 0, img.height * i, img.elt.width, img.elt.height);
  }
}

