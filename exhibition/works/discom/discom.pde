
cube cube11, cube12, cube13, cube14, cube21, cube22, cube23, cube24, cube31, cube32, cube33, cube34, cube41, cube42, cube43, cube44;
int[] state = {0, 0, 0, 0};
int cSpacing = 80, cOffset = 5;
button bushButton, kerryButton, cheneyButton, edwardsButton;
BImage credit;

void setup()
{
  size(cSpacing*4 + 2*cOffset,368);
  noStroke();
  fill(255);
  //framerate(30);

  cube11 = new cube(0, 0);
  cube12 = new cube(1, 0);
  cube13 = new cube(2, 0);
  cube14 = new cube(3, 0);
  cube21 = new cube(0, 1);
  cube22 = new cube(1, 1);
  cube23 = new cube(2, 1);
  cube24 = new cube(3, 1);
  cube31 = new cube(0, 2);
  cube32 = new cube(1, 2);
  cube33 = new cube(2, 2);
  cube34 = new cube(3, 2);
  cube41 = new cube(0, 3);
  cube42 = new cube(1, 3);
  cube43 = new cube(2, 3);
  cube44 = new cube(3, 3);

  bushButton = new button("bushButton.jpg", 0);
  kerryButton = new button("kerryButton.jpg", 1);
  cheneyButton = new button("cheneyButton.jpg", 2);
  edwardsButton = new button("edwardsButton.jpg", 3);

  credit = loadImage("credit.gif");

}

void loop()
{
  background(95,95,90);

  push();
  translate(170,0,0);
  //rotateY(millis()/1000.0);
  translate(-170,0,0);
  cube11.update2();
  cube12.update2();
  cube13.update2();
  cube14.update2();
  cube21.update2();
  cube22.update2();
  cube23.update2();
  cube24.update2();
  cube31.update2();
  cube32.update2();
  cube33.update2();
  cube34.update2();
  cube41.update2();
  cube42.update2();
  cube43.update2();
  cube44.update2();

  cube11.draw();
  cube12.draw();
  cube13.draw();
  cube14.draw();
  cube21.draw();
  cube22.draw();
  cube23.draw();
  cube24.draw();
  cube31.draw();
  cube32.draw();
  cube33.draw();
  cube34.draw();
  cube41.draw();
  cube42.draw();
  cube43.draw();
  cube44.draw();

  pop();
  
  bushButton.update2(); kerryButton.update2(); cheneyButton.update2(); edwardsButton.update2(); 
  bushButton.draw(); kerryButton.draw(); cheneyButton.draw(); edwardsButton.draw();

  image(credit, 5, 347);
}

