/**
 * Loading Tabular Data
 * by Daniel Shiffman.  
 * 
 * This example demonstrates how to use loadTable()
 * to retrieve data from a CSV file and make objects 
 * from that data.
 *
 * Here is what the CSV looks like:
 *
 x,y,diameter,name
 160,103,43.19838,Happy
 372,137,52.42526,Sad
 273,235,61.14072,Joyous
 121,179,44.758068,Melancholy
 */

 // Should work once this is fixed: https://github.com/processing/p5.js/issues/486

// An Array of Bubble objects
var bubbles;
// A Table object
var table;

function preload() {
  // Load CSV file into a Table object
  // "header" option indicates the file has a header row
  table = loadTable("data.csv", "header");
}

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  loadData();
}

function draw() {
  background(255);
  // Display all bubbles
  for (var i = 0; i < bubbles.length; i++) {
    var b = bubbles[i];
    b.display();
    b.rollover(mouseX, mouseY);
  }

  textAlign(LEFT);
  fill(0);
  noStroke();
  text("Click to add bubbles.", 10, height-10);
}

function loadData() {

  // The size of the array of Bubble objects is determined by the total number of rows in the CSV
  bubbles = []; 

  // You can access iterate over all the rows in a table
  var rowCount = 0;
  for (var i = 0; i < table.getRowCount(); i++) {
    var row = table.getRow(i);
    console.log(row);
    // You can access the fields via their column name (or index)
    var x = row.getNum("x");
    var y = row.getNum("y");
    var d = row.getNum("diameter");
    var n = row.getString("name");
    // Make a Bubble object out of the data read
    bubbles[rowCount] = new Bubble(x, y, d, n);
    rowCount++;
  }
}

function mousePressed() {
  // Create a new row
  var row = table.addRow();
  // Set the values of that row
  row.set("x", mouseX);
  row.set("y", mouseY);
  row.set("diameter", random(40, 80));
  row.set("name", "Blah");

  // If the table has more than 10 rows
  if (table.getRowCount() > 10) {
    // Delete the oldest row
    table.removeRow(0);
  }

  // Writing the CSV back to the same file
  // saveTable(table, "/data.csv");
  // And reloading it
  loadData();
}

