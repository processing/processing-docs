/**
 * LoadFile 1
 * 
 * Loads a text file that contains two numbers separated by a tab ('\t').
 * A new pair of numbers is loaded each frame and used to draw a point on the screen.
 */

var lines;
var index = 0;

function preload() {
  lines = loadStrings("positions.txt");
}

function setup() {
  var canvas = createCanvas(200, 200);
  canvas.parent("p5container");
  background(0);
  stroke(255);
  frameRate(12);
}

function draw() {
  if (index < lines.length) {
    var pieces = split(lines[index], '\t');
    if (pieces.length == 2) {
      var x = int(pieces[0]) * 2;
      var y = int(pieces[1]) * 2;
      point(x, y);
    }
    // Go to the next line for the next run through draw()
    index = index + 1;
  }
}
