// This code was written with the _ALPHA_ version 
// of Processing and may not run correctly in the 
// current version.


// Pond
// by William Ngan <contact@metaphorical.net>
// Copyright(c)2003
// http://www.metaphorical.net

/*
The flocking behaviour applies Craig Reynolds' model described in his SIGGRAPH 1987 paper.
see http://www.red3d.com/cwr/papers/1987/boids.html for more details.
*/

//-- source code, not quite optimized... --//

int W, H;
int NUM = 40;

Fish[] flock = new Fish[NUM];
Fish bigfish1;
Fish bigfish2;
Fish bigfish3;

float rippleX, rippleY;
float[] ripple = new float[50];
boolean hasRipple;
int hasPredator = 0;

/* SETUP */
void setup()
{
  size( 600, 400 );
  W = width;
  H = height;
  background(6,22,48);
  colorMode(HSB, 360, 100, 100);
  framerate(24);

  // small fish
  float lim = 50f;
  for (int i=0; i<NUM; i++) {
    flock[i] = new Fish( random(W), random(H), 1f, random(PI), random(5f,8f) );
    flock[i].setSpeedLimit( random(3f,4f), 0.5f );
    flock[i].setColor( 207, random(50), 100 );
  }

  // ripple
  for (int i=0; i<ripple.length; i++) {
    ripple[i] = 999;
  }

  // bigfish1
  bigfish1 = new Fish( random(W), random(H), 1f, random(PI), 12f );
  bigfish1.setSpeedLimit( 2f, 1f );
  bigfish1.setColor( 30,66,79 );

  // bigfish2
  bigfish2 = new Fish( random(W), random(H), 1f, random(PI), 15f );
  bigfish2.setSpeedLimit( 2f, 1f );
  bigfish2.setColor( 20,66,79 );

  // bigfish3
  bigfish3 = new Fish( random(W), random(H), 1f, random(PI), 20f );
  bigfish3.setSpeedLimit( 2f, 1f );
  bigfish3.setColor( 10,66,79 );

}

/* LOOP */
void loop()
{

  stroke(207,66,79);
  noFill();

  // draw bigfish
  if (hasPredator>0) {

    bigfish1.scanPrey( flock, 150f );
    bigfish1.predator( bigfish2.x, bigfish2.y, 100f, 6*PI/180f, 2f);
    bigfish1.predator( bigfish3.x, bigfish3.y, 100f, 6*PI/180f, 2f);
    bigfish1.predator( mouseX, mouseY, 50f, 5*PI/180f, 1f);
    bigfish1.move();
    stroke( bigfish1.colour[0], bigfish1.colour[1], bigfish1.colour[2]);
    bigfish1.getFish();

    if (hasPredator>1) {
      bigfish2.scanPrey( flock, 120f );
      bigfish2.predator( bigfish1.x, bigfish1.y, 100f, 5*PI/180f, 1.5f);
      bigfish2.predator( bigfish3.x, bigfish3.y, 100f, 5*PI/180f, 1.5f);
      bigfish2.predator( mouseX, mouseY, 50f, 4*PI/180f, 0.8f);
      bigfish2.move();
      stroke( bigfish2.colour[0], bigfish2.colour[1], bigfish2.colour[2]);
      bigfish2.getFish();

      if (hasPredator>2) {
        bigfish3.scanPrey( flock, 100f );
        bigfish3.predator( bigfish1.x, bigfish1.y, 100f, 5*PI/180f, 1.5f);
        bigfish3.predator( bigfish2.x, bigfish2.y, 100f, 5*PI/180f, 1.5f);
        bigfish3.predator( mouseX, mouseY, 50f, 3*PI/180f, 0.5f);
        bigfish3.move();
        stroke( bigfish3.colour[0], bigfish3.colour[1], bigfish3.colour[2]);
        bigfish3.getFish();
      }
    }
  }

  // draw small fish
  noStroke();
  for (int i=0; i<flock.length; i++) {

    fill(flock[i].colour[0], flock[i].colour[1]+flock[i].tone, flock[i].colour[2]);

    if (hasRipple) {
      flock[i].swarm( rippleX, rippleY, 200 );
    }

    flock[i].scanFlock( flock, 200, 50 );

    if (hasPredator>0) {
      flock[i].predator( bigfish1.x, bigfish1.y, 100f, 8*PI/180f, 1.5f);
      if (hasPredator>1) {
        flock[i].predator( bigfish2.x, bigfish2.y, 100f, 8*PI/180f, 1.5f);
        if (hasPredator>2) flock[i].predator( bigfish3.x, bigfish3.y, 100f, 8*PI/180f, 1.5f);
      }
    }
    if (!hasRipple) flock[i].predator( mouseX, mouseY, 100f, 5*PI/180f, 1f);
    flock[i].move();
    flock[i].getFish();

  }

  // draw ripple
  stroke(207,100,30);
  noFill();
  hasRipple = false;
  for (int k=0; k<ripple.length; k++) {
    if (ripple[k]<W) {
      ripple[k]+=3f*(k+4);
      ellipse( rippleX-ripple[k]/2, rippleY-ripple[k]/2, ripple[k], ripple[k]);
      hasRipple = true;
    }
  }

}

