// This code was written with the _ALPHA_ version 
// of Processing and may not run correctly in the 
// current version.


// sodaproce55ing
// by ED <http://www.soda.co.uk/members/ed.htm>

// Created April 2003

Mass masses[];
int massCount=0;

float mouseTolerance=15;

Mass dragMass=null;
float dragDx,dragDy;
float tempDistance;

Mass drawMass=null;
Mass overMass;

Spring springs[];
int springCount=0;
Spring overSpring;

Control controls[];
Control activeControl=null;

Button make,move,delete;
Slider g,f,k;
int sliderHeight=13;

static final float speedFrictionThreshold=20;

BFont font;

int mode;
static final int MAKE=0;
static final int MOVE=1;
static final int DELETE=2;

String toolTips[];

void setup()
{
  size(280, 255);
  background(0xFF);
  ellipseMode(CENTER_DIAMETER);

  masses=new Mass[8];
  springs=new Spring[8];

  font = loadFont("RotisSanSer-Bold.vlw.gz");
  setFont(font, 15);
  hint(SMOOTH_IMAGES);
  smooth();
  controls=new Control[6];
  int x=0;
  int i=0;
  int controlWidth=width/(controls.length)+1;
  controls[i++]=make=new Button(0,0,controlWidth-1,sliderHeight,"make");
  controls[i++]=move=new Button(controls[i-2].x+controls[i-2].w,0,controlWidth-1,sliderHeight,"move");
  controls[i++]=delete=new Button(controls[i-2].x+controls[i-2].w,0,controlWidth-1,sliderHeight,"delete");
  controls[i++]=g=new Slider(controls[i-2].x+controls[i-2].w,0,controlWidth,sliderHeight,0,4,0.0,"g");
  controls[i++]=f=new Slider(controls[i-2].x+controls[i-2].w,0,controlWidth,sliderHeight,0,1,0.1,"f");
  controls[i++]=k=new Slider(controls[i-2].x+controls[i-2].w,0,controlWidth,sliderHeight,0,0.75,0.5,"k");
  make.selected=true;
  checkMode();

  toolTips=new String [] {
    ": click to make masses and springs"
    ,": click, drag and throw masses"
    ,": click to delete masses and springs"
    ," = gravity (hint, set to zero to before choosing to make)"
    ," = friction"
  ," = spring stiffness"};
}

void loop()
{
  doUpdate();
  display();
}

void checkMode() {
  for (int i=0;i<controls.length;i++)
  if (controls[i] instanceof Button && ((Button)controls[i]).selected)
  mode=i;
  if (mode!=MAKE)
  drawMass=null;
}

void mouseMoved() {
  for (int i=0;i<controls.length;i++)
  controls[i].mouseIn();

  tempDistance=-1;
  Mass m=null;
  if (mode==MOVE || mode==MAKE || mode==DELETE)
  m=mouseMass();
  float md=tempDistance;
  tempDistance=-1;
  Spring s=null;
  if (mode==DELETE)
  s=mouseSpring();
  float sd=tempDistance;
  if (m!=null && md!=-1 && (md<=sd || sd==-1) && md<mouseTolerance) {
    overMass=m;
    overSpring=null;
  } else if (s!=null && sd!=-1 && (sd<md || md==-1) && sd<mouseTolerance) {
    overSpring=s;
    overMass=null;
  } else {
    overMass=null;
    overSpring=null;
  }
}

void mouseDragged() {
  if (activeControl!=null)
  activeControl.mouseDragged();
  else
  if (dragMass!=null) {
    dragMass.x=mouseX+dragDx;
    dragMass.y=mouseY+dragDy;
    dragMass.xv=mouseX-pmouseX;
    dragMass.yv=mouseY-pmouseY;
    dragMass.clamp();
  }
}

