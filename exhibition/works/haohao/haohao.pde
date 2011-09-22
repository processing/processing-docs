/*
  Sorry,a comment is Japanese.
  
  Haohao 
  by Ichitaro Masuda
*/

// -------------------------------------------------------
// initialize global variables
// -------------------------------------------------------

int xStage = 600, yStage = 600;        // アプレットのサイズ
color bgColor;                         // 背景色

boolean drawingMode;
boolean sharp;

int count = 0;                         
int totalHaohao = 200;                 // 好ハオを生成する数
Haohao[] hao;                          // 私たちのドローイングマシン

float minRadius = 5;                   // 生成するハオの最小の半径
float maxRadius = 15;                  // 生成するハオの最大の半径

int[] lookUpTable = {0,0,1,1,1,1,2,2,2,3,3,3,4,4,4,4,
                     5,5,5,6,6,6,7,7,7,8,8,9,9,9,10,10,
                     11,11,11,12,12,13,13,14,14,15,15,16,16,17,17,18,
                     18,19,20,20,21,22,22,23,24,24,25,26,26,27,28,29,
                     29,30,31,32,33,34,35,36,37,37,38,39,40,41,42,44,
                     45,46,47,48,49,50,51,52,54,55,56,57,59,60,61,62,
                     64,65,66,68,69,70,72,73,75,76,77,79,80,82,83,85,
                     86,88,89,91,92,94,96,97,99,100,102,104,105,107,109,110,
                     112,114,115,117,119,120,122,124,126,127,129,131,133,135,136,138,
                     140,142,143,145,147,149,151,152,154,156,158,160,161,163,165,167,
                     168,170,172,174,175,177,179,180,182,184,185,187,189,190,192,193,
                     195,196,198,200,201,203,204,205,207,208,210,211,212,214,215,216,
                     217,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,
                     233,234,235,236,237,237,238,239,239,240,240,241,242,242,243,243,
                     244,244,245,245,246,246,247,247,248,248,248,249,249,249,250,250,
                     250,251,251,251,252,252,252,253,253,253,254,254,254,254,255,255};

// -------------------------------------------------------
// setup function
// -------------------------------------------------------

void setup()
{
  size(xStage, yStage);
  
  bgColor = color(lookUpTable[203], lookUpTable[191], lookUpTable[175]);
  //bgColor = color(203, 191, 175);
  background(bgColor);
  
  ellipseMode(CENTER_RADIUS);
  rectMode(CENTER_DIAMETER);

  hao = new Haohao[totalHaohao];
  for(int i=0; i<totalHaohao; i++) {
    hao[i] = new Haohao(0, 0, 0, 0, 0, 0, i);
  }
  drawingMode = true;
  sharp = false;
}

// -------------------------------------------------------
// main loop function
// -------------------------------------------------------

void loop()
{
  if(!drawingMode) {
    background(bgColor);
  }
  
  for(int i=0; i<totalHaohao; i++) {
    hao[i].update();
    hao[i].display();
  }
}

// -------------------------------------------------------
// key press event
// -------------------------------------------------------

void keyPressed()
{
  if(key == ' ') {
    drawingMode = !drawingMode;
    background(bgColor);
    if(!drawingMode)noSmooth();
    else if(sharp)smooth();
  } else if(key == 's') {
    sharp = !sharp;
    if(drawingMode) {
      background(bgColor);
      if(sharp)smooth();
      else noSmooth();
    }
  }
}

// -------------------------------------------------------
// mouse press event
// -------------------------------------------------------

void mouseDragged()
{
  //loading = true;
  //reStart();
  if(count<totalHaohao)createHao();
  else count = 0;
  //background(bgColor);
}

