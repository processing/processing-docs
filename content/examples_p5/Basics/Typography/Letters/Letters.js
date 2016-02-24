/**
 * Letters. 
 * 
 * Draws letters to the screen. This requires loading a font, 
 * setting the font, and then drawing the letters.
 */

var f;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  background(0);

  // Create the font
  //printArray(PFont.list());
  textFont("Source Code Pro", 24);
  textAlign(CENTER, CENTER);
} 

function draw() {
  background(0);

  // Set the left and top margin
  var margin = 10;
  translate(margin*4, margin*4);

  var gap = 46;
  var counter = 35;
  
  for (var y = 0; y < height-gap; y += gap) {
    for (var x = 0; x < width-gap; x += gap) {
      
      // See: https://github.com/processing/p5.js/issues/560
      var letter = String.fromCharCode(counter);//char(counter);
      
      if (letter == 'A' || letter == 'E' || letter == 'I' || letter == 'O' || letter == 'U') {
        fill(255, 204, 0);
      } 
      else {
        fill(255);
      }
      noStroke();

      // Draw the letter to the screen
      text(letter, x, y);

      // Increment the counter
      counter++;
    }
  }
  noLoop();
}