void mouseReleased() {
  if (activeControl!=null) {
    if (activeControl.mouseReleased() && activeControl instanceof Button) {
      for (int i=0;i<controls.length;i++)
      if (controls[i]!=activeControl && controls[i] instanceof Button)
      ((Button)controls[i]).selected=false;
      checkMode();
    }
    activeControl=null;
  }
  if (dragMass!=null) {
    if (overMass==dragMass)
    overMass=null;
    dragMass=null;
  }
}

void mousePressed() {
  activeControl=null;
  for (int i=0;i<controls.length && activeControl==null;i++)
  if ( controls[i].mousePressed() && !(controls[i] instanceof Button && ((Button)controls[i]).selected))
  activeControl=controls[i];
  if (activeControl==null) {
    switch(mode) {
      case MAKE:
      Mass m=mouseMass();
      if (m!=null && tempDistance<mouseTolerance) {
        if (drawMass!=null) {
          if (drawMass!=m) {
            boolean springExists=false;
            for (int i=0;i<springCount&&!springExists;i++)
            springExists = ((springs[i].a==drawMass && springs[i].b==m)||(springs[i].b==drawMass && springs[i].a==m));
            if (!springExists)
            addSpring(new Spring(drawMass,m));
          }
          drawMass=null;
        } else {
          drawMass=m;
        }
      } else {
        Mass newMass;
        addMass(newMass=new Mass(mouseX,mouseY));
        if (drawMass!=null)
        addSpring(new Spring(drawMass,newMass));
        drawMass=newMass;
      }
      break;
      case MOVE:
      m=mouseMass();
      if (m!=null && tempDistance<mouseTolerance) {
        overMass=dragMass=m;
        dragDx=m.x-mouseX;
        dragDy=m.y-mouseY;
      } else
      overMass=dragMass=null;
      break;
      case DELETE:
      if (overMass!=null) {
        for (int i=0;i<springCount;i++)
        if (springs[i].a==overMass || springs[i].b==overMass)
        deleteSpring(springs[i--]);
        deleteMass(overMass);
        if (overMass==dragMass)
        dragMass=null;
        overMass=null;
      } else if (overSpring!=null) {
        deleteSpring(overSpring);
        overSpring=null;
      }
      break;
    }
  }
}

Mass mouseMass() {
  tempDistance=-1;
  Mass m=null;
  for (int i=0;i<massCount;i++) {
    float d=masses[i].distanceTo(mouseX,mouseY);
    if (d!=-1 && (d<tempDistance || tempDistance==-1)) {
      tempDistance=d;
      m=masses[i];
    }
  }
  return m;
}

Spring mouseSpring() {
  tempDistance=-1;
  Spring s=null;
  for (int i=0;i<springCount;i++) {
    float d=springs[i].distanceTo(mouseX,mouseY);
    if (d!=-1 && (d<tempDistance || tempDistance==-1)) {
      tempDistance=d;
      s=springs[i];
    }
  }
  return s;
}

void doUpdate() {
  for (int i=0;i<springCount;i++)
  springs[i].applyForces();
  for (int i=0;i<massCount;i++)
  if (masses[i]!=dragMass)
  masses[i].update();
}

void display() {
  stroke(0x00,0x99,0xFF);
  fill(0xFF,0xFF,0xFF);
  rect(0,0,width-1,height-1);

  for (int i=0;i<springCount;i++)
  springs[i].display();

  if (drawMass!=null) {
    stroke(0x00,0x99,0xFF);
    line(drawMass.x,drawMass.y,mouseX,mouseY);
  }

  for (int i=0;i<massCount;i++)
  masses[i].display();

  for (int i=0;i<controls.length;i++)
  controls[i].display();

  fill(0x00,0x99,0xFF);
  for (int i=0;i<controls.length;i++)
  if (controls[i].over)
  text(controls[i].label+toolTips[i], 2, sliderHeight*3-3);
}

// list handling for masses

void addMass(Mass mass) {
  if (massCount == masses.length) {
    Mass temp[] = new Mass[massCount*2];
    System.arraycopy(masses, 0, temp, 0, massCount);
    masses = temp;
  }
  masses[massCount++] = mass;
}

