// Yellowtail
// by Golan Levin
// golan at flong dot com

// Version history
// "Yellowtail" is a little app I've implemented a number of times
// over the last few years. Some of the versions have had sound,
// others (like this one) have been silent. For more information,
// please see the following short article, online:
// http://www.flong.com/yellowtail/

// v1.0: "Curly"      (C++/DirectDraw, 1998)
// v2.0: "Soundbrush" (Java 1.1/SunAudio, 1999)
// v3.0: "Yellowtail" (C++/OpenGL/DirectSound, 1999)
// v4.0: "Yellowtail" (Java 1.1, 2002)
// v5.0: "Yellowtail" (Processing_0047, 2003)
// v5.1: "Yellowtail" (Processing_0068, 2004)

int myW, myH;
boolean theMouseDown = false;
boolean thePrevMousePressed = false;

Gesture gestureArray[];
int nGestures = 4;           // number of gestures
int minMove = 3;             // minimum travel for a new point
int currentGestureID;

Polygon tempP;
int tmpXp[];
int tmpYp[];

void setup()
{
  size(488, 288);
  background(0, 0, 0);
  noStroke();

  int myW = width;
  int myH = height;

  currentGestureID = 0;
  gestureArray = new Gesture[nGestures];
  for (int i=0; i<nGestures; i++){
    gestureArray[i] = new Gesture(myW, myH);
  }
  clearGestures();
}

//------------------------------------------------------------------
void loop()
{
  background(0,0,0);
  updateGeometry();
  fill(255, 255, 245);
  for (int G=0; G<nGestures; G++){
    renderGesture(gestureArray[G],myW,myH);
  }
  handleMouseUpWhenIWantToInsteadOfEventHandler();
}

//------------------------------------------------------------------
void handleMouseUpWhenIWantToInsteadOfEventHandler(){
  if ((mousePressed == false) && (thePrevMousePressed == true)){
    currentGestureID = (currentGestureID+1)%nGestures;
    Gesture G = gestureArray[currentGestureID];
    G.clear();
    G.clearPolys();
  }
  thePrevMousePressed = mousePressed;
}

//------------------------------------------------------------------
void mousePressed()
{
  theMouseDown = true;
  Gesture G = gestureArray[currentGestureID];
  G.clear();
  G.clearPolys();
  G.addPoint(mouseX, mouseY);
}

//------------------------------------------------------------------
void mouseDragged(){
  theMouseDown = true;
  if (currentGestureID >= 0){
    Gesture G = gestureArray[currentGestureID];
    if (G.distToLast(mouseX, mouseY) > minMove) {
      G.addPoint(mouseX, mouseY);
      G.smooth();
      G.compile();
    }
  }
}

//------------------------------------------------------------------
void mouseMoved (Event evt, int x, int y){
  theMouseDown = false;
}

//------------------------------------------------------------------
void mouseReleased(){
  theMouseDown = false;
}

//------------------------------------------------------------------
void keyPressed(){
  switch (key){
    case '+':
    case '=':
    if (currentGestureID >= 0){
      float th = gestureArray[currentGestureID].thickness;
      gestureArray[currentGestureID].thickness = min(96, th+1);
      gestureArray[currentGestureID].compile();
    }
    break;
    case '-':
    if (currentGestureID >= 0){
      float th = gestureArray[currentGestureID].thickness;
      gestureArray[currentGestureID].thickness = max(2, th-1);
      gestureArray[currentGestureID].compile();
    }
    break;

    case ' ': clearGestures();
    break;
  }

}

//------------------------------------------------------------------
void renderGesture (Gesture gesture, int w, int h){
  if (gesture.exists){
    if (gesture.nPolys > 0){
      Polygon polygons[] = gesture.polygons;
      int crosses[] = gesture.crosses;

      int xpts[];
      int ypts[];
      Polygon p;
      int cr;

      beginShape(QUADS);
      int gnp = gesture.nPolys;
      for (int i=0; i<gnp; i++){

        p = polygons[i];
        xpts = p.xpoints;
        ypts = p.ypoints;

        vertex(xpts[0], ypts[0]);
        vertex(xpts[1], ypts[1]);
        vertex(xpts[2], ypts[2]);
        vertex(xpts[3], ypts[3]);

        if ((cr = crosses[i]) > 0){
          if ((cr & 3)>0){
            vertex(xpts[0]+w, ypts[0]);
            vertex(xpts[1]+w, ypts[1]);
            vertex(xpts[2]+w, ypts[2]);
            vertex(xpts[3]+w, ypts[3]);

            vertex(xpts[0]-w, ypts[0]);
            vertex(xpts[1]-w, ypts[1]);
            vertex(xpts[2]-w, ypts[2]);
            vertex(xpts[3]-w, ypts[3]);
          }
          if ((cr & 12)>0){
            vertex(xpts[0], ypts[0]+h);
            vertex(xpts[1], ypts[1]+h);
            vertex(xpts[2], ypts[2]+h);
            vertex(xpts[3], ypts[3]+h);

            vertex(xpts[0], ypts[0]-h);
            vertex(xpts[1], ypts[1]-h);
            vertex(xpts[2], ypts[2]-h);
            vertex(xpts[3], ypts[3]-h);
          }

          // I have knowlingly retained the small flaw of not
          // completely dealing with the corner conditions
          // (the case in which both of the above are true).
        }
      }
      endShape();
    }
  }
}

