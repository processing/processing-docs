/**
 * Keyboard. 
 * 
 * Click on the image to give it focus and press the letter keys 
 * to create forms in time and space. Each key has a unique identifying 
 * number. These numbers can be used to position shapes in space. 
 */

var rectWidth;
   
function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  noStroke();
  background(0);
  rectWidth = width/4;
}

function draw() { 
  // keep draw() here to continue looping while waiting for keys
}

function keyPressed() {
  var keyIndex = -1;
  var keyVal = key.charCodeAt(0);
  if (keyVal >= 'A'.charCodeAt(0) && keyVal <= 'Z'.charCodeAt(0)) {
    keyIndex = keyVal - 'A'.charCodeAt(0);
  } else if (keyVal >= 'a'.charCodeAt(0) && keyVal <= 'z'.charCodeAt(0)) {
    keyIndex = keyVal - 'a'.charCodeAt(0);
  }
  if (keyIndex === -1) {
    // If it's not a letter key, clear the screen
    background(0);
  } else { 
    // It's a letter key, fill a rectangle
    fill(millis() % 255);
    var x = map(keyIndex, 0, 25, 0, width - rectWidth);
    rect(x, 0, rectWidth, height);
  }
}
