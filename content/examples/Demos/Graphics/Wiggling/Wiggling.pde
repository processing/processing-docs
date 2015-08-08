// Press 'w' to start wiggling, space to restore
// original positions.

PShape cube;
float cubeSize = 320;
float circleRad = 100;
int circleRes = 40;
float noiseMag = 1;

boolean wiggling = false;

void setup() {
  size(1024, 768, P3D);    

  createCube();
}

void draw() {
  background(0);

  translate(width/2, height/2);
  rotateX(frameCount * 0.01f);
  rotateY(frameCount * 0.01f);

  shape(cube);

  if (wiggling) {
    PVector pos = null;
    for (int i = 0; i < cube.getChildCount(); i++) {
      PShape face = cube.getChild(i);
      for (int j = 0; j < face.getVertexCount(); j++) {
        pos = face.getVertex(j, pos);
        pos.x += random(-noiseMag/2, +noiseMag/2);
        pos.y += random(-noiseMag/2, +noiseMag/2);
        pos.z += random(-noiseMag/2, +noiseMag/2);
        face.setVertex(j, pos.x, pos.y, pos.z);
      }
    }
  }

  if (frameCount % 60 == 0) println(frameRate);
}

public void keyPressed() {
  if (key == 'w') {
    wiggling = !wiggling;
  } else if (key == ' ') {
    restoreCube();
  } else if (key == '1') {
    cube.setStrokeWeight(1);
  } else if (key == '2') {
    cube.setStrokeWeight(5);
  } else if (key == '3') {
    cube.setStrokeWeight(10);
  }
}

void createCube() {
  cube = createShape(GROUP);  

  PShape face;

  // Create all faces at front position
  for (int i = 0; i < 6; i++) {
    face = createShape();
    createFaceWithHole(face);
    cube.addChild(face);
  }

  // Rotate all the faces to their positions

  // Front face - already correct
  face = cube.getChild(0);

  // Back face
  face = cube.getChild(1);
  face.rotateY(radians(180));

  // Right face
  face = cube.getChild(2);
  face.rotateY(radians(90));

  // Left face
  face = cube.getChild(3);
  face.rotateY(radians(-90));

  // Top face
  face = cube.getChild(4);
  face.rotateX(radians(90));

  // Bottom face
  face = cube.getChild(5);
  face.rotateX(radians(-90));
}

void createFaceWithHole(PShape face) {
  face.beginShape(POLYGON);
  face.stroke(255, 0, 0);
  face.fill(255);

  // Draw main shape Clockwise
  face.vertex(-cubeSize/2, -cubeSize/2, +cubeSize/2);
  face.vertex(+cubeSize/2, -cubeSize/2, +cubeSize/2);
  face.vertex(+cubeSize/2, +cubeSize/2, +cubeSize/2);
  face.vertex(-cubeSize / 2, +cubeSize / 2, +cubeSize / 2);

  // Draw contour (hole) Counter-Clockwise
  face.beginContour();
  for (int i = 0; i < circleRes; i++) {
    float angle = TWO_PI * i / circleRes;
    float x = circleRad * sin(angle);
    float y = circleRad * cos(angle);
    float z = +cubeSize/2;
    face.vertex(x, y, z);
  }
  face.endContour();

  face.endShape(CLOSE);
}

void restoreCube() {
  // Rotation of faces is preserved, so we just reset them
  // the same way as the "front" face and they will stay
  // rotated correctly
  for (int i = 0; i < 6; i++) {
    PShape face = cube.getChild(i);
    restoreFaceWithHole(face);
  }
}

void restoreFaceWithHole(PShape face) {
  face.setVertex(0, -cubeSize/2, -cubeSize/2, +cubeSize/2);
  face.setVertex(1, +cubeSize/2, -cubeSize/2, +cubeSize/2);
  face.setVertex(2, +cubeSize/2, +cubeSize/2, +cubeSize/2);
  face.setVertex(3, -cubeSize/2, +cubeSize/2, +cubeSize/2);
  for (int i = 0; i < circleRes; i++) {
    float angle = TWO_PI * i / circleRes;
    float x = circleRad * sin(angle);
    float y = circleRad * cos(angle);
    float z = +cubeSize/2;
    face.setVertex(4 + i, x, y, z);
  }
}