//---------------------------------------------------------------
void updateGeometry(){
  Gesture J;
  for (int g=0; g<nGestures; g++){
    if ((J=gestureArray[g]).exists){
      if (g!=currentGestureID){
        advanceGesture(J);
      } else if (!theMouseDown){
        advanceGesture(J);
      }
    }
  }
}

//---------------------------------------------------------------
void advanceGesture(Gesture gesture){
  // move a Gesture one step
  if (gesture.exists){ // check
    int nPts = gesture.nPoints;
    int nPts1 = nPts-1;
    Vec3f path[];
    float jx = gesture.jumpDx;
    float jy = gesture.jumpDy;

    if (nPts > 0){
      path = gesture.path;
      for (int i=nPts1; i>0; i--){
        path[i].x = path[i-1].x;
        path[i].y = path[i-1].y;
      }
      path[0].x = path[nPts1].x - jx;
      path[0].y = path[nPts1].y - jy;
      gesture.compile();
    }
  }
}

//---------------------------------------------------------------
void clearGestures(){
  for (int i=0; i<nGestures; i++){
    gestureArray[i].clear();
  }
}

/////////////////////////////////////////////////////////////////////////////////////
class Vec3f {
  float x;
  float y;
  float p; // pressure

  Vec3f() {
    set(0,0,0);
  }
  Vec3f(float ix, float iy, float ip) {
    set(ix, iy, ip);
  }

  void set(float ix, float iy, float ip){
    x = ix;
    y = iy;
    p = ip;
  }
}

/////////////////////////////////////////////////////////////////////////////////////

class Gesture {

  float  damp = 5f;
  float  dampInv = 1.0f/damp;
  float  damp1 = damp -1;

  int w;
  int h;
  int capacity;

  Vec3f path[];
  int crosses[];
  Polygon polygons[];
  int nPoints;
  int nPolys;

  float   jumpDx, jumpDy;
  boolean exists;
  float INIT_TH = 14;
  float   thickness = INIT_TH;

  //---------------------------------------------------------------------------
  Gesture(int mw, int mh) {
    w = mw;
    h = mh;
    capacity = 600;
    path = new Vec3f[capacity];
    polygons = new Polygon[capacity];
    crosses  = new int[capacity];
    for (int i=0;i<capacity;i++){
      polygons[i] = new Polygon();
      polygons[i].npoints = 4;
      path[i] = new Vec3f();
      crosses[i] = 0;
    }
    nPoints = 0;
    nPolys = 0;

    exists = false;
    jumpDx = 0;
    jumpDy = 0;
  }

  //---------------------------------------------------------------------------
  void clear(){
    nPoints = 0;
    exists = false;
    thickness = INIT_TH;
  }

  //---------------------------------------------------------------------------
  void clearPolys(){
    nPolys = 0;
  }

  //---------------------------------------------------------------------------
  void addPoint(float x, float y){
    if (nPoints >= capacity){
      // there are all sorts of possible solutions here,
      // but for abject simplicity, I don't do anything.
    } else {
      float v = distToLast(x, y);
      float p = getPressureFromVelocity(v);
      path[nPoints++].set(x,y,p);

      if (nPoints > 1) {
        exists = true;
        jumpDx = path[nPoints-1].x - path[0].x;
        jumpDy = path[nPoints-1].y - path[0].y;
      }
    }

  }

  //---------------------------------------------------------------------------
  float getPressureFromVelocity(float v){
    float scale = 18f;
    float minP = 0.02f;
    float oldP = (nPoints > 0) ? path[nPoints-1].p : 0;
    return  ((minP + max(0, 1.0f - v/scale)) + (damp1*oldP))*dampInv;
  }

  //---------------------------------------------------------------------------
  void setPressures(){
    // pressures vary from 0...1
    float pressure;
    Vec3f tmp;
    double t = 0;

    float u = 1.0f/(float)(nPoints - 1)*TWO_PI;
    for (int i=0; i<nPoints; i++){
      pressure = (float) Math.sqrt((1.0f - Math.cos(t))*0.5f);
      path[i].p = pressure;
      t += u;
    }
  }

  //---------------------------------------------------------------------------
  float distToLast(float ix, float iy){
    if (nPoints > 0){
      Vec3f v = path[nPoints-1];
      float dx = v.x - ix;
      float dy = v.y - iy;
      return (float) Math.sqrt(dx*dx + dy*dy);
    } else {
      return 30;
    }
  }

