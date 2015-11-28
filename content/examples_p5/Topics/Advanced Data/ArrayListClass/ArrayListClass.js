/**
 * ArrayList of objects
 * by Daniel Shiffman.  
 * 
 * This example demonstrates how to use a Java ArrayList to store 
 * a variable number of objects.  Items can be added and removed
 * from the ArrayList.
 *
 * Click the mouse to add bouncing balls.
 */

var balls = [];
var ballWidth = 48;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  noStroke();
  
  // Start by adding one element
  balls.push(new Ball(width/2, 0, ballWidth));
}

function draw() {
  background(255);

  // With an array, we say balls.length, with an ArrayList, we say balls.size()
  // The length of an ArrayList is dynamic
  // Notice how we are looping through the ArrayList backwards
  // This is because we are deleting elements from the list  
  for (var i = balls.length-1; i >= 0; i--) { 
    // An ArrayList doesn't know what it is storing so we have to cast the object coming out
    var ball = balls[i];
    ball.move();
    ball.display();
    if (ball.finished()) {
      // Items can be deleted with remove()
      balls.splice(i,1);
    }
    
  }  
  
}

function mousePressed() {
  // A new ball object is added to the ArrayList (by default to the end)
  balls.push(new Ball(mouseX, mouseY, ballWidth));
}

