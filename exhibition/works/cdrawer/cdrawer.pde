// This code was written with the _ALPHA_ version 
// of Processing and may not run correctly in the 
// current version.

// C-Drawer by Marius Watz, May 2003
//
// Like drawing with a bunch of crayons in one hand.
// Simple and messy, but fun.
//

int cnt,stateCnt;
float x,y,oldx,oldy;
float dir,speed,speedD,rot,rotD,rad;
float minSpeed,maxSpeed,minRad,maxRad;

float col[][],alpha;
int colNum,c;
int satelliteNum,satelliteMode;
boolean initialised;

BFont theFont;

ValueChanger dirD,speedVar;
boolean dirVariation,speedVariation;

int interfaceHeight,playHeight;

void setup() {
  interfaceHeight=40;

  size(600,440);
  playHeight=height-interfaceHeight;

  doNotInitialised();
  theFont=loadFont("Meta-Bold.vlw.gz");

  x=0;
  y=0;
  oldx=0;
  oldy=0;

  minSpeed=0.4f;
  maxSpeed=2.5f;
  speed=minSpeed;
  speedD=0;

  rot=3;
  rotD=0;

  minRad=3;
  maxRad=12;
  rad=minRad;

  cnt=0;

  dir=random(360);
  dirD=new ValueChanger(0,2,-2,0.05,0.0025);
  dirVariation=true;

  speedVar=new ValueChanger(0,1,-1,0.02,0.001);
  satelliteNum=0;
  satelliteMode=0;

  colNum=0;
  col=new float[100][3];
  defineColors();
  theFont=loadFont("Meta-Bold.vlw.gz");//"Univers55.vlw.gz");
}

void loop() {
  cnt++;
  oldx=x;
  oldy=y;

  if(initialised) {
    noBackground();
    smooth();

    if(dirVariation) {
      dirD.update();
      dir+=dirD.val;//=(dir+dirD.val)%360;
    }
    dir+=rot;

    if(speedVariation) {
      speedVar.update();
      speed+=speedVar.val*0.01;
    }
    if(stateCnt>0)  {
      stateCnt--;
      speed+=speedD;
      rot+=rotD;
    }
    if(speed>maxSpeed) speed=maxSpeed;
    else if(speed<minSpeed) speed=minSpeed;

    x+=cos(radians(dir))*speed;
    y+=sin(radians(dir))*speed;

    noStroke();
    ellipseMode(CENTER_DIAMETER);

    rad=sq(speed/maxSpeed)*(maxRad-minRad)+minRad;
    alpha=sq(speed/maxSpeed)*75+100;
    if(satelliteMode==2) alpha-=50;
    
    c=int(cnt/60)%colNum;
    fill(col[c][0],col[c][1],col[c][2],alpha);
    ellipse(x,y,rad,rad);

    c=int(cnt/60+colNum/2)%colNum;
    fill(col[c][0],col[c][1],col[c][2],alpha);
    for(int i=0; i<(satelliteNum+1)*4; i++) plotSatellite(i+1);

    /*    if((x+rad)<0) x+=(width+rad);
    if((x-rad)>width) x-=(width+rad);
    if((y+rad)<0) y+=(playHeight+rad);
    if((y-rad)>playHeight) y-=(playHeight+rad);*/
    if(x<0) x+=width;
    else if(x>width) x-=width;
    if(y<0) y+=playHeight;
    else if(y>playHeight) y-=playHeight;
  }
  else {
    noSmooth();
    setFont(theFont,20);
    hint(SMOOTH_IMAGES);
    fill(255,255,255);
    text("Click somewhere to start",100,100);
  }

  // Draw interface

  noStroke();
  fill(110,110,120);
  rect(0,height-interfaceHeight,width,interfaceHeight);

  for(int i=0; i<3; i++) {
    if(satelliteMode==i) setInterfaceColor(true);
    else setInterfaceColor(false);
    rect(13+i*24,playHeight+13,14,14);
  }

  setInterfaceColor(dirVariation);
  rect(100,playHeight+13,14,14);

  setInterfaceColor(speedVariation);
  rect(124,playHeight+13,14,14);

  setInterfaceColor(true);
  rect(162,playHeight+13,14,14);
  rect(186,playHeight+13,14,14);
  setInterfaceColor(false);
  rect(163,playHeight+14,12,12);
  rect(187,playHeight+14,12,12);

  setInterfaceColor(true);
  rect(165,playHeight+19,8,2);

  rect(189,playHeight+19,8,2);
  rect(192,playHeight+16,2,8);

  fill(255,0,0);
  rect(width-33,playHeight+10,20,20);
}

void setInterfaceColor(boolean on) {
  if(on) fill(255,200,0);
  else fill(60,60,120);
}

boolean checkButton(int x,int y,int w,int h) {
  // println("mx "+mouseX+" my "+mouseY+" x "+x+" y "+y+" w "+w);
  if(mouseX>=x &&  mouseX<(x+w) && mouseY>=y && mouseY<(y+h)) return true;
  else return false;
}

