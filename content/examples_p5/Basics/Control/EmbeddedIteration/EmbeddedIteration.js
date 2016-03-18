/**
 * Embedding Iteration. 
 * 
 * Embedding "for" structures allows repetition in two dimensions. 
 *
 */

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container"); 
  background(0); 
  noStroke(); 

  var gridSize = 40;

  for (var x = gridSize; x <= width - gridSize; x += gridSize) {
    for (var y = gridSize; y <= height - gridSize; y += gridSize) {
      noStroke();
      fill(255);
      rect(x-1, y-1, 3, 3);
      stroke(255, 50);
      line(x, y, width/2, height/2);
    }
  }

  noLoop();
}