/**
 * Relativity. 
 * 
 * Each color is perceived in relation to other colors. The top and bottom 
 * bars each contain the same component colors, but a different display order 
 * causes individual colors to appear differently. 
 */
 
var a, b, c, d, e;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  noStroke();
  a = color(165, 167, 20);
  b = color(77, 86, 59);
  c = color(42, 106, 105);
  d = color(165, 89, 20);
  e = color(146, 150, 127);
  noLoop();  // Draw only one time
}

function draw() {
  drawBand(a, b, c, d, e, 0, width/128);
  drawBand(c, a, d, b, e, height/2, width/128);
}

function drawBand(v, w, x, y, z, ypos, barWidth) {
  var num = 5;
  var colorOrder = [ v, w, x, y, z ];
  for(var i = 0; i < width; i += barWidth*num) {
    for(var j = 0; j < num; j++) {
      fill(colorOrder[j]);
      rect(i+j*barWidth, ypos, barWidth, height/2);
    }
  }
}






