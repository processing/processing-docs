/**
 * Mouse 2D. 
 * 
 * Moving the mouse changes the position and size of each box. 
 */
 
function setup() 
{
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container"); 
  noStroke();
  rectMode(CENTER);
}

function draw() 
{   
  background(51); 
  fill(255, 204);
  rect(mouseX, height/2, mouseY/2+10, mouseY/2+10);
  fill(255, 204);
  var inverseX = width-mouseX;
  var inverseY = height-mouseY;
  rect(inverseX, height/2, (inverseY/2)+10, (inverseY/2)+10);
}