// -------------------------------------------------------
// create hao
// -------------------------------------------------------
void createHao()
{
   float x = mouseX;
   float y = mouseY;
   float r = random(minRadius, maxRadius);
    
   int cr = 0, cg = 0, cb = 0;
   if(count%7 == 0){
     cr = 140;
     cg = 203;
     cb = 212;
   }else if(count%7 == 1){
     cr = 222;
     cg = 233;
     cb = 239;
   }else if(count%7 == 2){
     cr = 95;
     cg = 68;
     cb = 57;
   }else if(count%7 == 3){
     cr = 240;
     cg = 205;
     cb = 173;
   }else if(count%7 == 4){
     cr = 240;
     cg = 120;
     cb = 173;
   }else if(count%7 == 5){
     cr = 240;
     cg = 240;
     cb = 240;
   }else if(count%7 == 6){
     cr = 162;
     cg = 153;
     cb = 137;
   }
 
   hao[count] = new Haohao(x, y, r, cr, cg, cb, count);
   hao[count].umare = true; 
   count++;
}

// -------------------------------------------------------
// haohao class
// -------------------------------------------------------

class Haohao{
  
  float x,y;
  float r,or;
  float viewSize;
  
  int index;
  int cr,cg,cb;
  
  boolean[] hasConnections;
  float[] love;
  float[] sqDistances;
  float[] thetas;
  
  int eye_target;
  float eye_r, eye_nextR;
  float eye_x, eye_y, eye_nextX, eye_nextY;
  float eye_globalX, eye_globalY;
  
  boolean umare = false;
  
  // constructor
  Haohao(float X, float Y, float R, int CR, int CG, int CB, int I) {
    
    x = X;
    y = Y;
    
    r = R;
    or = R;
    viewSize = r*6;
    
    index = I;
    cr = CR;
    cg = CG;
    cb = CB;
    
    hasConnections = new boolean[totalHaohao];
    love = new float[totalHaohao];
    setLove();
    sqDistances = new float[totalHaohao];
    
    eye_target = -1;
    eye_r = r*0.8;
    eye_nextR = r*0.8;
    eye_x = 0;
    eye_y = 0;
    eye_nextX = 0;
    eye_nextY = 0;
    
  }
  
  // 好き嫌いをランダムに初期化
  void setLove() {
    for(int i=0; i<totalHaohao; i++) {
      love[i] = random(-3,3);
    }
  }
  
  // 好ハオの更新
  void update() {
    if(umare) {
      updateR();
      behave();
      over();
      updateEye();
      areWeConnected();
    }
  }
  
  // 死期がちかいよ
  void updateR() {
    if(index >= count)r = or*(index-count)/totalHaohao;
    else r = or*(totalHaohao-count+index)/totalHaohao;
    viewSize = r*6;
  }
  
  // (視界内のハオに対する)好き嫌いに基づく振る舞い
  void behave() {
    float needx = 0;
    float needy = 0;
    float numView = 0; 
    for(int i=0; i<totalHaohao; i++) {
      if(i != index) {   
        float dx = hao[i].x - x;
        float dy = hao[i].y - y;
        sqDistances[i] = dx*dx + dy*dy;
        float sqViewSize = viewSize*viewSize;      
        if(sqDistances[i] < sqViewSize) {
          float scl = 1 - sqDistances[i]/sqViewSize;
          needx += dx*love[i]*scl*0.1;
          needy += dy*love[i]*scl*0.1;
          numView++;
        }
      }
    }
    if(numView > 0){
      x += needx/numView;
      y += needy/numView;
    }
  }
  
  // 干渉による振る舞い
  void over() {
    eye_target = -1;
    float tempLove = 0;
    float tempTheta = 0;
    for(int i=0; i<totalHaohao; i++) {
      if(i != index) {
        float rr = r+hao[i].r;
        if(sqDistances[i] < sq(rr)) {
          float dx = hao[i].x - x;
          float dy = hao[i].y - y;
          float theta = atan2(dy, dx);
          if(theta == 0) {
            theta = random(1);
          }
          if(love[i] > tempLove) {
            tempLove = love[i];
            eye_target = i;
            tempTheta = theta;
          }
          float overDepth = rr-sqrt(sqDistances[i]);
          x += overDepth*cos(theta+PI);
          y += overDepth*sin(theta+PI);
        }
      }
    }
    if(eye_target != -1) {
      focus(tempTheta);
      boolean loveMatch = (index == hao[eye_target].eye_target);
      if(loveMatch) {
        hasConnections[eye_target] = true;
        hao[eye_target].hasConnections[index] = true;
      }
    } else {
      revertFocus();
    }
  }
  