/* MOUSE */
void mouseDragged() {
  rippleX = mouseX;
  rippleY = mouseY;
}

void mousePressed() {
  rippleX = mouseX;
  rippleY = mouseY;
}

void mouseReleased() {
  if (!hasRipple) {
    for (int k=0; k<ripple.length; k++) {
      ripple[k]=0;
    }
    hasRipple = true;
  }
}

void keyPressed() {
  if(key == '1') {
    hasPredator = 1;
  } else if (key == '2') {
    hasPredator = 2;
  } else if (key == '3') {
    hasPredator = 3;
  } else if (key == '0') {
    hasPredator = 0;
  }
}

/* FISH */
class Fish {

  float fsize;
  float[] tailP = {0,0};
  float[] tailPC = {0,0};
  float tailLength = 3.0f;
  float x, y, angle, speed;
  float maxSpeed, minSpeed;

  float energy = 1f; //energy to wriggle
  float wave = 0; //tail wave
  int wcount = 0;
  int uturn = 0;
  int boundTime = 0;

  float[] colour = {255,255,255};
  float tone = 0;
  boolean isBound = false;

  Fish( float px, float py, float s, float a, float size ) {
    tailP[1] = tailLength;
    tailPC[1] = tailLength;

    x = px;
    y = py;
    angle = a;
    speed = s;
    fsize = size;
  }

  // METHOD:  draw fish's curves
  void getFish(){
    float[] pos;
    beginShape( POLYGON );

    pos = calc( 0f, -1f, fsize );
    bezierVertex2( pos[0], pos[1] );
    pos = calc( 0.5f, -1f, fsize );
    bezierVertex2( pos[0], pos[1] );
    pos = calc( 1f, -0.5f, fsize );
    bezierVertex2( pos[0], pos[1] );
    pos = calc( 1f, 0f, fsize );
    bezierVertex2( pos[0], pos[1] );

    pos = calc( 1f, 1f, fsize );
    bezierVertex2( pos[0], pos[1] );
    pos = calc( tailPC[0], tailPC[1], fsize );
    bezierVertex2( pos[0], pos[1] );
    pos = calc( tailP[0], tailP[1], fsize );
    bezierVertex2( pos[0], pos[1] );

    pos = calc( tailPC[0], tailPC[1], fsize );
    bezierVertex2( pos[0], pos[1] );
    pos = calc( -1f, 1f, fsize );
    bezierVertex2( pos[0], pos[1] );
    pos = calc( -1f, 0f, fsize );
    bezierVertex2( pos[0], pos[1] );

    pos = calc( -1f, -0.5f, fsize );
    bezierVertex2( pos[0], pos[1] );
    pos = calc( -0.5f, -1f, fsize );
    bezierVertex2( pos[0], pos[1] );
    pos = calc( 0f, -1f, fsize );
    bezierVertex2( pos[0], pos[1] );

    endBezier();
    endShape();
  }

