/**
 * Loading XML Data
 * by Daniel Shiffman.  
 * 
 * This example demonstrates how to use loadJSON()
 * to retrieve data from a JSON file and make objects 
 * from that data.
 *
 * Here is what the JSON looks like (partial):
 *
 {
 "bubbles": [
 {
 "position": {
 "x": 160,
 "y": 103
 },
 "diameter": 43.19838,
 "label": "Happy"
 },
 {
 "position": {
 "x": 372,
 "y": 137
 },
 "diameter": 52.42526,
 "label": "Sad"
 }
 ]
 }
 */

// An Array of Bubble objects
var bubbles;
// A JSON object
var json;

function preload() {
  json = loadJSON("data.json");
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
  //
  textAlign(LEFT);
  fill(0);
  noStroke();
  text("Click to add bubbles.", 10, height-10);
}
 function loadData() {
  // Load JSON file
  // Temporary full path until path problem resolved.

  var bubbleData = json.bubbles;

  // The size of the array of Bubble objects is determined by the total XML elements named "bubble"
  bubbles = []; 

  for (var i = 0; i < bubbleData.length; i++) {
    // Get each object in the array
    var bubble = bubbleData[i]; 
    // Get a position object
    var position = bubble.position;
    // Get x,y from position
    var x = position.x;
    var y = position.y;
    
    // Get diamter and label
    var diameter = bubble.diameter;
    var label = bubble.label;

    // Put object in array
    bubbles[i] = new Bubble(x, y, diameter, label);
  }
}

 function mousePressed() {
  // Create a new JSON bubble object
  var newBubble = {};

  // Create a new JSON position object
  var position = { x: mouseX, y: mouseY };

  // Add position to bubble
  newBubble.position = position;

  // Add diamater and label to bubble
  newBubble.diameter =  random(40, 80);
  newBubble.label = "New label";

  // Append the new JSON bubble object to the array
  var bubbleData = json.bubbles;
  bubbleData.push(newBubble);

  if (bubbleData.length > 10) {
    bubbleData.splice(0,1);
  }

  // Save new data
  // saveJSONObject(json,"/data.json");
  loadData();
}

