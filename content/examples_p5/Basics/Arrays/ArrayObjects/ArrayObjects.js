/**
 * Array Objects. 
 * 
 * Demonstrates the syntax for creating an array of custom objects. 
 */

var unit = 40;
var count;
var mods;

function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  noStroke();
  var wideCount = width / unit;
  var highCount = height / unit;
  count = wideCount * highCount;
  mods = [];

  var index = 0;
  for (var y = 0; y < highCount; y++) {
    for (var x = 0; x < wideCount; x++) {
      mods[index++] = new Module(x*unit, y*unit, unit/2, unit/2, random(0.05, 0.8), unit);
    }
  }
}

function draw() {
  background(0);
  for (var i = 0; i < mods.length; i++) {
    var mod = mods[i];
    mod.update();
    mod.draw();
  }
}