void mousePressed() {
  if(mouseY>playHeight) { //Check interface
    if(checkButton(13,playHeight+13,14,14)) satelliteMode=0;
    else if(checkButton(37,playHeight+13,14,14)) satelliteMode=1;
    else if(checkButton(61,playHeight+13,14,14)) satelliteMode=2;
    else if(checkButton(100,playHeight+13,14,14)) dirVariation=!dirVariation;
    else if(checkButton(124,playHeight+13,14,14)) speedVariation=!speedVariation;
    else if(checkButton(162,playHeight+13,14,14) && satelliteNum>=0) satelliteNum--;
    else if(checkButton(186,playHeight+13,14,14) && satelliteNum<4) satelliteNum++;
    else if(checkButton(width-33,playHeight+10,14,14)) background(60,60,120);
  }
  else mouseDragged();
}

void mouseDragged() {
  float mx,my,newSpeed,newRot,newRad,newAlpha;

  if(mouseY<=playHeight) { // Get interaction parameters
    if(!initialised) {
      initialised=true;
      background(60,60,120);
      x=mouseX;
      y=mouseY;
    }
    //    satelliteNum=(satelliteNum+1)%4;

    stateCnt=50;

    mx=mouseX;
    mx=sq(mx/width);

    newSpeed=mx*(maxSpeed-minSpeed)+minSpeed;
    speedD=(newSpeed-speed)/stateCnt;

    my=mouseY-playHeight/2;
    my=sq(my/(playHeight/2));
    if(mouseY<playHeight/2) my=-my;
    newRot=my*6;
    rotD=(newRot-rot)/stateCnt;
  }
}

void plotSatellite(int i) {
  float deg,x2,y2,x3,y3;

  if(satelliteMode==0) deg=radians(dir+137.5*i); //radians(dir+90+180*i)
  else if(satelliteMode==1) deg=radians(dir+180*i+90);
  else deg=radians(137.5*i);
  x2=x;
  y2=y;
  x2+=cos(deg)*speed*(i+1);
  y2+=sin(deg)*speed*(i+1);

  if(satelliteMode<2) {
    if(x2>width) x2-=width;
    else if(x2<0) x2+=width;
    if(y2>playHeight) y2-=playHeight;
    else if(y2<0) y2+=playHeight;
  }

  if(satelliteMode==0) rect(x2,y2,2,2);
  else if(satelliteMode==1) ellipse(x2,y2,rad/4,rad/4);
  else fakeLine(x,y,x2,y2);

}

void doNotInitialised() {
  initialised=false;
  background(60,60,120);
}

void fakeLine(float x1,float y1,float x2,float y2) {
  float px,py,l;

  push();
  translate(x1,y1);
  px=x2-x1;
  py=y2-y1;

  rotate(atan2(px,py));
  l=sqrt(sq(px)+sq(py));
  rect(0,0,l,1);
  pop();
}

void defineColors() {
  addColor(255,255,255);
  addColor(255,255,255);
  addColorRange(6, 200,100,50, 255,100,0);
  addColor(26,171,255);
  addColor(26,171,255);
  addColorRange(6, 255,200,0, 255,128,0);
}

void addColor(float r1,float g1,float b1) {
  col[colNum][0]=r1;
  col[colNum][1]=g1;
  col[colNum][2]=b1;
  colNum++;
}

void addColorRange(float steps,float r1,float g1,float b1,
float r2,float g2,float b2) {
  float rD,gD,bD;

  rD=(r2-r1)/steps;
  gD=(g2-g1)/steps;
  bD=(b2-b1)/steps;

  for(int i=0; i<steps; i++) {
    col[colNum][0]=r1+rD*i;
    col[colNum][1]=g1+gD*i;
    col[colNum][2]=b1+bD*i;
    colNum++;
  }
}

class ValueChanger {
  float val,maxVal,minVal,maxD,maxDiff,D;

  ValueChanger(float _val,float _max,float _min,float _maxD,float _maxDiff) {
    val=_val;
    maxVal=_max;
    minVal=_min;
    maxD=_maxD;
    maxDiff=_maxDiff;
    D=maxD/2;
  }

  void update() {
    if(val<minVal) D+=abs(maxDiff);
    else if(val>maxVal) D-=abs(maxDiff);
    else D+=random(maxDiff*2)-maxDiff;
    if(D>maxD) D=maxD;
    else if(D<-maxD) D=-maxD;
    val+=D;
    if(maxVal>=0 && val>maxVal*1.25) val=maxVal*1.25;
    else if(maxVal<0 && val<maxVal*1.25) val=maxVal*1.25;
    else if(minVal>=0 && val<minVal*0.75) val=minVal*0.75;
    else if(minVal<0 && val<minVal*1.25) val=minVal*1.25;
  }
}
