/**
 * Pulses. 
 * 
 * Software drawing instruments can follow a rhythm or abide by rules independent
 * of drawn gestures. This is a form of collaborative drawing in which the draftsperson
 * controls some aspects of the image and the software controls others.
 */

var angle = 0;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  background(102);
  noStroke();
  fill(0, 102);
}

function draw() {
  // Draw only when mouse is pressed
  if (mouseIsPressed == true) {
    angle += 5;
    var val = cos(radians(angle)) * 12.0;
    for (var a = 0; a < 360; a += 75) {
      var xoff = cos(radians(a)) * val;
      var yoff = sin(radians(a)) * val;
      fill(0);
      ellipse(mouseX + xoff, mouseY + yoff, val, val);
    }
    fill(255);
    ellipse(mouseX, mouseY, 2, 2);
  }
}
