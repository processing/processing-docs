/**
 * Brownian motion. 
 * 
 * Recording random movement as a continuous line. 
 */
 
var num = 2000;
var range = 6;

var ax = [];
var ay = []; 


function setup() 
{
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  for(var i = 0; i < num; i++) {
    ax[i] = width/2;
    ay[i] = height/2;
  }
  frameRate(30);
}

function draw() 
{
  background(51);
  
  // Shift all elements 1 place to the left
  for(var i = 1; i < num; i++) {
    ax[i-1] = ax[i];
    ay[i-1] = ay[i];
  }

  // Put a new value at the end of the array
  ax[num-1] += random(-range, range);
  ay[num-1] += random(-range, range);

  // Constrain all points to the screen
  ax[num-1] = constrain(ax[num-1], 0, width);
  ay[num-1] = constrain(ay[num-1], 0, height);
  
  // Draw a line connecting the points
  for(var i=1; i<num; i++) {    
    var val = float(i)/num * 204.0 + 51;
    stroke(val);
    line(ax[i-1], ay[i-1], ax[i], ay[i]);
  }
}
