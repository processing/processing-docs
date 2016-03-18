/**
 * Regular Polygon
 * 
 * What is your favorite? Pentagon? Hexagon? Heptagon? 
 * No? What about the icosagon? The polygon() function 
 * created for this example is capable of drawing any 
 * regular polygon. Try placing different numbers into the 
 * polygon() function calls within draw() to explore. 
 */

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
}

function draw() {
  background(102);
  
  push();
  translate(width*0.2, height*0.5);
  rotate(frameCount / 200.0);
  polygon(0, 0, 82, 3); 
  pop();
  
  push();
  translate(width*0.5, height*0.5);
  rotate(frameCount / 50.0);
  polygon(0, 0, 80, 20); 
  pop();
  
  push();
  translate(width*0.8, height*0.5);
  rotate(frameCount / -100.0);
  polygon(0, 0, 70, 7); 
  pop();
}

function polygon(x, y, radius, npoints) {
  var angle = TWO_PI / npoints;
  beginShape();
  for (var a = 0; a < TWO_PI; a += angle) {
    var sx = x + cos(a) * radius;
    var sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
