/**
 * Save One Image
 * 
 * The save() function allows you to save an image from the 
 * display window. In this example, save() is run when a mouse
 * button is pressed. The image "line.tif" is saved to the 
 * same folder as the sketch's program file.
 */

function setup() {
  var canvas = createCanvas(200, 200);
  canvas.parent("p5container");
}

function draw() {
  background(204);
  line(0, 0, mouseX, height);
  line(width, 0, 0, mouseY);
}

function mousePressed() {
  save("line.tif");
}
