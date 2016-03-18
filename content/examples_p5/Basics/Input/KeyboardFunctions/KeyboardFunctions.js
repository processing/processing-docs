// /**
//  * Keyboard Functions. 
//  * Modified from code by Martin. 
//  * Original 'Color Typewriter' concept by John Maeda. 
//  * 
//  * Click on the window to give it focus and press the letter keys to type colors. 
//  * The keyboard function keyPressed() is called whenever
//  * a key is pressed. keyReleased() is another keyboard
//  * function that is called when a key is released.
//  */
 
var maxHeight = 40;
var minHeight = 20;
var letterHeight = maxHeight; // Height of the letters
var letterWidth = 20;          // Width of the letter

var x = -letterWidth;          // X position of the letters
var y = 0;                      // Y position of the letters

var newletter;              

var numChars = 26;      // There are 26 characters in the alphabet
var colors = [];

function setup()
{
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  noStroke();
  colorMode(HSB, numChars);
  background(numChars/2);
  // Set a gray value for each key
  for(var i = 0; i < numChars; i++) {
    colors[i] = color(i, numChars, numChars);    
  }

}

function draw()
{
  if(newletter == true) {
    // Draw the "letter"
    var y_pos;
    if (letterHeight == maxHeight) {
      y_pos = y;
      rect( x, y_pos, letterWidth, letterHeight );
    } else {
      y_pos = y + minHeight;
      rect( x, y_pos, letterWidth, letterHeight );
      fill(numChars/2);
      rect( x, y_pos-minHeight, letterWidth, letterHeight );
    }
    console.log(letterWidth,letterHeight);
    newletter = false;
    println(letterWidth,letterHeight);

  }
}

function keyTyped() {
  console.log(key);
  var keyVal = key.charCodeAt(0);
  println(keyVal);
  // If the key is between 'A'(65) to 'Z' and 'a' to 'z'(122)
  if((keyVal >= 'A'.charCodeAt(0) && keyVal <= 'Z'.charCodeAt(0)) || (keyVal >= 'a'.charCodeAt(0) && keyVal <= 'z'.charCodeAt(0))) {
    var keyIndex = 0;
    if(keyVal <= 'Z'.charCodeAt(0)) {
      keyIndex = keyVal-'A'.charCodeAt(0);
      letterHeight = maxHeight;
      fill(colors[keyVal-'A'.charCodeAt(0)]);
    } else {
      keyIndex = keyVal-'a'.charCodeAt(0);
      letterHeight = minHeight;
      fill(colors[keyVal-'a'.charCodeAt(0)]);
    }
  } else {
    fill(0);
    letterHeight = 10;
  }

  newletter = true;

  // Update the "letter" position
  x = ( x + letterWidth ); 

  // Wrap horizontally
  if (x > width - letterWidth) {
    x = 0;
    y+= maxHeight;
  }

  // Wrap vertically
  if( y > height - letterHeight) {
    y = 0;      // reset y to 0
  }
}
