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
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  img = createImg("https://processing.org/img/processing-web.png", loaded);
}

function loaded() {
  background(0);
  for (var i = 0; i < 5; i++) {
    image(img, 0, img.height * i, img.elt.width, img.elt.height);
  }
  img.hide();
}
