// This project was built with MultiProcessing and
// will not execute with the standard Processing software.
// MultiProcessing was developed by Simon Greenwold for the 
// course 872a Model Based Design at the Yale School of 
// Architecture in Winter 2003


//  Matthew Jogan matthew.jogan@yale.edu
//  872a _ Model Based Design - Yale School of Architecture
//  FINAL PROJECT  - December 19 2003
//  Professor = Simon Greenwold

// VERSION B - Uses perlin noise as randomizer for deformations.
// Yellow Sliders control amplifications of undulations in the "X" and "Y" coordinates 
// Press keys 1 thru 6 for various visualizations of affected particles and t  

int numOuterLayers = 0;
int numInnerLayers = 0;
int numAttachedLayers = 0;

ParticleArm2 partArm2 = new ParticleArm2();
class ParticleArm2 extends Particle {
public ParticleArm2() {}

  float startX, startY, startZ;
  float offsetX, offsetY, offsetZ;

  void setup() {
    fixed = true;
  }

  void firstLoop() {
    startX = pos[0];
    startY = pos[1];
    startZ = pos[2];
  }

  void loop() {
    push();

    DXFlayer(2);

    float divisorS = 500.0 - slider3X;
  
    
    //float und = 1 + sin(age/divisorS);
    //offsetX = startX * und * (slider2X-SLIDER_2_LEFT)*2/500;
    //offsetY = 0;
    //offsetZ = startZ * und * (slider1X-SLIDER_1_LEFT)*2/500;

    offsetX = startX * noise(age/10.0) * (slider2X-SLIDER_2_LEFT)*2/300; // noise(age/50.0)
    offsetY = 0;
    offsetZ = startZ * noise(age/10.0) * (slider1X-SLIDER_1_LEFT)*2/300; // noise(age/50.0)

    pos[0] = startX + offsetX;
    pos[1] = startY + offsetY;
    pos[2] = startZ + offsetZ;

    translate(width, 1.5 * height);
    arcball.run();

    translate(pos[0], pos[1], pos[2]);
    noStroke();
    
    if ((this != dummyP) && (RenderKey == 2)) {
      fill(#FF0000);
      box( 3, 3, 3);
    } else if ((this != dummyP) && (RenderKey == 4 || RenderKey == 5)) {
      noFill();
    } else if ((this != dummyP) && (RenderKey == 1 || RenderKey == 6)){
      fill(#FF0000);
      box( 3, 3, 3);
      }

    //if (this != dummyP) box (5,5,5);

    pop();

  }
}

BoxParticle boxPart = new BoxParticle();
class BoxParticle extends Particle {
public BoxParticle() {}

  void setup() {
  }

  void firstLoop() {
  }

  void loop() {
    push();
    translate(width, 1.5 * height);
    arcball.run();

    translate(pos[0], pos[1], pos[2]);
    noStroke();
    if (fixed) {
      fill(#FF0000);
      box(3, 3, 3);
    }else if (RenderKey == 3 || RenderKey == 4) {
      //fill (140, 80, 190, 150);
      fill (245, 167, 63, 200);// orange fill
      box(3, 3, 3);
    } else  {
      noFill();
    }
    
    pop();
  }
}

//ColorSpring = springs for Inner Rings
class ColorSpring extends Spring {

  float EPSILON = .01;

  ColorSpring(Particle a, Particle b) {
    super(a, b);
  }

  void draw() {
    float pL =  dist(a.pos[0], a.pos[1], a.pos[2], b.pos[0], b.pos[1], b.pos[2]);

    float xC = (dist(a.pos[0], a.pos[1], a.pos[2], b.pos[0], b.pos[1], b.pos[2])/restLength)*29;

    color longColor = color(xC*7, 50, 70, 200);  //xC*1.7
    color shortColor = color(0, 200,xC*8);
    color restColor = color(255, 255, 255, 150);

    if (abs(pL - restLength) < EPSILON) {
      stroke (restColor);
    }
    else if (pL < restLength){
      stroke (shortColor);
    } else {
      stroke (longColor);
    }

    //line(a.pos[0], a.pos[1], a.pos[2], b.pos[0], b.pos[1], b.pos[2]);
    if ((RenderKey == 1) || (RenderKey == 4) || (RenderKey == 6)) {
    super.draw(); // calls draw function from extended class Spring
    }
  }
}

//ColorSpringB = springs for connection of Inner and Outer Rings
class ColorSpringB extends Spring {

  float EPSILON = .01;

  ColorSpringB(Particle a, Particle b) {
    super(a, b);
  }

  void draw() {
    float pL =  dist(a.pos[0], a.pos[1], a.pos[2], b.pos[0], b.pos[1], b.pos[2]);

    float xC = (dist(a.pos[0], a.pos[1], a.pos[2], b.pos[0], b.pos[1], b.pos[2])/restLength)*29;

    color longColor = color(150, 90, xC*7, 150);  
    color shortColor = color(41, 205, xC*7, 140);
    color restColor = color(255, 255, 255, 100);
    
    //color longColor = color(xC*7, 50, 70, 150);  //xC*1.7
    //color shortColor = color(0, 200,xC*8);
    //color restColor = color(255, 255, 255, 150);

    if (abs(pL - restLength) < EPSILON) {
      stroke (restColor);
    }
    else if (pL < restLength){
      stroke (shortColor);
    } else {
      stroke (longColor);
    }

    //line(a.pos[0], a.pos[1], a.pos[2], b.pos[0], b.pos[1], b.pos[2]);
     if (RenderKey == 1 || RenderKey == 5 || RenderKey == 6) {
    super.draw(); // calls draw function from extended class Spring
  }
 }
}

// GLOBAL CONSTANTS

// Size of window
final int X_SIZE = 750;
final int Y_SIZE = 500;

final int OUTERLAYERS = 10;  // number of layers in outer ring - ArrayIndexOutOfBoundsException: (get error over 10)
final int INNERLAYERS = 10;  // number of layers in inner ring - ArrayIndexOutOfBoundsException: (get error over 10)

final int OUTERRAD = 321; //Radius of outer particle ring
final int INNERRAD = 50;  // Radius of inner particle ring

final int OUTERRINGSPACE = 40;
final int INNERRINGSPACE = 50;

float SpringS = 0.25;
int RestL   = 1;

boolean   clickInSlider = false;

final int SLIDER_1_LEFT = 30;
final int SLIDER_1_TOP = 10;
final int SLIDER_1_WIDTH = 200;
final int SLIDER_1_HEIGHT = 13;

int slider1X = SLIDER_1_LEFT;

final int SLIDER_2_LEFT = 275;
final int SLIDER_2_TOP = 10;
final int SLIDER_2_WIDTH = 200;
final int SLIDER_2_HEIGHT = 13;

int slider2X = SLIDER_2_LEFT;

final int SLIDER_3_LEFT = 520;
final int SLIDER_3_TOP = 10;
final int SLIDER_3_WIDTH = 200;
final int SLIDER_3_HEIGHT = 13;

int slider3X = SLIDER_3_LEFT + SLIDER_3_WIDTH/2;

ArcBall arcball;

int SLICES = 36;

int totalLayer = 1;
int yLayer;

int NUM_IN_X = SLICES;
int NUM_IN_Y = 10;

int  yIndex;
int someYvariable;
float yGen;

int RenderKey = 1;

ColorSpring t;
ColorSpring u;

Particle outerArray[][] = new Particle[NUM_IN_X][NUM_IN_Y];
Particle innerArray[][] = new Particle[NUM_IN_X][NUM_IN_Y];

Particle particles[] = new Particle[12];

int AttachRestL;

void spawnOuterRing(float z, float x, float radius, int layer) {

  Particle p;
  float rotInc = TWO_PI / SLICES;
  float rot = 0;

  for (int r = 0; r < SLICES; r++) {

    outerArray[r][layer] = spawnParticle(partArm2, radius * cos(rot) + x , z, radius * sin(rot) );
    rot += rotInc;

    //Original code - mj
    //if (r > 0) {
      //  t = new ColorSpring (particleArray[r][yGen], particleArray[r-1][yGen]);
      //  pSystem.addForce(t);
    //}
  }

  if (layer >= numOuterLayers) {
    numOuterLayers = layer + 1;
  }

  if (numOuterLayers > numAttachedLayers && numInnerLayers > numAttachedLayers) {
    for (int aLayer = numAttachedLayers; aLayer < min(numOuterLayers, numInnerLayers); aLayer++) {
      attachLayer(aLayer);
    }
  }

}

void spawnInnerRing(float z, float x, float radius, int layer) {

  Particle p;
  float rotInc = TWO_PI / SLICES;
  float rot = 0;

  for (int r = 0; r < SLICES; r++) {
       

    innerArray[r][layer] = spawnParticle(boxPart, radius * cos(rot) + x , z, radius * sin(rot) );
    rot += rotInc;

    //connect rings vertically with springs
    if (layer > 0) {
      t = new ColorSpring (innerArray[r][layer], innerArray[r][layer-1]);
      pSystem.addForce(t);
      t.restLength = 20;
      t.strength = 1;
    }
    // spring loop
    if (r > 0) {
      t = new ColorSpring (innerArray[r][layer], innerArray[r-1][layer]);
      pSystem.addForce(t);
      t.restLength = 11;
       t.strength = 1;
    }
  }
  // close spring loop
  t = new ColorSpring (innerArray[0][layer], innerArray[SLICES-1][layer]);
  pSystem.addForce(t);
  t.restLength = 11;

  if (layer >= numInnerLayers) {
    numInnerLayers = layer + 1;
  }

  if (numOuterLayers > numAttachedLayers && numInnerLayers > numAttachedLayers) {
    for (int aLayer = numAttachedLayers; aLayer < min(numOuterLayers, numInnerLayers); aLayer++) {
      attachLayer(aLayer);
    }
  }

}

Particle dummyP;

void firstLoop() {

  //defaultSpringRestLength(RestL);
  defaultSpringStrength(SpringS);
  defaultSpringDamping(0.5);

  scale(0.5, 0.5, 0.5);
  dummyP = spawnParticle(partArm2, 0, 0, 0);

  //scale(0.5, 0.5, 0.5);
  translate(width, 1.5 * height);

}

void setup() {

  enableDXFwrite("testOut.dxf", 'w');
  gravity(0);

  background(255);
  size(X_SIZE, Y_SIZE);

  noLights();
  //lights();
  arcball = new ArcBall(X_SIZE/2, Y_SIZE/2, X_SIZE);

}

boolean inRect(float x, float y, float left, float top, float w, float h) {

  if (x < left) return false;
  if (x > left + w) return false;
  if (y < top) return false;
  if (y > top + h) return false;

  return true;
}

void mousePressed()
{
  if (! inRect(mouseX, mouseY,
  SLIDER_1_LEFT,
  SLIDER_1_TOP,
  SLIDER_1_WIDTH,
  SLIDER_1_HEIGHT)
  && !inRect(mouseX, mouseY,
  SLIDER_2_LEFT,
  SLIDER_2_TOP,
  SLIDER_2_WIDTH,
  SLIDER_2_HEIGHT)
  && !inRect(mouseX, mouseY,
  SLIDER_3_LEFT,
  SLIDER_3_TOP,
  SLIDER_3_WIDTH,
  SLIDER_3_HEIGHT)) {
    arcball.mousePressed();
  }

  if (inRect(mouseX, mouseY,
  SLIDER_1_LEFT,
  SLIDER_1_TOP,
  SLIDER_1_WIDTH,
  SLIDER_1_HEIGHT)) {
    slider1X = mouseX;
    clickInSlider = true;
  }

  if (inRect(mouseX, mouseY,
  SLIDER_2_LEFT,
  SLIDER_2_TOP,
  SLIDER_2_WIDTH,
  SLIDER_2_HEIGHT)) {
    slider2X = mouseX;
    clickInSlider = true;
  }
  if (inRect(mouseX, mouseY,
  SLIDER_3_LEFT,
  SLIDER_3_TOP,
  SLIDER_3_WIDTH,
  SLIDER_3_HEIGHT)) {
    slider3X = mouseX;
    clickInSlider = true;
  }

}

void mouseReleased() {
  clickInSlider = false;
}

void mouseDragged()
{
  if (!clickInSlider &&
  !inRect(mouseX, mouseY,
  SLIDER_1_LEFT,
  SLIDER_1_TOP,
  SLIDER_1_WIDTH,
  SLIDER_1_HEIGHT)
  && !inRect(mouseX, mouseY,
  SLIDER_2_LEFT,
  SLIDER_2_TOP,
  SLIDER_2_WIDTH,
  SLIDER_2_HEIGHT)
  &&!inRect(mouseX, mouseY,
  SLIDER_3_LEFT,
  SLIDER_3_TOP,
  SLIDER_3_WIDTH,
  SLIDER_3_HEIGHT)) {
    arcball.mouseDragged();
  }

  if (inRect(mouseX, mouseY,
  SLIDER_1_LEFT,
  SLIDER_1_TOP,
  SLIDER_1_WIDTH,
  SLIDER_1_HEIGHT)) {
    slider1X = mouseX;
  }

  if (inRect(mouseX, mouseY,
  SLIDER_2_LEFT,
  SLIDER_2_TOP,
  SLIDER_2_WIDTH,
  SLIDER_2_HEIGHT)) {
    slider2X = mouseX;
  }
  if (inRect(mouseX, mouseY,
  SLIDER_3_LEFT,
  SLIDER_3_TOP,
  SLIDER_3_WIDTH,
  SLIDER_3_HEIGHT)) {
    slider3X = mouseX;
  }

}



void attachLayer(int layer) {
  
  

  for (int i = 0; i < SLICES; i++) {
    ColorSpringB u = new ColorSpringB (innerArray[i][layer], outerArray[i][layer]);
    pSystem.addForce(u);
    u.restLength = (AttachRestL);
    u.strength = 0.8;


  }
  numAttachedLayers = layer+1;
}

void drawInnerSurface(int layer) {

  DXFlayer(3);
  for (int layerIndex = 0; layerIndex < layer-1; layerIndex++ ) {
    for (int r = 0; r < SLICES-1; r++) {

     //stroke (240, 50, 70, 150); //redish stroke
      stroke (63, 214, 236, 60); // blue-ish stroke
      fill (135, 80, 190, 150); // purple fill

      //beginShape(TRIANGLE_STRIP);
      beginShape(QUADS);
      vertex(innerArray[r][layerIndex].pos[0],
      innerArray[r][layerIndex].pos[1],
      innerArray[r][layerIndex].pos[2]);
      vertex(innerArray[r][layerIndex+1].pos[0],
      innerArray[r][layerIndex+1].pos[1],
      innerArray[r][layerIndex+1].pos[2]);
      vertex(innerArray[r+1][layerIndex+1].pos[0],
      innerArray[r+1][layerIndex+1].pos[1],
      innerArray[r+1][layerIndex+1].pos[2]);
      vertex(innerArray[r+1][layerIndex].pos[0],
      innerArray[r+1][layerIndex].pos[1],
      innerArray[r+1][layerIndex].pos[2]);
      endShape();
    }
    // close surface of cylinder
    beginShape(QUADS);
    vertex (innerArray[SLICES-1][layerIndex].pos[0], innerArray[SLICES-1][layerIndex].pos[1], innerArray[SLICES-1][layerIndex].pos[2]);
    vertex (innerArray[SLICES-1][layerIndex+1].pos[0], innerArray[SLICES-1][layerIndex+1].pos[1], innerArray[SLICES-1][layerIndex+1].pos[2]);
    vertex (innerArray[0][layerIndex+1].pos[0], innerArray[0][layerIndex+1].pos[1], innerArray[0][layerIndex+1].pos[2]);
    vertex (innerArray[0][layerIndex].pos[0], innerArray[0][layerIndex].pos[1], innerArray[0][layerIndex].pos[2]);
    endShape();

  }
}

void drawOuterSurface(int layer) {
  DXFlayer(4);
  for (int layerIndex = 0; layerIndex < layer-1; layerIndex++ ) {
    for (int r = 0; r < SLICES-1; r++) {

      int xAlpha = (slider3X - SLIDER_3_LEFT); 
     
     stroke(243, 171, 229, (xAlpha + 20)); //  pinkish-grey stroke
      fill(243, 171, 229, xAlpha-10); // pinkish-grey fill

      beginShape(TRIANGLE_STRIP);
      //beginShape(QUADS);
      vertex(outerArray[r][layerIndex].pos[0],
      outerArray[r][layerIndex].pos[1],
      outerArray[r][layerIndex].pos[2]);
      vertex(outerArray[r][layerIndex+1].pos[0],
      outerArray[r][layerIndex+1].pos[1],
      outerArray[r][layerIndex+1].pos[2]);
      vertex(outerArray[r+1][layerIndex].pos[0],
      outerArray[r+1][layerIndex].pos[1],
      outerArray[r+1][layerIndex].pos[2]);
      vertex(outerArray[r+1][layerIndex+1].pos[0],
      outerArray[r+1][layerIndex+1].pos[1],
      outerArray[r+1][layerIndex+1].pos[2]);
      endShape();
    }
    // close surface of cylinder
    beginShape(TRIANGLE_STRIP);
    //beginShape(QUADS);
    vertex (outerArray[SLICES-1][layerIndex].pos[0], outerArray[SLICES-1][layerIndex].pos[1], outerArray[SLICES-1][layerIndex].pos[2]);
    vertex (outerArray[SLICES-1][layerIndex+1].pos[0], outerArray[SLICES-1][layerIndex+1].pos[1], outerArray[SLICES-1][layerIndex+1].pos[2]);
    vertex (outerArray[0][layerIndex].pos[0], outerArray[0][layerIndex].pos[1], outerArray[0][layerIndex].pos[2]);
    vertex (outerArray[0][layerIndex+1].pos[0], outerArray[0][layerIndex+1].pos[1], outerArray[0][layerIndex+1].pos[2]);
    endShape();

  }
}

void loop() {

  background (30);

AttachRestL = ((slider3X - SLIDER_3_LEFT)/2 + 2);

if(keyPressed) {
    if (key == '1' || key == '!') {
      RenderKey = 1;
    }  else if (key == '2') {
      RenderKey = 2;
    } else if (key == '3') {
      RenderKey = 3;
    } else if (key == '4') {
      RenderKey = 4;
    }else if (key == '5') {
      RenderKey = 5;
    }else if (key == '6') {
      RenderKey = 6;
      }
      
   
}


  /*
  lightColor(0, 0.2, 0.2, 0.2);  // Slight ambient light
  lightColor(1, 0.6, 0.5, 0.5);  // Reddish light to the front
  lightPos(1, 250, 250, 1000);

  lightColor(2, 0.2, 0.5, 0.5);  // Blue light to the right
  lightPos(2, 2000, 0, 0);

  lightColor(3, 0.5, 0.5, 0.2);    // Yellow light to the left
  lightPos(3, -2000, 0, 0);
  */

  noFill();
  stroke (63, 214, 236, 100);
  rect(SLIDER_1_LEFT, SLIDER_1_TOP, SLIDER_1_WIDTH, SLIDER_1_HEIGHT);
  rect(SLIDER_2_LEFT, SLIDER_2_TOP, SLIDER_2_WIDTH, SLIDER_2_HEIGHT);
  rect(SLIDER_3_LEFT, SLIDER_3_TOP, SLIDER_3_WIDTH, SLIDER_3_HEIGHT);

  fill(234, 240, 36, 250);
  rect(slider1X, SLIDER_1_TOP +1, 6, SLIDER_1_HEIGHT -5);
  rect(slider2X, SLIDER_2_TOP +1, 6, SLIDER_2_HEIGHT -5);
  fill(#FF0000);
  rect(slider3X, SLIDER_3_TOP +1, 6, SLIDER_3_HEIGHT -5);

  push();

  scale(0.5, 0.5, 0.5);

  if (frame % 90 == 1 && numOuterLayers < OUTERLAYERS) {
    spawnOuterRing(-OUTERRINGSPACE * numOuterLayers, 0, OUTERRAD, numOuterLayers);
  }

  if (frame % 30 == 1 && numInnerLayers < INNERLAYERS) {
    spawnInnerRing(-INNERRINGSPACE * numInnerLayers, 0, INNERRAD, numInnerLayers);
  }

  translate(width, 1.5 * height);
  arcball.run();

 
  if ((RenderKey == 2 )|| (RenderKey == 6)){
    drawInnerSurface(numInnerLayers);
  }
 
  //println(numInnerLayers);
  //if (numInnerLayers == INNERLAYERS)  {
   // drawInnerSurface(numInnerLayers);
  //}

  if ( (RenderKey == 3) || (RenderKey == 6) ) {
    drawOuterSurface(numOuterLayers);
  }

  //println(numOuterLayers);
  //if (numOuterLayers == OUTERLAYERS) {
    //drawOuterSurface(numOuterLayers);
  //}

  stroke (60);
  noFill();
  box (-800,-10,800);

  noStroke();
  fill(234, 240, 36, 100);
  box (800, 1, 1);
  box (1, 1, 800);

 if ( (RenderKey == 1) || (RenderKey == 4) || (RenderKey == 5) || (RenderKey == 6) ) {
  drawSprings();
  }
  

  pop();

}



//******************************************************************
//ARCBALL CODE
// Copy what's below exactly.
class ArcBall
{
  float center_x, center_y, radius;
  Vec3 v_down, v_drag;
  Quat q_now, q_down, q_drag;
  Vec3[] axisSet;
  int axis;

  ArcBall(float center_x, float center_y, float radius)
  {
    this.center_x = center_x;
    this.center_y = center_y;
    this.radius = radius;

    v_down = new Vec3();
    v_drag = new Vec3();

    q_now = new Quat();
    q_down = new Quat();
    q_drag = new Quat();

  axisSet = new Vec3[] {new Vec3(1.0f, 0.0f, 0.0f), new Vec3(0.0f, 1.0f, 0.0f), new Vec3(0.0f, 0.0f, 1.0f)};
    axis = -1;  // no constraints...
  }

  void mousePressed()
  {
    v_down = mouse_to_sphere(mouseX, mouseY);
    q_down.set(q_now);
    q_drag.reset();
  }

  void mouseDragged()
  {
    v_drag = mouse_to_sphere(mouseX, mouseY);
    q_drag.set(Vec3.dot(v_down, v_drag), Vec3.cross(v_down, v_drag));
  }

  void run()
  {
    q_now = Quat.mul(q_drag, q_down);
    applyQuat2Matrix(q_now);
  }

  Vec3 mouse_to_sphere(float x, float y)
  {
    Vec3 v = new Vec3();
    v.x = (x - center_x) / radius;
    v.y = (y - center_y) / radius;

    float mag = v.x * v.x + v.y * v.y;
    if (mag > 1.0f)
    {
      v.normalize();
    }
    else
    {
      v.z = sqrt(1.0f - mag);
    }

    return (axis == -1) ? v : constrain_vector(v, axisSet[axis]);
  }

  Vec3 constrain_vector(Vec3 vector, Vec3 axis)
  {
    Vec3 res = new Vec3();
    res.sub(vector, Vec3.mul(axis, Vec3.dot(axis, vector)));
    res.normalize();
    return res;
  }

  void applyQuat2Matrix(Quat q)
  {
    // instead of transforming q into a matrix and applying it...

    float[] aa = q.getValue();
    rotate(aa[0], aa[1], aa[2], aa[3]);
  }
}

static class Vec3
{
  float x, y, z;

  Vec3()
  {
  }

  Vec3(float x, float y, float z)
  {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  void normalize()
  {
    float length = length();
    x /= length;
    y /= length;
    z /= length;
  }

  float length()
  {
    return (float) Math.sqrt(x * x + y * y + z * z);
  }

  static Vec3 cross(Vec3 v1, Vec3 v2)
  {
    Vec3 res = new Vec3();
    res.x = v1.y * v2.z - v1.z * v2.y;
    res.y = v1.z * v2.x - v1.x * v2.z;
    res.z = v1.x * v2.y - v1.y * v2.x;
    return res;
  }

  static float dot(Vec3 v1, Vec3 v2)
  {
    return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
  }

  static Vec3 mul(Vec3 v, float d)
  {
    Vec3 res = new Vec3();
    res.x = v.x * d;
    res.y = v.y * d;
    res.z = v.z * d;
    return res;
  }

  void sub(Vec3 v1, Vec3 v2)
  {
    x = v1.x - v2.x;
    y = v1.y - v2.y;
    z = v1.z - v2.z;
  }
}

static class Quat
{
  float w, x, y, z;

  Quat()
  {
    reset();
  }

  Quat(float w, float x, float y, float z)
  {
    this.w = w;
    this.x = x;
    this.y = y;
    this.z = z;
  }

  void reset()
  {
    w = 1.0f;
    x = 0.0f;
    y = 0.0f;
    z = 0.0f;
  }

  void set(float w, Vec3 v)
  {
    this.w = w;
    x = v.x;
    y = v.y;
    z = v.z;
  }

  void set(Quat q)
  {
    w = q.w;
    x = q.x;
    y = q.y;
    z = q.z;
  }

  static Quat mul(Quat q1, Quat q2)
  {
    Quat res = new Quat();
    res.w = q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z;
    res.x = q1.w * q2.x + q1.x * q2.w + q1.y * q2.z - q1.z * q2.y;
    res.y = q1.w * q2.y + q1.y * q2.w + q1.z * q2.x - q1.x * q2.z;
    res.z = q1.w * q2.z + q1.z * q2.w + q1.x * q2.y - q1.y * q2.x;
    return res;
  }

  float[] getValue()
  {
    // transforming this quat into an angle and an axis vector...

    float[] res = new float[4];

    float sa = (float) Math.sqrt(1.0f - w * w);
    if (sa < EPSILON)
    {
      sa = 1.0f;
    }

    res[0] = (float) Math.acos(w) * 2.0f;
    res[1] = x / sa;
    res[2] = y / sa;
    res[3] = z / sa;

    return res;
  }
}

