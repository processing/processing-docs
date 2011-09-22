// This code was written with the _ALPHA_ version 
// of Processing and may not run correctly in the 
// current version.

// bubble chamber ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// a generative painting system using random collisions of
// four unique orbit decaying particle types.
//
// j. tarbell          jt@levitated.net
// levitated.net       october 29, 2003
//
//
// it is fun to be working with pixels again!
//
//
// there are four particles.  each leaves a trail behind as evidence of its
// trajectory.  general appearance and behavior are unique to each particle.
// see the particle classes towards the end of this program for a complete
// description.
//
// each particle maintains a two dimensional position.   movement is calculated
// using direction of travel (theta) and pixels per frame (speed).    both (theta)
// and (speed) decay over time arbitrarily.  theta modifier (thetaD) also decays
// over time (thetaDD).
//
// the result is a beautiful set of spiral decays.  traced over time, revealing an
// emergent planetary texture.  be patient and observe the many stages of its
// evolution as a generative image.  equilibrium is never reached because some 
// particles arbitrarily re collide themselves.
//
// no simulation of quantum phenomena is being attempted here.  the particle
// names have been borrowed to ease personalization of the objects.  collisions
// are also not actually being calculated, the particle is constructed with the
// collision event assumed, a lot like walking through a dark house after
// working on the computer.

// dimensions of drawing area
int dim =  400;

// particle proportions
int maxMuon = 100;
int maxQuark = 81;
int maxHadron = 60;
int maxAxion = 9;

// angle of collision (usually calculated with mouse position)
float collisionTheta;

// first time user interaction flag
boolean boom = false;

// discrete universe of particles?
Muon[] muon =  new Muon[maxMuon];
Quark[] quark = new Quark[maxQuark];
Hadron[] hadron = new Hadron[maxHadron];
Axion[] axion = new Axion[maxAxion];

// some nice color palettes