void deleteMass(Mass mass) {
  int index=massIndex(mass);
  if (index>=0)
  deleteMassIndex(index);
}

void deleteMassIndex(int index) {
  if (index<massCount)
  System.arraycopy(masses, index+1, masses, index, massCount-index);
  massCount--;
}

int massIndex(Mass mass) {
  for (int i=0;i<massCount;i++)
  if (masses[i]==mass)
  return i;
  return -1;
}

// list handling for springs

void addSpring(Spring spring) {
  if (springCount == springs.length) {
    Spring temp[] = new Spring[springCount*2];
    System.arraycopy(springs, 0, temp, 0, springCount);
    springs = temp;
  }
  springs[springCount++] = spring;
}

void deleteSpring(Spring spring) {
  int index=springIndex(spring);
  if (index>=0)
  deleteSpringIndex(index);
}

void deleteSpringIndex(int index) {
  if (index<springCount)
  System.arraycopy(springs, index+1, springs, index, springCount-index);
  springCount--;
}

int springIndex(Spring spring) {
  for (int i=0;i<springCount;i++)
  if (springs[i]==spring)
  return i;
  return -1;
}

// end of list handling

class Mass {
  static final float diamter=5;
  static final float radius=1+diamter/2;

  float x,y,xv,yv;

  Mass(int x, int y) {
    this.x=x;
    this.y=y;
  }

  void update() {
    yv+=g.value;

    double speed=sqrt(xv*xv+yv*yv);
    double fs=1-f.value;
    if (speed>speedFrictionThreshold)
    fs*=speedFrictionThreshold/speed;
    xv*=fs;
    yv*=fs;

    x+=xv;
    y+=yv;

    if (x<radius) {
      x-=x-radius;
      xv=-xv;
    } else if (x>width-radius) {
      x-=x-(width-radius);
      xv=-xv;
    }
    if (y<sliderHeight+radius) {
      y-=y-(sliderHeight+radius);
      yv=-yv;
    } else if (y>height-radius) {
      y-=y-(height-radius);
      yv=-yv;
    }
  }

  void clamp() {
    if (x<radius) {
      x=radius;
    } else if (x>width-radius) {
      x=width-radius;
    }
    if (y<sliderHeight+radius) {
      y=sliderHeight+radius;
    } else if (y>height-radius) {
      y=height-radius;
    }
  }

  void display() {
    if (this==overMass) {
      stroke(0x00,0x99,0xFF);
      line(x,y,mouseX,mouseY);
      noStroke();
      fill(0x00,0x99,0xFF);
    }
    else {
      noStroke();
      fill(0);
    }
    ellipse(x,y,diamter,diamter);
  }

  float distanceTo(Mass m) {
    return distanceTo(m.x,m.y);
  }

  float distanceTo(float x,float y) {
    float dx=this.x-x;
    float dy=this.y-y;
    return sqrt(dx*dx+dy*dy);
  }
}

class Spring {
  Mass a,b;
  float restLength;

  Spring(Mass a,Mass b) {
    this.a=a;
    this.b=b;
    restLength=a.distanceTo(b);
  }

  void display() {
    if (this==overSpring) {
      stroke(0x00,0x99,0xFF);
      float vx=b.x-a.x;
      float vy=b.y-a.y;
      float dot= (vx*vx + vy*vy);
      float rx=mouseX-a.x;
      float ry=mouseY-a.y;
      float dot2= (vx*rx + vy*ry);
      float value= dot2/dot;
      value=min(value,1);
      value=max(value,0);
      float x=((b.x*value)+(a.x*(1-value)));
      float y=((b.y*value)+(a.y*(1-value)));
      line(x,y,mouseX,mouseY);
    }
    else {
      stroke(0);
    }
    line(a.x,a.y,b.x,b.y);
  }

  void applyForces() {
    double d=a.distanceTo(b);
    if (d>0)
    {
      double f=(d-restLength)*k.value;
      double fH=(f/d)*(a.x-b.x);
      double fV=(f/d)*(a.y-b.y);
      a.xv-=fH;
      a.yv-=fV;
      b.xv+=fH;
      b.yv+=fV;
    }
  }