  // METHOD: set tail's position
  void setTail(float strength, float wave) {
    tailP[0] = strength*wave;
    tailP[1] = tailLength+tailLength/2 - abs( tailLength/4*strength*wave );
    tailPC[0] = strength*wave*-1;
  }

  // METHOD: translate a bezier ctrl point according to fish's angle and pos.
  float[] calc( float px, float py, float s ) {
    float a = atan2( py, px) + angle+ PI/2;
    float r = sqrt( (px*px + py*py) );
  float[] pos ={ x+r*s*cos(a), y+r*s*sin(a) };
    return pos;
  }

  // METHOD: wriggle
  protected void wriggle() {

    // calc energy
    if (energy > 1) {                           // if it has energy
      wcount+=energy*2;                       // tail sine-wave movement
    }

    // sine-wave oscillation
    if (wcount>120) {
      wcount = 0;
      energy =0;
    }

    wave = sin( wcount*3*PI/180 ); //sine wave
    float strength = energy/5 * tailLength/2; //tail strength

    // set tail position
    setTail( strength, wave );
    move();
  }

  ///////////////////////////////////

  // METHOD: find distance
  float dist( float px, float py ) {
    px -= x;
    py -= y;
    return sqrt( px*px + py*py );
  }

  float dist( Fish p ) {
    float dx = p.x - x;
    float dy = p.y - y;
    return sqrt( dx*dx + dy*dy );
  }

  // METHOD: find angle
  float angle( float px, float py ) {
    return atan2( (py-y), (px-x) );
  }

  float angle( Fish p ) {
    return atan2( (p.y-y), (p.x-x) );
  }

  // METHOD: move one step
  void move() {
    x = x+( cos(angle)*speed );
    y = y+( sin(angle)*speed );
  }

  // METHOD: speed change
  void speedChange( float inc ) {

    speed += inc;

    if (speed<minSpeed) speed=minSpeed;
    if (speed>maxSpeed) speed=maxSpeed;

  }

  // METHOD: direction change
  void angleChange( float inc ) {
    angle += inc;
  }

  // METHOD: set speed limit
  void setSpeedLimit( float max, float min ) {
    maxSpeed = max;
    minSpeed = min;
  }

  // METHOD: set angle
  void setAngle( float a ) {
    angle = a;
  }

  // METHOD: turn towards an angle
  void turnTo( float ta, float inc ) {

    if (angle < ta) {
      angleChange( inc );
    } else {
      angleChange( inc*-1 );
    }
  }

  // METHOD: set Color
  void setColor( float c1, float c2, float c3 ) {
    colour[0] = c1;
    colour[1] = c2;
    colour[2] = c3;
  }

  // METHOD: copy another fish's angle and pos
  void copyFish( Fish f ) {
    x = f.x;
    y = f.y;
    angle = f.angle;
    speed = f.speed;
  }

  ////////////////////////////////////

  // METHOD: check bounds and U-turn when near bounds
  boolean checkBounds( float turn )
  {
    boolean inbound = false;

    turn += boundTime/100;

    // calculate the "buffer area" and turning angle
    float gap = speed * PI/2/turn;
    if (gap > W/4) {
      gap = W/4;
      turn = (gap/speed)/PI/2;
    }

    // which direction to u-turn?
    if ( x-gap < 0 || x+gap > W || y-gap < 0 || y+gap > H) {

      if (uturn == 0) {

        float temp = angle;
        if (temp < 0) temp += PI*2;

        if ( temp >0 && temp<PI/2 ) {
          uturn = 1;
        } else if ( temp >PI/2 && temp<PI ) {
          uturn = -1;
        } else if ( temp>PI && temp<PI*3/2 ) {
          uturn = 1;
        } else if ( temp>PI*3/2 && temp<PI*2 ) {
          uturn = -1;
        } else {
          uturn = 1;
        }

        if (y-gap < 0 || y+gap > H) uturn *=-1;
      }

      // turn
      angleChange( turn*uturn );
      //energy += 0.1;

      inbound = true;

    } else { // when out, clear uturn
      uturn = 0;
      inbound = false;
    }

    x = (x<0) ? 0 : ( (x>W) ? W : x );
    y = (y<0) ? 0 : ( (y>H) ? H : y );

    isBound = inbound;
    boundTime = (inbound) ? boundTime+1 : 0;

    return inbound;

  }