  //---------------------------------------------------------------------------
  void compile(){
    // compute the polygons from the path of Vec3f's
    if (exists){
      clearPolys();

      Vec3f p0, p1, p2;
      float radius0, radius1;
      float ax, bx, cx, dx;
      float ay, by, cy, dy;
      int   axi, bxi, cxi, dxi, axip, axid;
      int   ayi, byi, cyi, dyi, ayip, ayid;
      float p1x, p1y;
      float dx01, dy01, hp01, si01, co01;
      float dx02, dy02, hp02, si02, co02;
      float dx13, dy13, hp13, si13, co13;
      float taper = 1.0f;

      int  nPathPoints = nPoints - 1;
      int  lastPolyIndex = nPathPoints - 1;
      float npm1finv =  1.0f/(float)(Math.max(1, nPathPoints - 1));

      // handle the first point
      p0 = path[0];
      p1 = path[1];
      radius0 = p0.p*thickness;
      dx01 = p1.x - p0.x;
      dy01 = p1.y - p0.y;
      hp01 = (float) Math.sqrt(dx01*dx01 + dy01*dy01);
      if (hp01 == 0) {
        hp02 = 0.0001f;
      }
      co01 = radius0 * dx01 / hp01;
      si01 = radius0 * dy01 / hp01;
      ax = p0.x - si01;	ay = p0.y + co01;
      bx = p0.x + si01;	by = p0.y - co01;

      int xpts[];
      int ypts[];

      int LC = 20;
      int RC = w-LC;
      int TC = 20;
      int BC = h-TC;
      float mint = 0.618f;
      double tapow = 0.4f;

      // handle the middle points
      int i=1;
      Polygon apoly;
      for (i=1; i<nPathPoints; i++){
        taper = (float)(Math.pow((lastPolyIndex-i)*npm1finv,tapow));

        p0 = path[i-1];
        p1 = path[i  ];
        p2 = path[i+1];
        p1x = p1.x;
        p1y = p1.y;
        radius1 = Math.max(mint,taper*p1.p*thickness);

        // assumes all segments are roughly the same length...
        dx02 = p2.x - p0.x;
        dy02 = p2.y - p0.y;
        hp02 = (float) Math.sqrt(dx02*dx02 + dy02*dy02);
        if (hp02 != 0) {
          hp02 = radius1/hp02;
        }
        co02 = dx02 * hp02;
        si02 = dy02 * hp02;

        // translate the integer coordinates to the viewing rectangle
        axi = axip = (int)ax;
        ayi = ayip = (int)ay;
        axi=(axi<0)?(w-((-axi)%w)):axi%w;
        axid = axi-axip;
        ayi=(ayi<0)?(h-((-ayi)%h)):ayi%h;
        ayid = ayi-ayip;

        // set the vertices of the polygon
        apoly = polygons[nPolys++];
        xpts = apoly.xpoints;
        ypts = apoly.ypoints;
        xpts[0] = axi = axid + axip;
        xpts[1] = bxi = axid + (int) bx;
        xpts[2] = cxi = axid + (int)(cx = p1x + si02);
        xpts[3] = dxi = axid + (int)(dx = p1x - si02);
        ypts[0] = ayi = ayid + ayip;
        ypts[1] = byi = ayid + (int) by;
        ypts[2] = cyi = ayid + (int)(cy = p1y - co02);
        ypts[3] = dyi = ayid + (int)(dy = p1y + co02);

        // keep a record of where we cross the edge of the screen
        crosses[i] = 0;
      if ((axi<=LC)||(bxi<=LC)||(cxi<=LC)||(dxi<=LC)){ crosses[i]|=1;}
      if ((axi>=RC)||(bxi>=RC)||(cxi>=RC)||(dxi>=RC)){ crosses[i]|=2;}
      if ((ayi<=TC)||(byi<=TC)||(cyi<=TC)||(dyi<=TC)){ crosses[i]|=4;}
      if ((ayi>=BC)||(byi>=BC)||(cyi>=BC)||(dyi>=BC)){ crosses[i]|=8;}

        //swap data for next time
        ax = dx; ay = dy;
        bx = cx; by = cy;
      }

      // handle the last point
      p2 = path[nPathPoints];
      apoly = polygons[nPolys++];
      xpts = apoly.xpoints;
      ypts = apoly.ypoints;

      xpts[0] = (int)ax;
      xpts[1] = (int)bx;
      xpts[2] = (int)(p2.x);
      xpts[3] = (int)(p2.x);

      ypts[0] = (int)ay;
      ypts[1] = (int)by;
      ypts[2] = (int)(p2.y);
      ypts[3] = (int)(p2.y);

    }
  }

  //---------------------------------------------------------------------------
  void smooth(){
    // average neighboring points

    float weight = 18f;
    float scale  = 1.0f/(weight + 2f);
    int nPointsMinusTwo = nPoints - 2;
    Vec3f lower, upper, center;

    for (int i=1; i<nPointsMinusTwo; i++){
      lower = path[i-1];
      center = path[i];
      upper = path[i+1];

      center.x = (lower.x + weight*center.x + upper.x)*scale;
      center.y = (lower.y + weight*center.y + upper.y)*scale;
    }
  }

}