// rusted desert metal. winter, new mexico
color[] goodcolor = {#3a242b, #3b2426, #352325, #836454, #7d5533, #8b7352, #b1a181, #a4632e, #bb6b33, #b47249, #ca7239, #d29057, #e0b87e, #d9b166, #f5eabe, #fcfadf, #d9d1b0, #fcfadf, #d1d1ca, #a7b1ac, #879a8c, #9186ad, #776a8e};

// perdenales canyon. fall, texas
//color[] goodcolor = {#f8f7f1, #6b6556, #a09c84, #908b7c, #79746e, #755d35, #937343, #9c6b4b, #ab8259, #aa8a61, #578375, #f0f6f2, #d0e0e5, #d7e5ec, #d3dfea, #c2d7e7, #a5c6e3, #a6cbe6, #adcbe5, #77839d, #d9d9b9, #a9a978, #727b5b, #6b7c4b, #546d3e, #47472e, #727b52, #898a6a, #919272, #AC623b, #cb6a33, #9d5c30, #843f2b, #652c2a, #7e372b, #403229, #47392b, #3d2626, #362c26, #57392c, #998a72, #864d36, #544732 };



// P5 ENVIRONMENTAL METHODS ++++++++++++++++++++++++++++++++++++++++++

void setup() {
  // processing is awesome
  size(dim,dim);
  background(255);
//  fill(0);
//  rect(0,0,dim,dim/2);
  noStroke();

  // instantiate universe of particles
  for (int i=0; i<maxAxion; i++) {
    axion[i] = new Axion(dim/2,dim/2);
  }
  for (int i=0; i<maxHadron; i++) {
    hadron[i] = new Hadron(dim/2,dim/2);
  }
  for (int i=0; i<maxQuark; i++) {
    quark[i] = new Quark(dim/2,dim/2);
  }
  for (int i=0; i<maxMuon; i++) {
    muon[i] = new Muon(dim/2,dim/2);
  }
  
  // ok, draw just one collision
  collideOne();
}

void loop() {
  //background(0);  // and erase all that hard work?
  if (boom) {
    // initial collision event has occured, ok to move the particles...
  
    // allow each particle in the universe one step
    for (int i=0; i<hadron.length; i++){
      hadron[i].move();
    }
    for (int i=0; i<muon.length; i++){
      muon[i].move();
    }
    for (int i=0; i<quark.length; i++){
      quark[i].move();
    }
    for (int i=0; i<axion.length; i++){
      axion[i].move();
    }
  }
}


void mousePressed() {
  boom = true;
  // fire 11 of each particle type
  for (int k=0;k<11;k++) {
    collideOne();
  }
}

void keyReleased () {
  if (key == ' ') {
    // reset and fire all particles
    boom = true;
    background(255);
//    fill(0);
//    rect(0,0,dim,dim/2);
    collideAll();
  }
}



// METHODS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// somecolor ()
//    returns a random color from a list of good colors

color somecolor() {
  // pick some random color from a list of known color
  return goodcolor[int(random(goodcolor.length))];
}


// tpoint (x position, y position, color value, alpha coefficient)
//     transluscent point.  color blending pixel put with alpha

void tpoint(int x1, int y1, color myc, float a) {

  int r, g, b;
  // get background color
  color c = get(x1, y1);

  // alpha blend RGB components
  r = int(red(c) + (red(myc) - red(c)) * a);
  g = int(green(c) +(green(myc) - green(c)) * a);
  b = int(blue(c) + (blue(myc) - blue(c)) * a);

  // place calculated color point
  color nc = color(r, g, b);
  stroke(nc);
  point(x1,y1);

  //  stroke(myc);
  //  point(x1,y1);
}

// collideAll ()
//   send every particle in the universe on a collision course

void collideAll() {
  // random collision angle
  collisionTheta = random(TWO_PI);

  // particle super collision
  if (hadron.length>0) {
    for (int i=0; i<maxHadron; i++) {
      hadron[i].collide();
    }
  }
  if (quark.length>0) {
    for (int i=0; i<maxQuark; i++) {
      quark[i].collide();
    }
  }
  if (muon.length>0) {
    for (int i=0; i<maxMuon; i++) {
      muon[i].collide();
    }
  }
  if (axion.length>0) {
    for (int i=0; i<maxAxion; i++) {
      axion[i].collide();
    }
  }
}

// collideOne ()
//   send just one random particle of each type 
//   (except axion) on a new collision course

void collideOne() {
  // eject a single particle, relative to position position
  int t;
  collisionTheta = atan2(dim/2-mouseX,dim/2-mouseY);

  // choose a set of hadron particles to recollide
  if (hadron.length>0) {
    t = int(random(hadron.length));
    hadron[t].collide();
  }

  // choose a set of quark particles to recollide
  if (quark.length>0) {
    t = int(random(quark.length));
    quark[t].collide();
  }

  // choose a set of muon particles to recollide
  if (muon.length>0) {
    t = int(random(muon.length));
    muon[t].collide();
  }

}




// CLASSES +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// Muon particle
//   the muon is a colorful particle with an entangled friend.
//   draws both itself and its horizontally symmetric partner.
//   a high range of speed and almost no speed decay allow the
//   muon to reach the extents of the window, often forming rings
//   where theta has decayed but speed remains stable.  result
//   is color almost everywhere in the general direction of collision,
//   stabilized into fuzzy rings.

class Muon {
  // position
  float x, y;
  // speed
  float speed;
  // orbit
  float theta;
  // decay
  float speedD;
  float thetaD;
  float thetaDD;
  // color
  color myc;
  color mya;

  Muon(float X, float Y) {
    // constructor
    x = X;
    y = Y;
  }
  void collide() {
    // initialize all parameters 
    x = dim/2;
    y = dim/2;
    speed = random(2,32);
    speedD = random(0.0001,0.001);

    // rotation
    theta = collisionTheta+random(-0.1,0.1);
    //    theta = random(TWO_PI)-PI;
    thetaD = 0;
    thetaDD = 0;

    // ensure that there IS decay
    while (abs(thetaDD)<0.001) {
      // rate of orbit decay
      thetaDD = random(-0.1,0.1);
    }

    // color is determined by direction of movement
    int c = int((goodcolor.length-1)*(theta+PI)/TWO_PI);
    if ((c>=goodcolor.length) || (c<0)) {
      // SAFETY: this is giving me problems    
      // println("whoa: "+c);
    } else {
      myc = goodcolor[c];
      // anti-particle color
      mya = goodcolor[goodcolor.length-c-1];
    }
  }

  void move() {
    // draw
    tpoint(int(x),int(y),myc,0.15);
    // draw anti-particle
    tpoint(int(dim-x),int(y),mya,0.15);

    // move
    x+=speed*sin(theta);
    y+=speed*cos(theta);
    // rotate
    theta+=thetaD;

    // modify spin
    thetaD+=thetaDD;
    // modify speed
    speed-=speedD;

    // do not allow particle to enter extreme offscreen areas
    if ((x<-dim) || (x>dim*2) || (y<-dim) || (y>dim*2)) {
      collide();
    }
  }
}

// Quark particle
//   the quark draws as a translucent black.  their large numbers
//   create fields of blackness overwritten only by the glowing shadows of Hadrons.
//   quarks are allowed to accelerate away with speed decay values above 1.0
//   each quark has an entangled friend.  both particles are drawn identically,
//   mirrored along the y-axis.

class Quark {
  // position
  float x, y;
  float vx, vy;
  // orbit
  float theta;
  float speed;
  // decay
  float speedD;
  float thetaD;
  float thetaDD;
  // color
  color myc = #000000;

  Quark(float X, float Y) {
    // constructor
    x = X;
    y = Y;
  }
  void collide() {
    // initialize all parameters with random collision
    x = dim/2;
    y = dim/2;
    theta = collisionTheta+random(-0.11,0.11);
    speed = random(0.5,3.0);

    speedD = random(0.996,1.001);
    thetaD = 0;
    thetaDD = 0;

    // rate of orbit decay
    while (abs(thetaDD)<0.00001) {
      thetaDD = random(-0.001,0.001);
    }

    // color is determined by direction
    //    int i = int(goodcolor.length*theta/TWO_PI);
    //    myc = goodcolor[i];
  }

  void move() {
    // draw
    tpoint(int(x),int(y),myc,0.12);
    // draw anti-particle
    tpoint(int(dim-x),int(y),myc,0.12);

    // move
    x+=vx;
    y+=vy;
    // turn
    vx = speed*sin(theta);
    vy = speed*cos(theta);

    theta+=thetaD;

    // modify spin
    thetaD+=thetaDD;
    // modify speed
    speed*=speedD;
    if (random(1000)>997) {
      speed*=-1;
      speedD=2-speedD;
    }
    // do not allow particle to enter extreme offscreen areas
    if ((x<-dim) || (x>dim*2) || (y<-dim) || (y>dim*2)) {
      collide();
    }
  }
}

//  Hadron particle
//    hadrons collide from totally random directions.
//    those hadrons that do not exit the drawing area,
//    tend to stabilize into perfect circular orbits.
//    each hadron draws with a slight glowing emboss.
//    the hadron itself is not drawn.

class Hadron {
  // position
  float x, y;
  float vx, vy;
  // orbit
  float theta;
  float speed;
  // decay
  float speedD;
  float thetaD;
  float thetaDD;
  color myc;
  Hadron(float X, float Y) {
    // constructor
    x = X;
    y = Y;
  }
  void collide() {
    // initialize all parameters with random collision
    x = dim/2;
    y = dim/2;
    theta = random(TWO_PI);
    speed = random(0.5,3.5);

    speedD = random(0.996,1.001);
    thetaD = 0;
    thetaDD = 0;

    // rate of orbit decay
    while (abs(thetaDD)<0.00001) {
      thetaDD = random(-0.001,0.001);
    }
    myc = #00FF00;
  }

  void move() {
    // draw 

    // the particle itself is unseen, not drawn

    // instead, draw shadow emboss:
    // lighten pixel above hadron
    tpoint(int(x),int(y-1),#FFFFFF,0.11);
    // darken pixel below hadron
    tpoint(int(x),int(y+1),#000000,0.11);

    // move
    x+=vx;
    y+=vy;
    
    // turn
    vx = speed*sin(theta);
    vy = speed*cos(theta);
    
    // modify spin
    theta+=thetaD;
    thetaD+=thetaDD;
    
    // modify speed
    speed*=speedD;
    
    // random chance of subcollision event
    if (random(1000)>997) {
      // stablize orbit
      speedD=1.0;
      thetaDD=0.00001;
      if (random(100)>70) {
        // recollide
        x = dim/2;
        y = dim/2;
        collide();
      }
    }
    // do not allow particle to enter extreme offscreen areas
    if ((x<-dim) || (x>dim*2) || (y<-dim) || (y>dim*2)) {
      collide();
    }
  }
}

// Axion particle
//   the axion particle draws a bold black path.  axions exist
//   in a slightly higher dimension and as such are drawn with
//   elevated embossed shadows.  axions are quick to stabilize
//   and fall into single pixel orbits axions automatically
//   recollide themselves after stabilizing.

class Axion {
  // position
  float x, y;
  float vx, vy;
  // orbit
  float theta;
  float speed;
  // decay
  float speedD;
  float thetaD;
  float thetaDD;

  Axion(float X, float Y) {
    // constructor
    x = X;
    y = Y;
  }
  void collide() {
    // initialize all parameters with random collision
    x = dim/2;
    y = dim/2;
    theta = random(TWO_PI);
    speed = random(1.0,6.0);

    speedD = random(0.998,1.000);
    thetaD = 0;
    thetaDD = 0;

    // rate of orbit decay
    while (abs(thetaDD)<0.00001) {
      thetaDD = random(-0.001,0.001);
    }
  }

  void move() {
    // draw - axions are high contrast
    tpoint(int(x),int(y),#111111,0.62);
    
    // axions cast vertical glows, highlight/shadow emboss
    tpoint(int(x),int(y-1),#EEEEEE,0.11);
    tpoint(int(x),int(y-2),#EEEEEE,0.07);
    tpoint(int(x),int(y-3),#EEEEEE,0.03);
    tpoint(int(x),int(y-4),#EEEEEE,0.01);

    tpoint(int(x),int(y+1),#111111,0.11);
    tpoint(int(x),int(y+2),#111111,0.07);
    tpoint(int(x),int(y+3),#111111,0.03);
    tpoint(int(x),int(y+4),#111111,0.01);

    // move
    x+=vx;
    y+=vy;
    // turn
    vx = speed*sin(theta);
    vy = speed*cos(theta);

    theta+=thetaD;

    // modify spin
    thetaD+=thetaDD;
    // modify speed
    speed*=speedD;
    speedD*=0.9999;
    if (random(1000)>996) {
      // reverse orbit
      speed*=-1;
      speedD=2-speedD;
      if (random(100)>30) {
        x = dim/2;
        y = dim/2;
        collide();
      }
    }
  }
}


// the end