  // METHOD: alignment -- move towards the same direction as the flock within sight
  void align( Fish fp, float angleSpeed, float moveSpeed ) {

    turnTo( fp.angle, angleSpeed+random(angleSpeed*3) ); // 0.001

    if ( speed > fp.speed ) {
      speedChange( moveSpeed*(-1-random(1)) ); //0.2
    } else {
      speedChange( moveSpeed );
    }

  }

  // METHOD: cohersion -- move towards the centre of the flock within sight
  void cohere( Fish[] flocks, float angleSpeed, float moveSpeed  ) {

    // get normalised position
    float nx = 0;
    float ny = 0;

    for (int i=0; i<flocks.length; i++) {
      nx += flocks[i].x;
      ny += flocks[i].y;
    }

    nx /= flocks.length;
    ny /= flocks.length;

    turnTo( angle(nx, ny), angleSpeed+random(angleSpeed*2) ); //0.001
    speedChange( moveSpeed ); //-0.1

  }

  // METHOD: seperation -- moves away from the flock when it's too crowded
  void seperate( Fish[] flocks, float angleSpeed, float moveSpeed  ) {

    // find normalised away angle
    float nA = 0;

    for (int i=0; i<flocks.length; i++) {
      nA += (flocks[i].angle+PI);
    }

    nA /= flocks.length;
    turnTo( nA, angleSpeed+random(angleSpeed*2) ); //0.001
    speedChange( moveSpeed ); //0.05
  }

  // METHOD: collision aviodance -- moves away quickly when it's too close
  void avoid( Fish[] flocks, float angleSpeed, float moveSpeed ) {

    for (int i=0; i<flocks.length; i++) {
      float dA = angle( flocks[i] ) + PI;

      x = x + cos(dA)*moveSpeed/2;
      y = y + sin(dA)*moveSpeed/2;

      turnTo( dA, angleSpeed+random(angleSpeed) ); //0.005
    }
    speedChange( moveSpeed ); //0.1
  }

  // METHOD: flee from predator
  void predator( float px, float py, float alertDistance, float angleSpeed, float moveSpeed ) {

    float d = dist( px, py );
    if ( d < alertDistance) {
      float dA = angle(px, py) + PI;
      x = x + cos(dA)*moveSpeed; //0.01
      y = y + sin(dA)*moveSpeed;
      turnTo( dA, angleSpeed+ random(angleSpeed) );
      if (tone <50) tone+=5;
    } else {
      if (tone>0) tone-=2;
    }

    speedChange( moveSpeed );
  }

  // METHOD: attracts towards a point (ie, ripple)
  void swarm( float px, float py, float d ) {
    float dA = angle(px, py);
    float dD = dist( px, py );

    turnTo( dA, PI/10 );
    if (isBound) {
      turnTo( dA, PI/10 );
    }
  }

  //////////////////////////////

