/**
 * Morph. 
 * 
 * Changing one shape into another by interpolating
 * vertices from one to another
 */

// Two ArrayLists to store the vertices for two shapes
// This example assumes that each shape will have the same
// number of vertices, i.e. the size of each ArrayList will be the same
var circle = [];
var square = [];

// An ArrayList for a third set of vertices, the ones we will be drawing
// in the window
var morph = [];

// This boolean variable will control if we are morphing to a circle or square
var state = false;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");

  // Create a circle using vectors pointing from center
  for (var angle = 0; angle < 360; angle += 9) {
    // Note we are not starting from 0 in order to match the
    // path of a circle.  
    var v = p5.Vector.fromAngle(radians(angle-135));
    v.mult(100);
    circle.push(v);
    // Let's fill out morph ArrayList with blank p5.Vectors while we are at it
    morph.push(createVector());
  }

  // A square is a bunch of vertices along straight lines
  // Top of square
  for (var x = -50; x < 50; x += 10) {
    square.push(new p5.Vector(x, -50));
  }
  // Right side
  for (var y = -50; y < 50; y += 10) {
    square.push(new p5.Vector(50, y));
  }
  // Bottom
  for (var x = 50; x > -50; x -= 10) {
    square.push(new p5.Vector(x, 50));
  }
  // Left side
  for (var y = 50; y > -50; y -= 10) {
    square.push(new p5.Vector(-50, y));
  }
}

function draw() {
  background(51);

  // We will keep how far the vertices are from their target
  var totalDistance = 0;
  
  // Look at each vertex
  for (var i = 0; i < circle.length; i++) {
    var v1;
    // Are we lerping to the circle or square?
    if (state) {
      v1 = circle[i];
    }
    else {
      v1 = square[i];
    }
    // Get the vertex we will draw
    var v2 = morph[i];
    // Lerp to the target
    v2.lerp(v1, 0.1);
    // Check how far we are from target
    totalDistance += p5.Vector.dist(v1, v2);
  }
  
  // If all the vertices are close, switch shape
  if (totalDistance < 0.1) {
    state = !state;
  }
  
  // Draw relative to center
  translate(width/2, height/2);
  strokeWeight(4);
  // Draw a polygon that makes up all the vertices
  beginShape();
  noFill();
  stroke(255);
  for (var i = 0; i < morph.length; i++) {
    var v = morph[i];
    vertex(v.x, v.y);
  }
  endShape(CLOSE);
}

