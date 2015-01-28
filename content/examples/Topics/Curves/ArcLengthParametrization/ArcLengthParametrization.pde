/*
  Arc Length parametrization of curves by Jakub Valtar

  This example shows how to divide a curve into segments
  of an equal length and how to move along the curve with
  constant speed.

  To demonstrate the technique, a cubic Bézier curve is used.
  However, this technique is applicable to any kind of
  parametric curve.
*/

BezierCurve curve;

PVector[] points;
PVector[] equidistantPoints;

float t = 0.0;
float tStep = 0.004;

final int POINT_COUNT = 80;

int borderSize = 40;

void setup() {
  size(640, 360, P2D);
  
  frameRate(60);
  smooth(8);
  textAlign(CENTER);
  textSize(16);
  strokeWeight(2);
  
  PVector a = new PVector(   0, 300);
  PVector b = new PVector( 440,   0);
  PVector c = new PVector(-200,   0);
  PVector d = new PVector( 240, 300);

  curve = new BezierCurve(a, b, c, d);
  
  points = curve.points(POINT_COUNT);
  equidistantPoints = curve.equidistantPoints(POINT_COUNT);
}


void draw() {
  
  // Show static value when mouse is pressed, animate otherwise
  if (mousePressed) {
    int a = constrain(mouseX, borderSize, width - borderSize);
    t = map(a, borderSize, width - borderSize, 0.0, 1.0);
  } else {
    t += tStep;
    if (t > 1.0) t = 0.0;
  }
  
  background(255);
  
  
  // draw curve and circle using standard parametrization
  pushMatrix();
    translate(borderSize, -50);
    
    labelStyle();
    text("STANDARD\nPARAMETRIZATION", 120, 310);
    
    curveStyle();
    beginShape(LINES);
      for (int i = 0; i < points.length - 1; i += 2) {
        vertex(points[i].x, points[i].y);
        vertex(points[i+1].x, points[i+1].y);
      }
    endShape();
    
    circleStyle();
    PVector pos1 = curve.pointAtParameter(t);
    ellipse(pos1.x, pos1.y, 12, 12);
    
  popMatrix();
  
  
  // draw curve and circle using arc length parametrization
  pushMatrix();
    translate(width/2 + borderSize, -50);
    
    labelStyle();
    text("ARC LENGTH\nPARAMETRIZATION", 120, 310);
    
    curveStyle();
    beginShape(LINES);
      for (int i = 0; i < equidistantPoints.length - 1; i += 2) {
        vertex(equidistantPoints[i].x, equidistantPoints[i].y);
        vertex(equidistantPoints[i+1].x, equidistantPoints[i+1].y);
      }
    endShape();
    
    circleStyle();
    PVector pos2 = curve.pointAtFraction(t);
    ellipse(pos2.x, pos2.y, 12, 12);
    
  popMatrix();
  
  
  // draw seek bar
  pushMatrix();
    translate(borderSize, height - 45);
    
    int barLength = width - 2 * borderSize;
  
    barBgStyle();
    line(0, 0, barLength, 0);
    line(barLength, -5, barLength, 5);
    
    barStyle();
    line(0, -5, 0, 5);
    line(0, 0, t * barLength, 0);
    
    barLabelStyle();
    text(nf(t, 0, 2), barLength/2, 25);
  popMatrix();
  
}


// Styles -----

void curveStyle() {
  stroke(170);
  noFill();
}

void labelStyle() {
  noStroke();
  fill(120);
}

void circleStyle() {
  noStroke();
  fill(0);
}

void barBgStyle() {
  stroke(220);
  noFill();
}

void barStyle() {
  stroke(50);
  noFill();
}

void barLabelStyle() {
  noStroke();
  fill(120);
}



