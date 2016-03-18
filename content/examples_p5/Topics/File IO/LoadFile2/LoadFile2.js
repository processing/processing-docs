/**
 * LoadFile 2
 * 
 * This example loads a data file about cars. Each element is separated
 * with a tab and corresponds to a different aspect of each car. The file stores 
 * the miles per gallon, cylinders, displacement, etc., for more than 400 different
 * makes and models. Press a mouse button to advance to the next group of entries.
 */

var records;
var lines;
var recordCount = 0;
var num = 9; // Display this many entries on each screen.
var startingEntry = 0;  // Display from this entry number

function preload() {
  lines = loadStrings("cars2.tsv");
}

function setup() {
  var canvas = createCanvas(200, 200);
  canvas.parent("p5container");
  fill(255);
  noLoop();
  
  textFont('TheSans');
  
  records = new Array(lines.length);
  for (var i = 0; i < lines.length; i++) {
    var pieces = split(lines[i], '\t'); // Load data into array
    if (pieces.length == 9) {
      records[recordCount] = new Record(pieces);
      recordCount++;
    }
  }
  if (recordCount != records.length) {
    //records = (Record[]) subset(records, 0, recordCount);
  }
}

function draw() {
  background(0);
  for (var i = 0; i < num; i++) {
    var thisEntry = startingEntry + i;
    if (thisEntry < recordCount) {
      fill(255);
      noStroke();
      text(thisEntry + " > " + records[thisEntry].name, 20, 20 + i*20);
    }
  }
}

function mousePressed() {
  startingEntry += num; 
  if (startingEntry > records.length) {
    startingEntry = 0;  // go back to the beginning
  } 
  redraw();
}