  //瞳の振る舞い
  void updateEye() {
    eye_x += (eye_nextX - eye_x)/3;
    eye_y += (eye_nextY - eye_y)/3;
    eye_r += (eye_nextR - eye_r)/5;
    eye_globalX = x + eye_x;
    eye_globalY = y + eye_y;
  }
  
  void focus(float ra) {
    eye_nextX = 0.8*r*cos(ra);
    eye_nextY = 0.8*r*sin(ra);
    eye_nextR = 0.2*r;
  }
  
  void revertFocus() {
    eye_nextX = 0;
    eye_nextY = 0;
    eye_nextR = 0.8 * r;
  }
  
  //わたしたちはコネクトしているか
  void areWeConnected() {
    for(int i=0; i<totalHaohao; i++) {
      if(i<index){
        if(hasConnections[i] == true) {
          float connectDistance = viewSize + hao[i].viewSize;
          if(sqDistances[i] > connectDistance*connectDistance) {
            hasConnections[i] = false;
            hao[i].hasConnections[index] = false;
          }
        }
      }
    }
  }
  
  //ハオの表示
  void display() {
    if(umare) {
      if(!drawingMode) {
        noFill();
        stroke(cr, cg, cb);
        ellipse(x, y, r, r);
        displayEye();
      }
      displayLink();
    }
  }
  
  void displayEye() {
    fill(cr, cg, cb);
    noStroke();
    ellipse(eye_globalX, eye_globalY, eye_r, eye_r);
  }
  
  void displayLink() {
    for(int i=0; i<totalHaohao; i++) {
      if(i<index){
        if(hasConnections[i] == true) {
          float theta = atan2(hao[i].y-y, hao[i].x-x);
          float cos = cos(theta);
          float sin = sin(theta);
          float x1 = x+r*cos;
          float y1 = y+r*sin;
          float x2 = hao[i].x-hao[i].r*cos;
          float y2 = hao[i].y-hao[i].r*sin;
          float scl = (drawingMode) ? 1 : 0 + sqDistances[i] / 2500;
          float hx1 = x1 + scl*(x1 - eye_globalX);
          float hy1 = y1 + scl*(y1 - eye_globalY);
          float hx2 = x2 + scl*(x2 - hao[i].eye_globalX);
          float hy2 = y2 + scl*(y2 - hao[i].eye_globalY);
          int r = (int)((cr+hao[i].cr) / 2.0);
          int g = (int)((cg+hao[i].cg) / 2.0);
          int b = (int)((cb+hao[i].cb) / 2.0);
          noFill();
          if(!drawingMode) {
            float rotX = -eye_r*sin;
            float rotY = eye_r*cos;
            float px1 = eye_globalX + rotX;
            float py1 = eye_globalY + rotY;
            float px2 = eye_globalX - rotX;
            float py2 = eye_globalY - rotY;
            noStroke();
            fill(cr, cg, cb);
            triangle(px1, py1, px2, py2, x1, y1);
            
            rotX = hao[i].eye_r*sin;
            rotY = -hao[i].eye_r*cos;
            px1 = hao[i].eye_globalX + rotX;
            py1 = hao[i].eye_globalY + rotY;
            px2 = hao[i].eye_globalX - rotX;
            py2 = hao[i].eye_globalY - rotY;
            noStroke();
            fill(hao[i].cr, hao[i].cg, hao[i].cb);
            triangle(px1, py1, px2, py2, x2, y2);
            
            stroke(r, g, b);
            strokeWeight(1);
          } else {
            r = lookUpTable[r];
            g = lookUpTable[g];
            b = lookUpTable[b];
            int a = (sharp) ? 100 : 15;
            stroke(r, g, b, a);
            strokeWeight(2);
          }
          bezier(x1, y1, hx1, hy1, hx2, hy2, x2, y2);
        }
      }
    }
  }
}
    
    
    
    
  

