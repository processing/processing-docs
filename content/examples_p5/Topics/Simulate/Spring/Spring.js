/**
 * Spring. 
 * 
 * Click, drag, and release the horizontal bar to start the spring. 
 */
 
// Spring drawing constants for top bar
var springHeight = 32;  // Height
var left = 0;               // Left position
var right = 0;              // Right position
var maxVal = 200;          // Maximum Y value
var minVal = 100;          // Minimum Y value
var over = false;   // If mouse over
var move = false;   // If mouse down and over

// Spring simulation constants
var M = 0.8;   // Mass
var K = 0.2;   // Spring constant
var D = 0.92;  // Damping
var R = 150;   // Rest position

// Spring simulation variables
var ps = R;    // Position
var vs = 0.0;  // Velocity
var as = 0;    // Acceleration
var f = 0;     // Force


function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  rectMode(CORNERS);
  noStroke();
  left = width/2 - 100;
  right = width/2 + 100;
}

function draw() {
  background(102);
  updateSpring();
  drawSpring();
}

function drawSpring() {
  
  // Draw base
  fill(0.2);
  var baseWidth = 0.5 * ps + -8;
  rect(width/2 - baseWidth, ps + springHeight, width/2 + baseWidth, height);

  // Set color and draw top bar
  if(over || move) { 
    fill(255);
  } else { 
    fill(204);
  }
  rect(left, ps, right, ps + springHeight);
}


function updateSpring() {
  // Update the spring position
  if(!move) {
    f = -K * (ps - R);    // f=-ky
    as = f / M;           // Set the acceleration, f=ma == a=f/m
    vs = D * (vs + as);   // Set the velocity
    ps = ps + vs;         // Updated position
  }
  if(abs(vs) < 0.1) {
    vs = 0.0;
  }

  // Test if mouse is over the top bar
  if(mouseX > left && mouseX < right && mouseY > ps && mouseY < ps + springHeight) {
    over = true;
  } else {
    over = false;
  }
  
  // Set and constrain the position of top bar
  if(move) {
    ps = mouseY - springHeight/2;
    ps = constrain(ps, minVal, maxVal);
  }
}

function mousePressed() {
  if(over) {
    move = true;
  }
}

function mouseReleased() {
  move = false;
}
