/**
 * Color Variables (Homage to Albers). 
 * 
 * This example creates variables for colors that may be referred to 
 * in the program by a name, rather than a number. 
 */

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  noStroke();
  background(51, 0, 0);

  var inside = color(204, 102, 0);
  var middle = color(204, 153, 0);
  var outside = color(153, 51, 0);

  // These statements are equivalent to the statements above.
  // Programmers may use the format they prefer.
  //color inside = #CC6600;
  //color middle = #CC9900;
  //color outside = #993300;

  push();
  translate(80, 80);
  fill(outside);
  rect(0, 0, 200, 200);
  fill(middle);
  rect(40, 60, 120, 120);
  fill(inside);
  rect(60, 90, 80, 80);
  pop();

  push();
  translate(360, 80);
  fill(inside);
  rect(0, 0, 200, 200);
  fill(outside);
  rect(40, 60, 120, 120);
  fill(middle);
  rect(60, 90, 80, 80);
  pop();

  noLoop();
}