void mouseReleased() {

  if(mouseX <= cOffset + cSpacing && mouseY <= cOffset + cSpacing)
  cube11.update();
  else if(mouseX <= cOffset + 2*cSpacing && mouseY <= cOffset + cSpacing)
  cube12.update();
  else if(mouseX <= cOffset + 3*cSpacing && mouseY <= cOffset + cSpacing)
  cube13.update();
  else if(mouseX <= cOffset + 4*cSpacing && mouseY <= cOffset + cSpacing)
  cube14.update();
  else if(mouseX <= cOffset + cSpacing && mouseY <= cOffset + 2*cSpacing)
  cube21.update();
  else if(mouseX <= cOffset + 2*cSpacing && mouseY <= cOffset + 2*cSpacing)
  cube22.update();
  else if(mouseX <= cOffset + 3*cSpacing && mouseY <= cOffset + 2*cSpacing)
  cube23.update();
  else if(mouseX <= cOffset + 4*cSpacing && mouseY <= cOffset + 2*cSpacing)
  cube24.update();
  else if(mouseX <= cOffset + cSpacing && mouseY <= cOffset + 3*cSpacing)
  cube31.update();
  else if(mouseX <= cOffset + 2*cSpacing && mouseY <= cOffset + 3*cSpacing)
  cube32.update();
  else if(mouseX <= cOffset + 3*cSpacing && mouseY <= cOffset + 3*cSpacing)
  cube33.update();
  else if(mouseX <= cOffset + 4*cSpacing && mouseY <= cOffset + 3*cSpacing)
  cube34.update();
  else if(mouseX <= cOffset + cSpacing && mouseY <= cOffset + 4*cSpacing)
  cube41.update();
  else if(mouseX <= cOffset + 2*cSpacing && mouseY <= cOffset + 4*cSpacing)
  cube42.update();
  else if(mouseX <= cOffset + 3*cSpacing && mouseY <= cOffset + 4*cSpacing)
  cube43.update();
  else if(mouseX <= cOffset + 4*cSpacing && mouseY <=cOffset + 4*cSpacing)
  cube44.update();
  else if(mouseX <= cOffset + cSpacing && mouseY <= cOffset + 4*cSpacing + 22) {
    bushButton.update();
    cube11.gotoMode(1); cube12.gotoMode(1); cube13.gotoMode(1); cube14.gotoMode(1);
    cube21.gotoMode(1); cube22.gotoMode(1); cube23.gotoMode(1); cube24.gotoMode(1);
    cube31.gotoMode(1); cube32.gotoMode(1); cube33.gotoMode(1); cube34.gotoMode(1);
    cube41.gotoMode(1); cube42.gotoMode(1); cube43.gotoMode(1); cube44.gotoMode(1);
  } else if(mouseX <= cOffset + 2*cSpacing && mouseY <= cOffset + 4*cSpacing + 22) {
    kerryButton.update();
    cube11.gotoMode(2); cube12.gotoMode(2); cube13.gotoMode(2); cube14.gotoMode(2);
    cube21.gotoMode(2); cube22.gotoMode(2); cube23.gotoMode(2); cube24.gotoMode(2);
    cube31.gotoMode(2); cube32.gotoMode(2); cube33.gotoMode(2); cube34.gotoMode(2);
    cube41.gotoMode(2); cube42.gotoMode(2); cube43.gotoMode(2); cube44.gotoMode(2);
  } else if(mouseX <= cOffset + 3*cSpacing && mouseY <= cOffset + 4*cSpacing + 22) {
    cheneyButton.update();  
    cube11.gotoMode(3); cube12.gotoMode(3); cube13.gotoMode(3); cube14.gotoMode(3);
    cube21.gotoMode(3); cube22.gotoMode(3); cube23.gotoMode(3); cube24.gotoMode(3);
    cube31.gotoMode(3); cube32.gotoMode(3); cube33.gotoMode(3); cube34.gotoMode(3);
    cube41.gotoMode(3); cube42.gotoMode(3); cube43.gotoMode(3); cube44.gotoMode(3);
  } else if(mouseX <= cOffset + 4*cSpacing && mouseY <= cOffset + 4*cSpacing + 22) {
    edwardsButton.update();  
    cube11.gotoMode(4); cube12.gotoMode(4); cube13.gotoMode(4); cube14.gotoMode(4);
    cube21.gotoMode(4); cube22.gotoMode(4); cube23.gotoMode(4); cube24.gotoMode(4);
    cube31.gotoMode(4); cube32.gotoMode(4); cube33.gotoMode(4); cube34.gotoMode(4);
    cube41.gotoMode(4); cube42.gotoMode(4); cube43.gotoMode(4); cube44.gotoMode(4);
  }

}

class cube{

  BImage I1 = loadImage("Bush.jpg");
  BImage I2 = loadImage("Edwards.jpg");
  BImage I3 = loadImage("Cheney.jpg");
  BImage I4 = loadImage("Kerry.jpg"); 
  int rotX, rotY;
  float rotXf, rotYf;
  float xOffset, yOffset;
  float targetRotf;
  int targetRot, targetPrez, lastTargetPrez;
  int spinMode;
  int u1, v1, u2, v2;
  // constructor
  cube( int x, int y){


    rotY = rotX = 0;
    rotXf = rotYf = 0;
    targetPrez = targetRot = 0;
    targetRotf = 0;

    xOffset = cSpacing*x+cOffset;
    yOffset = cSpacing*y+cOffset;
    spinMode = 0;
    if ((x+y)%2 == 0)
    spinMode = 1;

    u1 = x*80;
    u2 = x*80 + 80;
    
    v1 = y*80;
    v2 = y*80 + 80;

  }

  void update(){

    lastTargetPrez = targetPrez;
    targetPrez = (targetPrez+1)%4;
    targetRotf = targetPrez*180.0;
    targetRot = int(targetRotf);

  }

  void gotoMode(int mode) {

    lastTargetPrez = targetPrez;
    targetPrez = (mode -1);
    targetRotf = targetPrez*180.0;
    targetRot = int(targetRotf);

  }

  void update2() {

    while (rotXf > 360)
    rotXf -= 360;
    while (rotXf < 0)
    rotXf += 360;

    while (rotYf > 360)
    rotYf -= 360;
    while (rotYf < 0)
    rotYf += 360;

    if (spinMode == 1) {

      if (abs(rotXf - targetRotf) > 4 )
        rotXf = rotXf*0.87 + (targetRotf - rotXf)*0.13;
      else 
        rotXf = 0;

      rotX = int(rotXf);

    } else if (spinMode == 0) {

      if (abs(rotYf - targetRotf) > 4)
      rotYf = rotYf*0.87 + (targetRotf - rotYf)*0.13;
      else
      rotYf = 0;

      rotY = int(rotYf);
    }

    if (abs(rotX) < 3)
      rotX = 0;
      
    if (abs(rotY) < 3)
      rotY = 0;

            
  }