  float distanceTo(float x,float y) {
    if (x>(min(a.x,b.x)-mouseTolerance)
    &&x<(max(a.x,b.x)+mouseTolerance)
    &&y>(min(a.y,b.y)-mouseTolerance)
    &&y<(max(a.y,b.y)+mouseTolerance))
    {
      float vx=b.x-a.x;
      float vy=b.y-a.y;
      float dot= (vx*vx + vy*vy);
      float rx=x-a.x;
      float ry=y-a.y;
      float dot2= (vx*rx + vy*ry);
      float value= dot2/dot;

      if (value<0) {
        float d=a.distanceTo(x,y);
        return d<=mouseTolerance?d:-1;
      } else if (value>1) {
        float d=b.distanceTo(x,y);
        return d<=mouseTolerance?d:-1;
      }

      float px=((b.x*value)+(a.x*(1-value)))-x;
      float py=((b.y*value)+(a.y*(1-value)))-y;

      float d=sqrt(px*px+py*py);

      return d<=mouseTolerance?d:-1;
    }
    else
    return  -1;
  }
}

class Control {
  int x,y,w,h;
  boolean over=false;
  String label;

  Control(int x, int y, int w, int h, String label) {
    this.x=x;
    this.y=y;
    this.w=w;
    this.h=h;
    this.label=label;
  }

  boolean mouseIn() {
    return over=mouseX>x&&mouseX<x+w&&mouseY>y&&mouseY<y+h;
  }

  boolean mousePressed() {
    return mouseIn();
  }

  void mouseDragged() {
    mouseIn();
  }

  boolean mouseReleased() {
    return mouseIn();
  }

  void display() {
    stroke(0x00,0x99,0xFF);
    if (over)
    fill(0xDD,0xDD,0xDD);
    else
    fill(0xFF,0xFF,0xFF);
    rect(x,y,w,h);
    drawContents();
    stroke(0);
    fill(0);
    text(label, x+2, (y+h)-3);
  }

  void drawContents() {

  }
}

class Button extends Control {
  boolean selected=false;
  boolean down=false;
  Button(int x, int y, int w, int h, String label) {
    super(x,y,w,h,label);
  }

  boolean mousePressed() {
    if (super.mousePressed() && !selected)
    down=true;
    return down;
  }

  boolean mouseReleased() {
    down=false;
    if (super.mouseIn()) {
      selected=!selected;
      return true;
    }
    return false;
  }

  void drawContents() {
    if (selected||down) {
      if (!selected&&(over^down))
      fill(0xDD,0xDD,0xDD);
      else
      fill(0x00,0x99,0xFF);
      noStroke();
      rect(x+1,y+1,w-1,h-1);
    }
  }
}

class Slider extends Control {
  float min,max,value;
  int labelW=8;

  Slider(int x, int y, int w, int h, float min, float max, float value,String label) {
    super(x,y,w,h,label);
    this.min=min;
    this.max=max;
    this.value=value;
  }

  void mouseDragged() {
    setValueToMouse();
  }

  boolean mousePressed() {
    boolean down;
    if (down=super.mousePressed())
    setValueToMouse();
    return down;
  }

  void setValueToMouse() {
    int mw=(w-labelW)-1;
    float mv=(mouseX-(x+labelW+1.0))/mw;
    if (mv>0)
    value=min+(mv*mv)*(max-min);
    else
    value=min;
    value=min(value,max);
  }

  void drawContents() {
    fill(0x00,0x99,0xFF);
    noStroke();
    int mw=(w-labelW)-1;
    float vw=sqrt((value-min)/(max-min))*mw;
    rect(x+labelW+1,y+1,vw,h-1);
  }

  void display() {
    super.display();
    stroke(0x00,0x99,0xFF);
    line(x+labelW,y,x+labelW,y+h);
  }
}