  // METHOD: scan for the environment and determines behaviour
  void scanFlock( Fish[] flocks, float cohereR, float avoidR )
  {
    Fish[] near = new Fish[NUM];
    int nCount = 0;
    Fish[] tooNear = new Fish[NUM];
    int tnCount = 0;
    Fish[] collide = new Fish[NUM];
    int cCount = 0;
    Fish nearest = null;
    float dist = 99999;

    float tempA = angle;
    float tempS = speed;

    // check boundaries
    boolean inbound = (hasPredator>0) ? checkBounds(PI/16) : checkBounds( PI/24);

    for (int i=0; i<flocks.length; i++) {
      Fish fp = flocks[i];

      // check nearby fishes
      if (fp != this) {
        float d = dist( fp );
        if (d < cohereR ) {
          near[nCount++] = fp;

          if (dist > d ) {
            dist = d;
            nearest = fp;
          }

          if ( d <= avoidR ) {
            tooNear[tnCount++] = fp;
            if ( d <= avoidR/2 ) {
              collide[cCount++] = fp;
            }
          }
        }
      }

      // calc and make flocking behaviours
      Fish[] near2 = new Fish[nCount];
      Fish[] tooNear2 = new Fish[tnCount];
      Fish[] collide2 = new Fish[cCount];

      int j=0;
      for (j=0; j<nCount; j++) {
        near2[j] = near[j];
      }
      for (j=0; j<tnCount; j++) {
        tooNear2[j] = tooNear[j];
      }
      for (j=0; j<cCount; j++) {
        collide2[j] = collide[j];
      }

      if (!inbound && !hasRipple) {
        if (nearest!=null) {
          align( nearest, 0.1*PI/180, 0.2f );
        }
        cohere( near2, 0.1*PI/180, -0.1f );
      }
      seperate( tooNear2, (random(0.1)+0.1)*PI/180, 0.05f );
      avoid( collide2, (random(0.2)+0.2)*PI/180, 0.1f );
    }

    float diffA = (angle - tempA)*5;
    float diffS = (speed - tempS)/3;
    float c = diffA*180/(float)Math.PI;

    // wriggle tail
    energy += abs( c/150 );
    wriggle();

  }

  // METHOD: scan for food
  void scanPrey( Fish[] flocks, float range )
  {
    Fish[] near = new Fish[NUM];
    int nCount = 0;
    Fish[] tooNear = new Fish[NUM];
    int tnCount = 0;
    Fish[] collide = new Fish[NUM];
    int cCount = 0;
    Fish nearest = null;
    float dist = 99999;

    float tempA = angle;
    float tempS = speed;

    // look for nearby food
    for (int i=0; i<flocks.length; i++) {
      float d = dist( flocks[i] );
      if (dist > d ) {
        dist = d;
        nearest = flocks[i];
      }
    }

    // move towards food
    if (dist < range) {
      float gradient = dist/range;
      if (dist > range/2) {
        speedChange( 0.5f );
      } else {
        speedChange( -0.5f );
      }

      turnTo( angle( nearest ), 0.05f );

      float diffA = (angle - tempA)*10;
      float diffS = (speed - tempS)*5;
      float c = diffA*180/PI;

      energy += abs( c/150 );
    }

    // check boundaries
    boolean inbound = checkBounds( PI/16 );

    // wriggle tail
    wriggle();

  }

}

// custom bezier curve methods
int precision = 10; // higher the value, smoother the curve but slower the speed
float[][] bp = new float[4][2]; // holds {p1, ctrlp1, ctrlp2, p2} for cubic curve
int bcount = 0; // bezier counter

// linear interpolation
static float[] linear( float[] p0, float[] p1, float t ) {
float[] pt = {(1-t)*p0[0] + t*p1[0], (1-t)*p0[1] + t*p1[1]};
  return pt;
}

// deCasteljau algorithm
static float[] bezier( float pts[][], float t ) {
  float[][] curr, next;
  next = pts;
  while( next.length >1 ) { // deCasteljau iterations
    curr = next;
    next = new float[ curr.length-1 ][2];
    for (int i=0; i<curr.length-1; i++) {
      next[i] = linear( curr[i], curr[i+1], t );
    }
  }
  return next[0];
}

// METHOD: draw cubic bezier curve -- similar to bezierVertex() method in proce55ing
void bezierVertex2( float px, float py ) {
float[] pt = {px, py};
  bp[bcount++] = pt;
  if (bcount > 3) {
    for(int i=0; i<=precision; i++) {
      float[] p = bezier( bp, i/(float)precision );
      vertex( p[0], p[1] );
    }
    bp[0] = bp[3];
    bcount = 1;
  }
}

void endBezier() {
  bcount = 0;
}

// end custom bezier curve methods