  void draw(){

    stroke(100,50,20);
    push();
    if(spinMode == 0) {
      translate(40,0,abs(40.0*sin(rotY*PI/90.0)));
    } else {
      translate(0,40,abs(40.0*sin(rotX*PI/90.0)));
    }

    push();
    translate(xOffset, yOffset, -40);

    if(spinMode == 0) {
      rotateY(rotY*PI/180.0);
      translate(-40,0,40);
    } else {
      rotateX(rotX*PI/180.0);
      translate(0,-40,40);
    }

    beginShape(QUADS);

    texture(I1);
    vertex(0,0,0, u1, v1);
    vertex(80,0,0, u2, v1);
    vertex(80,80,0, u2, v2);
    vertex(0, 80,0, u1, v2);
    endShape();

    beginShape(QUADS);
    texture(I2);
    vertex(80, 0,0, u1, v1);
    vertex(80, 0,-80, u2, v1);
    vertex(80, 80,-80, u2, v2);
    vertex(80, 80,0, u1, v2);
    endShape();

    if(spinMode == 0) {

      beginShape(QUADS);
      texture(I3);
      vertex(80, 0,  -80, u1, v1);
      vertex(0,  0,  -80, u2, v1);
      vertex(0,  80, -80, u2, v2);
      vertex(80, 80, -80, u1, v2);
      endShape();

    } else {

      beginShape(QUADS);
      texture(I3);
      vertex(80, 0,  -80, u2, v2);
      vertex(0,  0,  -80, u1, v2);
      vertex(0,  80, -80, u1, v1);
      vertex(80, 80, -80, u2, v1);
      endShape();

    }

    beginShape(QUADS);
    texture(I4);
    vertex(0, 0,-80,   u1, v1);
    vertex(0, 0, 0,    u2, v1);
    vertex(0, 80, 0,   u2, v2);
    vertex(0, 80, -80, u1, v2);
    endShape();

    if(spinMode == 0 ) {

      beginShape(QUADS);
      texture(I4);
      vertex(0,  0,  0,  u1, v1);
      vertex(80, 0,  0,  u2, v1);
      vertex(80, 0, -80, u2, v2);
      vertex(0,  0, -80, u1, v2);
      endShape();

    } else {

      beginShape(QUADS);
      texture(I2);
      vertex(0, 0,  0, u1, v2);
      vertex(80, 0, 0, u2, v2);
      vertex(80, 0, -80, u2, v1);
      vertex(0, 0,  -80, u1, v1);
      endShape();

    }

    beginShape(QUADS);
    texture(I4);
    vertex(0, 80,  0,   u1, v1);
    vertex(80, 80, 0,   u2, v1);
    vertex(80, 80, -80, u2, v2);
    vertex(0, 80, -80,  u1, v2);
    endShape();

    pop();
    pop();

  }

}

class button{

  BImage I;
  int rotX;
  float rotXf;
  int xOffset, yOffset;
  float targetRotf;
  int targetRot;

  // constructor
  button(String s1, int x){

    I = loadImage(s1);

    rotX = 0;
    rotXf = 0;
    xOffset = cSpacing*x+cOffset;
    yOffset = cSpacing*4+cOffset;

  }

  void update(){

    rotX += 6;

  }

  void update2() {

    if (rotX%90 != 0)
      rotX += 6;

  }

  void draw(){

    stroke(100,50,20);
    push();

    translate(0,10,abs(20.0*sin(rotX*PI/90.0)));

    push();
    translate(xOffset, yOffset, -10);

    rotateX(rotX*PI/180.0);
    translate(0,-10,10);

    beginShape(QUADS);

    texture(I);

    vertex(0,0, 0, 0, 0);
    vertex(80,0, 0, 80, 0);
    vertex(80,20, 0, 80, 20);
    vertex(0, 20, 0, 0, 20);

    vertex(0, 0,  0,    0, 20);
    vertex(80, 0, 0,   80, 20);
    vertex(80, 0, -20, 80, 0);
    vertex(0, 0,  -20,     0, 0);

    vertex(0,  0,  -20, 0, 20);
    vertex(80,  0,  -20, 80, 20);
    vertex(80,  20, -20, 80,  0);
    vertex(0, 20, -20, 0, 0);

    vertex(0,  20, -20, 0, 20);
    vertex(80, 20, -20, 80, 20);
    vertex(80, 20,   0,  80, 0);
    vertex(0,  20,   0, 0, 0);
    endShape();

    pop();

    pop();

  }

}

