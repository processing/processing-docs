/**
 * Non-orthogonal Collision with Multiple Ground Segments 
 * by Ira Greenberg. 
 * 
 * Based on Keith Peter's Solution in
 * Foundation Actionscript Animation: Making Things Move!
 */

var orb;

var gravity;
// The ground is an array of "Ground" objects
var segments = 40;
var ground = new Array(segments);

function setup(){
  var canvas = createCanvas(640, 360);
  canvas.parent("p5container");
  gravity  = createVector(0,0.05);
  // An orb object that will fall and bounce around
  orb = new Orb(50, 50, 3);

  // Calculate ground peak heights 
  var peakHeights = new Array(segments+1);
  for (var i=0; i<peakHeights.length; i++){
    peakHeights[i] = random(height-40, height-30);
  }

  // Float value required for segment width (segs)
  // calculations so the ground spans the entire 
  // display window, regardless of segment number. 
  var segs = segments;
  for (var i=0; i<segments; i++){
    ground[i]  = new Ground(width/segs*i, peakHeights[i], width/segs*(i+1), peakHeights[i+1]);
  }
}


function draw(){
  // Background
  noStroke();
  fill(0, 15);
  rect(0, 0, width, height);
  
  // Move and display the orb
  orb.move();
  orb.display();
  // Check walls
  orb.checkWallCollision();

  // Check against all the ground segments
  for (var i=0; i<segments; i++){
    orb.checkGroundCollision(ground[i]);
  }

  
  // Draw ground
  fill(127);
  beginShape();
  for (var i=0; i<segments; i++){
    vertex(ground[i].x1, ground[i].y1);
    vertex(ground[i].x2, ground[i].y2);
  }
  vertex(ground[segments-1].x2, height);
  vertex(ground[0].x1, height);
  endShape(CLOSE);


}








