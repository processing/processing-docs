/**
 * Circle Collision with Swapping Velocities
 * by Ira Greenberg. 
 * 
 * Based on Keith Peter's Solution in
 * Foundation Actionscript Animation: Making Things Move!
 */
 
var balls;
function setup() {
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  balls =  [
  new Ball(100, 400, 20), 
  new Ball(700, 400, 80) 
];

}

function draw() {
  background(51);

  for (var i = 0; i < balls.length; i++) {
    var b = balls[i];
    b.update();
    b.display();
    b.checkBoundaryCollision();
  }
  
  balls[0].checkCollision(balls[1]);
}




