/**
 * Distance 2D. 
 * 
 * Move the mouse across the image to obscure and reveal the matrix.  
 * Measures the distance from the mouse to each square and sets the
 * size proportionally. 
 */
 
var max_distance;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container"); 
  noStroke();
  max_distance = dist(0, 0, width, height);
}

function draw() 
{
  background(0);

  for(var i = 0; i <= width; i += 20) {
    for(var j = 0; j <= height; j += 20) {
      var size = dist(mouseX, mouseY, i, j);
      size = size/max_distance * 66;
      ellipse(i, j, size, size);
    }
  }
}
