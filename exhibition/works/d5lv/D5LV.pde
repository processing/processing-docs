// W:Mute 2004
// www.wmute.org

// cubeDividor is a cube that continuously divides in smaller sub-cubes.
// float parameters for cubeDividor: size, disorder, survival probability of sub-cubes
// int parameters for cubeDividor: number of divisions per axis, maximum number of subcubes
cubeDividor cubeThing; 
float side, noise, prob; 
int divisions, maxCubes; 

// range of colors defined from an image, adapted from Jared Tarbell, http://www.complexification.net/
// current palette: 0=red earth, 1=water, 2=life
palette[] pal; 
int currentPalette; 

// abstract object that makes it easier to manage a screen divided in a number of panel
// at any time the drawing area is centered on a single panel -- no boundary clipping implemented (drawing can exceed panel)
panelledScreen screen;
int border, panelWidth, panelHeight, rows, cols;

// checkout arielm's work for this one, http://www.chronotext.org
ArcBall arcball; 

// interpolated mouse: bufferedMouse position is a weighted average of previous value and current mous position
BufferedMouse bufferedMouse;

//program flags
boolean firstClick; // flag, captures first mouse-click (to enable keyboard input without resetting applet)
boolean firstRun; // flag, on first frame draw borders
int count;

//array for Zbuffer clearing trick, credit to Toxi, http://www.toxi.co.uk/
//black magic to avoid line drawing artefacts
float[]  clearZ;


void setup(){
  //screen setup
  int border=20; // gray border between panels
  int panelWidth=200; // width of single panel
  int panelHeight=200; // height of single panel
  int rows=4;// panels per column
  int cols=3;// panels per row
  screen= new panelledScreen(rows, cols, panelWidth, panelHeight, border);
  
  //applet setup
  size(border+(border+panelWidth)*cols,border+(border+panelHeight)*rows);// autofit applet to panelled screen
  framerate(20);
  
  //arcball
  arcball = new ArcBall(panelWidth / 2.0f, panelHeight / 2.0f, min(panelWidth - 10, panelHeight - 10) / 2.0f);

  //buffered mouse
  bufferedMouse=new BufferedMouse(0.5);

  //initial program flags
  firstClick=true;
  firstRun=true;
  count=0;

  //define colors -- if working locally, put your files in the data-dir and change the lines below.
    
  pal= new palette[3];
  pal[0]=new palette(256, 100, "color01.gif"); //create color palette from source
  pal[1]=new palette(256, 100, "color02.gif");
  pal[2]=new palette(256, 100, "color03.gif");
  currentPalette=int(random(3));

  //cubeDividor setup
  side=min(panelWidth,panelHeight)/4.0;// fit cube in panel
  noise=side*random(0.1);// gives nice results
  prob=random(35,85);// each division always yields at one sub-cube, prob determines chance that other sub-cubes survive
  maxCubes=1024;// limits number of sub-cubes
  divisions=2;// divisions per axis, recommended 2 or 3
  cubeThing=new cubeDividor(0,0,0,side,divisions,maxCubes,prob,noise);
  
  // make a copy of the virgin z-buffer state
  clearZ=new float[width*height];
  System.arraycopy(g.zbuffer,0,clearZ,0,clearZ.length);
}

void loop(){
  //do some stuff only once
  if (firstRun){
    background(255);// white background, hides the images used to build the color palette
    firstRun=false;
  }
  if(count<(screen.maxPanel+1)) screen.currentPanel=count;
  if(count==(screen.maxPanel+1)) screen.currentPanel=0;
  bufferedMouse.update(); // recalculate interpolated mouse position
  screen.clear();// clear current panel
  screen.center();// origin in center of current panel
  arcball.center_x=screen.centerX();// reposition arcball to center of active panel
  arcball.center_y=screen.centerY();// reposition arcball to center of active panel
  arcball.run();// rotate view
  cubeThing.draw();// draw cubeDividor
  cubeThing.update(); // divide and update cubeDividor
  count++;
}

void reset(){// new cubeDividor with random parameters
  int currentMode=cubeThing.mode;// remember drawing mode
  noise=random(0.15*side);// large range noise
  prob=random(10.0,100.0);// large range survival probability
  cubeThing=new cubeDividor(0,0,0,side,divisions,maxCubes,prob,noise);// start again...
  cubeThing.mode=currentMode;
}

//USER INPUT
//Mostly well-behaved, can give messy results when changing things too fast.
//Flags changing during screen update might give partially refreshed panels.

//Mouse input was a bit of a pain. Mouse click toggles cube division or initiates
//arcball rotation without changing cube division state. Fixed by moving actions from mousePressed()
//to mouseReleased() where user intentions are clear (drag or no drag)
//No need for a mind-reading module, please remove USB 2.0 from ear!

void mousePressed(){//
  // flag for cube division toggle, ignored if followed by mouseDragged();
  screen.mousePressed();
  arcball.mousePressed();
}

void mouseDragged()
{
  //Disable cube division while rotating, just an implementation choice, found rotation
  //a bit confusing with cubes suddenly popping in/out of existence.
  //flag for mouse drag
  screen.mouseDragged();
  arcball.mouseDragged();
}

void mouseReleased()
{
  //resolve all flags previously set
  //mouse drag flag=true -> restore previous division state, ignore division toggle
  //mouse drag flag=false -> toggle cube division
  screen.mouseReleased();
}

//Key input
//Some limited functions. No GUI controls are used, so keep mouse is free for panel selection
//and arcball rotation.
// 'p' -> cycle palette
// 'm' -> cycle drawing mode
// any other key -> new cube

void keyPressed(){
  switch(key){
    case 'p':// palette cycle
    currentPalette=(currentPalette+1)%3;
    cubeThing.changePalette();
    break;
    case 'P':// palette cycle
    currentPalette=(currentPalette+1)%3;
    cubeThing.changePalette();
    break;
    case 'm':// drawing mode cycle
    cubeThing.mode=(cubeThing.mode+1)%cubeThing.numModes;
    break;
    case 'M':// drawing mode cycle
    cubeThing.mode=(cubeThing.mode+1)%cubeThing.numModes;
    break;   
    default:// reset on any other key
    reset();
  }
}


//CLASSES

//Collection of cubes, originating from the successive division of initial cube
//Original cube is replaced with one random sub-cube, other sub-cubes are added depending on chance.
//Further divisions select random sub-cube from collection, etc.
//states: active=dividing, not active=static

class cubeDividor{
  int divisions, div3;// number of divisions per axis, sub-cubes per division
  int numCubes, count;// maximum and current number of cubes in collection
  cube[] cubes;//stores all sub-cubes - making cubeDividor a recursive object might be fun!
  float side;// size of initial cube
  float prob;// survival probability of sub-cube
  float noise;// position and size randomness of sub-cube
  boolean active;// toggle division
  int mode, numModes;// current drawing mode, number of implemented modes
 
  cubeDividor(float xx, float yy, float zz, float aa, int dd, int nc, float pp, float ns){
    numCubes=nc;
    count=1;
    prob=pp;
    noise=ns;
    side=aa;
    cubes=new cube[numCubes];
    cubes[0]=new cube(xx,yy,zz,aa);
    for(int i=1;i<numCubes;i++){
      cubes[i]=new cube(0,0,0,0);
    }
    divisions=dd;
    div3=dd*dd*dd;
    active=true;
    numModes=5;// number drawing modes
    mode=0;// current drawing mode
  }

  void update(){// select one cube in the collection, divide it, keep one or more determined by individual survival probability
    if ((active)&&(count<numCubes-div3+1)){// only update if room left in cubes[] array
      int select, replace;// random cube in collection, random sub-cube after division
  
      cube tmpCubes[]=new cube[div3];//  sub-cubes
      boolean tmpExists[]=new boolean[div3];// keep sub-cube or not?
      float tmpx, tmpy, tmpz, tmpa, stepa;
      select=(int) random(count-1);// select one cube
      tmpx=cubes[select].x;
      tmpy=cubes[select].y;
      tmpz=cubes[select].z;
      tmpa=cubes[select].a;
      stepa=2*cubes[select].a/divisions;
      
      //divide selected cube in equal cubes + apply noise to size and position
      for(int u=0;u<divisions;u++){
        for(int v=0;v<divisions;v++){
          for(int w=0;w<divisions;w++){
            tmpCubes[w+v*divisions+u*divisions*divisions]=new cube(tmpx-tmpa+(u+0.5)*stepa+random(-noise,noise),tmpy-tmpa+(v+0.5)*stepa+random(-noise,noise),tmpz-tmpa+(w+0.5)*stepa+random(-noise,noise),stepa/2.0+random(-noise,noise));
          }
        }
      }
      
      //keep sub-cubes depending on survival probability
      for(int i=0; i<div3; i++){
        tmpExists[i]=(random(100.0)<prob);
      }
      
      //always keep one sub-cube regardless of survival probability
      replace=(int) random(div3);
      cubes[select]=new cube(tmpCubes[replace].x,tmpCubes[replace].y,tmpCubes[replace].z,tmpCubes[replace].a);// replace 'father' cube with 'child' cube
      cubes[select].generation++;
      tmpExists[replace]=false;// to avoid double inclusions

      // add other sub-cubes if chance allows and large enough
      for(int i=0;i<div3;i++){
        if ((tmpExists[i])&&(tmpCubes[i].a>0.10)){
          cubes[count]=new cube(tmpCubes[i].x,tmpCubes[i].y,tmpCubes[i].z,tmpCubes[i].a);
          cubes[count].generation=cubes[select].generation+1;
          count++;
        }
      }    
    }
    /*String cubeTxt[]=new String[count];
    for (int i=0; i<count;i++){
      cubeTxt[i]="Box lengthsegs:1 widthsegs:1 heightsegs:1 length:" + cubes[i].a;
      cubeTxt[i]+=" width:" + cubes[i].a + " height:" + cubes[i].a;
      cubeTxt[i]+=" mapCoords:on pos:[" + cubes[i].x + ',' + cubes[i].y + ',' + cubes[i].z + ']';
    }
    saveStrings("cubes"+count+".txt",cubeTxt);*/
  }

  void draw(){//calls different drawing modes, implemented in the cube-class or here
    switch (mode){
      case 0:// normal cubes
      for(int i=0; i<count;i++){
        cubes[i].draw();
      }
      break;// noisy cubes
      case 1:
      for(int i=0; i<count;i++){
        cubes[i].drawSkew();
      }
      break;
      case 2:// half-sized cubeoctahedra
      for(int i=0; i<count;i++){
        cubes[i].drawTrunc();
      }
      break;
      case 3:// larger and smaller cubes dragged apart
      for(int i=0; i<count;i++){
        cubes[i].drawDistorted(side);
      }
      break;
      case 4:// mini-cubes and Bezier-curves, requires Zbuffer clear to draw properly
      
      for(int i=0; i<count;i++){
        cubes[i].drawDot(); 
      }
      drawLines();
      System.arraycopy(clearZ,0,g.zbuffer,0,clearZ.length);
      break;
    }
  }

  void drawLines(){
    beginShape(LINE_STRIP);
    for(int i=0; i<count-1;i++){
      stroke(cubes[i].c); 
      bezierVertex(cubes[i].x,cubes[i].y,cubes[i].z);
      bezierVertex(cubes[i+1].x,cubes[i+1].y,cubes[i+1].z);
    }
    endShape();
  }
  
  void changePalette(){
    for(int i=0; i<count-1;i++){
      cubes[i].c=pal[currentPalette].getColor();
    }
  }
}

class cube{// simple cubic box, random color from palette, different drawing methods
  float x,y,z,a;
  int generation;
  color c;
  float[][] randomOffset;// stored random values, needed for some drawing modes


  cube(float xx, float yy, float zz, float aa){
    x=xx;
    y=yy;
    z=zz;
    a=aa;
    generation=0;
    c=pal[currentPalette].getColor();
    randomOffset=new float[8][3];
    for(int i=0;i<8;i++){
      for(int j=0;j<3;j++){
        randomOffset[i][j]=random(-0.5*a,0.5*a);
      }
    }
  }

  void draw(){// plain boxes
    stroke(60,100);
    fill(c);
    push();
    translate(x,y,z);
    box(2*a);
    pop();
  }

  void drawSmall(){// half-sized boxes
    stroke(60,100);
    fill(c);
    push();
    translate(x,y,z);
    box(a);
    pop();
  }

  void drawDot(){// fixed tiny boxes
    stroke(60,100);
    fill(c);
    push();
    translate(x,y,z);
    box(2);
    pop();
  }

  void drawSkew(){//  noisy box
    stroke(60,100);
    fill(c);
    //4 sides
    beginShape(QUAD_STRIP);
    vertex(x+a+randomOffset[7][0],y+a+randomOffset[7][1],z+a+randomOffset[7][2]);
    vertex(x+a+randomOffset[6][0],y-a+randomOffset[6][1],z+a+randomOffset[6][2]);
    vertex(x-a+randomOffset[5][0],y-a+randomOffset[5][1],z+a+randomOffset[5][2]);
    vertex(x-a+randomOffset[4][0],y+a+randomOffset[4][1],z+a+randomOffset[4][2]);
    vertex(x-a+randomOffset[3][0],y+a+randomOffset[3][1],z-a+randomOffset[3][2]);
    vertex(x-a+randomOffset[2][0],y-a+randomOffset[2][1],z-a+randomOffset[2][2]);
    vertex(x+a+randomOffset[1][0],y-a+randomOffset[1][1],z-a+randomOffset[1][2]);
    vertex(x+a+randomOffset[0][0],y+a+randomOffset[0][1],z-a+randomOffset[0][2]);
    vertex(x+a+randomOffset[7][0],y+a+randomOffset[7][1],z+a+randomOffset[7][2]);
    vertex(x+a+randomOffset[6][0],y-a+randomOffset[6][1],z+a+randomOffset[6][2]);
    endShape();
    // 2 remaining sides
    beginShape(QUADS);
    vertex(x+a+randomOffset[7][0],y+a+randomOffset[7][1],z+a+randomOffset[7][2]);
    vertex(x+a+randomOffset[0][0],y+a+randomOffset[0][1],z-a+randomOffset[0][2]);
    vertex(x-a+randomOffset[3][0],y+a+randomOffset[3][1],z-a+randomOffset[3][2]);
    vertex(x-a+randomOffset[4][0],y+a+randomOffset[4][1],z+a+randomOffset[4][2]);
    vertex(x+a+randomOffset[6][0],y-a+randomOffset[6][1],z+a+randomOffset[6][2]);
    vertex(x+a+randomOffset[1][0],y-a+randomOffset[1][1],z-a+randomOffset[1][2]);
    vertex(x-a+randomOffset[2][0],y-a+randomOffset[2][1],z-a+randomOffset[2][2]);
    vertex(x-a+randomOffset[5][0],y-a+randomOffset[5][1],z+a+randomOffset[5][2]);
    endShape();

  }

  void drawTrunc(){// half-sized cube-octahedron (corners of cube sliced away)
    float a2=a/2.0;
    stroke(60,100);
    fill(c);
    //6 square sides
    beginShape(QUADS);
    vertex(x,y+a2,z+a2);
    vertex(x+a2,y,z+a2);
    vertex(x,y-a2,z+a2);
    vertex(x-a2,y,z+a2);
    vertex(x,y+a2,z-a2);
    vertex(x+a2,y,z-a2);
    vertex(x,y-a2,z-a2);
    vertex(x-a2,y,z-a2);
    vertex(x+a2,y,z+a2);
    vertex(x+a2,y+a2,z);
    vertex(x+a2,y,z-a2);
    vertex(x+a2,y-a2,z);
    vertex(x-a2,y,z+a2);
    vertex(x-a2,y+a2,z);
    vertex(x-a2,y,z-a2);
    vertex(x-a2,y-a2,z);
    vertex(x,y+a2,z+a2);
    vertex(x+a2,y+a2,z);
    vertex(x,y+a2,z-a2);
    vertex(x-a2,y+a2,z);
    vertex(x,y-a2,z+a2);
    vertex(x+a2,y-a2,z);
    vertex(x,y-a2,z-a2);
    vertex(x-a2,y-a2,z);
    endShape();
    //8 triangular sides
    noStroke();
    beginShape(TRIANGLES);
    vertex(x, y+a2,z+a2);
    vertex(x-a2,y,z+a2);
    vertex(x-a2,y+a2,z);
    vertex(x, y+a2,z+a2);
    vertex(x+a2,y,z+a2);
    vertex(x+a2,y+a2,z);
    vertex(x, y-a2,z+a2);
    vertex(x-a2,y,z+a2);
    vertex(x-a2,y-a2,z);
    vertex(x, y-a2,z+a2);
    vertex(x+a2,y,z+a2);
    vertex(x+a2,y-a2,z);
    vertex(x, y+a2,z-a2);
    vertex(x-a2,y,z-a2);
    vertex(x-a2,y+a2,z);
    vertex(x, y+a2,z-a2);
    vertex(x+a2,y,z-a2);
    vertex(x+a2,y+a2,z);
    vertex(x, y-a2,z-a2);
    vertex(x-a2,y,z-a2);
    vertex(x-a2,y-a2,z);
    vertex(x, y-a2,z-a2);
    vertex(x+a2,y,z-a2);
    vertex(x+a2,y-a2,z);
    endShape();
  }

  void drawChamfer(){// chamfered cube, edges sliced off
    float ch=4*a/5;
    stroke(60,100);
    fill(c);
    //6 sides
    beginShape(QUADS);
    vertex(x+ch,y+ch,z+a);
    vertex(x-ch,y+ch,z+a);
    vertex(x-ch,y-ch,z+a);
    vertex(x+ch,y-ch,z+a);
    vertex(x+ch,y+ch,z-a);
    vertex(x-ch,y+ch,z-a);
    vertex(x-ch,y-ch,z-a);
    vertex(x+ch,y-ch,z-a);
    vertex(x+a,y+ch,z+ch);
    vertex(x+a,y+ch,z-ch);
    vertex(x+a,y-ch,z-ch);
    vertex(x+a,y-ch,z+ch);
    vertex(x-a,y+ch,z+ch);
    vertex(x-a,y+ch,z-ch);
    vertex(x-a,y-ch,z-ch);
    vertex(x-a,y-ch,z+ch);
    vertex(x+ch,y+a,z+ch);
    vertex(x+ch,y+a,z-ch);
    vertex(x-ch,y+a,z-ch);
    vertex(x-ch,y+a,z+ch);
    vertex(x+ch,y-a,z+ch);
    vertex(x+ch,y-a,z-ch);
    vertex(x-ch,y-a,z-ch);
    vertex(x-ch,y-a,z+ch);
    endShape();
    //8 triangular corners
    beginShape(TRIANGLES);
    vertex(x-ch, y-ch,z+a);
    vertex(x-a,y-ch,z+ch);
    vertex(x-ch,y-a,z+ch);
    vertex(x+ch, y-ch,z+a);
    vertex(x+a,y-ch,z+ch);
    vertex(x+ch,y-a,z+ch);
    vertex(x-ch, y+ch,z+a);
    vertex(x-a,y+ch,z+ch);
    vertex(x-ch,y+a,z+ch);
    vertex(x+ch, y+ch,z+a);
    vertex(x+a,y+ch,z+ch);
    vertex(x+ch,y+a,z+ch);
    vertex(x-ch, y-ch,z-a);
    vertex(x-a,y-ch,z-ch);
    vertex(x-ch,y-a,z-ch);
    vertex(x+ch, y-ch,z-a);
    vertex(x+a,y-ch,z-ch);
    vertex(x+ch,y-a,z-ch);
    vertex(x-ch, y+ch,z-a);
    vertex(x-a,y+ch,z-ch);
    vertex(x-ch,y+a,z-ch);
    vertex(x+ch, y+ch,z-a);
    vertex(x+a,y+ch,z-ch);
    vertex(x+ch,y+a,z-ch);
    endShape();
    //12 chamfered edges
    noStroke();
    beginShape(QUADS);
    vertex(x-ch,y-ch,z+a);
    vertex(x-ch,y-a,z+ch);
    vertex(x+ch,y-a,z+ch);
    vertex(x+ch,y-ch,z+a);
    vertex(x-ch,y-ch,z-a);
    vertex(x-ch,y-a,z-ch);
    vertex(x+ch,y-a,z-ch);
    vertex(x+ch,y-ch,z-a);
    vertex(x-ch,y+ch,z+a);
    vertex(x-ch,y+a,z+ch);
    vertex(x+ch,y+a,z+ch);
    vertex(x+ch,y+ch,z+a);
    vertex(x-ch,y+ch,z-a);
    vertex(x-ch,y+a,z-ch);
    vertex(x+ch,y+a,z-ch);
    vertex(x+ch,y+ch,z-a);
    vertex(x-ch,y-ch,z+a);
    vertex(x-a,y-ch,z+ch);
    vertex(x-a,y+ch,z+ch);
    vertex(x-ch,y+ch,z+a);
    vertex(x-ch,y-ch,z-a);
    vertex(x-a,y-ch,z-ch);
    vertex(x-a,y+ch,z-ch);
    vertex(x-ch,y+ch,z-a);
    vertex(x+ch,y-ch,z+a);
    vertex(x+a,y-ch,z+ch);
    vertex(x+a,y+ch,z+ch);
    vertex(x+ch,y+ch,z+a);
    vertex(x+ch,y-ch,z-a);
    vertex(x+a,y-ch,z-ch);
    vertex(x+a,y+ch,z-ch);
    vertex(x+ch,y+ch,z-a);
    vertex(x-ch,y-a,z+ch);
    vertex(x-a,y-ch,z+ch);
    vertex(x-a,y-ch,z-ch);
    vertex(x-ch,y-a,z-ch);
    vertex(x+ch,y-a,z+ch);
    vertex(x+a,y-ch,z+ch);
    vertex(x+a,y-ch,z-ch);
    vertex(x+ch,y-a,z-ch);
    vertex(x-ch,y+a,z+ch);
    vertex(x-a,y+ch,z+ch);
    vertex(x-a,y+ch,z-ch);
    vertex(x-ch,y+a,z-ch);
    vertex(x+ch,y+a,z+ch);
    vertex(x+a,y+ch,z+ch);
    vertex(x+a,y+ch,z-ch);
    vertex(x+ch,y+a,z-ch);
    endShape();
  }

  void drawDistorted(float ss){// scale position of cubes depending on their size
    float factor=-1.0+2.0*sq(1.0-a/ss);// drags large and small cubes apart 
    stroke(60,100);
    fill(c);
    push();
    translate(constrain(x*factor,-ss,ss),constrain(y*factor,-ss,ss),constrain(z*factor,-ss,ss));// don't drag too far
    box(2*a);
    pop();
  }

}

class palette{//colors derived from image, alpha fixed, adapted from Jared Tarbell, http://www.complexification.net/
  int numpal, maxpal, alfa;
  color[] colors;
  String source;

  palette(int mp, int aa, String ss){
    numpal=0;
    maxpal=mp;
    alfa=aa;
    colors=new color[maxpal];
    source=ss;
    putColor(source);
  }

  color getColor() {// return random color from palette
    return colors[int(random(numpal))];
  }

  void putColor(String sourceName) {//check source image and retrieve unique colors
  //As a side effect of this procedure, the source images are briefly displayed. Only noticeable if the first frame takes a long time to render.
    BImage source;
    source = loadImage(sourceName);
    image(source,0,0);//temporarily display image
    for (int i=0;i<source.width;i++){
      for (int j=0;j<source.height;j++) {
        color c = get(i,j);//get color from pixel
        boolean exists = false;
        for (int n=0;n<numpal;n++) {//check if color is already included
          if (color(red(c),green(c),blue(c),alfa)==colors[n]) {
            exists = true;
            break;
          }
        }
        if (!exists) {// if new color add to palette
          if (numpal<maxpal) {
            colors[numpal] = color(red(c),green(c),blue(c),alfa);
            numpal++;
          } else {//check next pixel
            break;
          }
        }
      }
    }
  }
}

class panelledScreen{ //divide the applet in panels, update one panel while preserving the rest
  int rows, cols;
  int w, h, d;
  int currentPanel;
  int maxPanel;
  boolean viewChanged, panelChanged;

  panelledScreen( int rr, int cc, int ww, int hh, int dd){
    rows=rr;
    cols=cc;
    w=ww;
    h=hh;
    d=dd;
    currentPanel=0;
    maxPanel=rows*cols-1;
    viewChanged=false;
    panelChanged=false;
  }

  void center(){// center coordinates on current panel
    int midX=int(d+(w+d)*(currentPanel%cols)+w/2);
    int midY=int(d+(h+d)*(floor(currentPanel/cols)%rows)+h/2);
    translate(midX,midY);// relocate origin to center of panel.
  }

  int centerX(){// center of current panel
    return int(d+(w+d)*(currentPanel%cols)+w/2);
  }

  int centerY(){// center of current panel
    return int(d+(h+d)*(floor(currentPanel/cols)%rows)+h/2);
  }

  void clear(){// clear current panel by overwriting with a white opaque rectangle
    drawBorders();
    int leftX=int(d+(w+d)*(currentPanel%cols));
    int upperY=int(d+(h+d)*(floor(currentPanel/cols)%rows));
    noStroke();
    fill(80);
    ellipse(leftX-6,upperY-6,4,4);
    fill(255);
    rect(leftX,upperY,w,h);

  }

  void drawBorders(){// clear borders by overwriting with gray opaque rectangles
    noStroke();
    fill(240);
    for(int i=0;i<maxPanel+1;i++){
      int leftX=int(d+(w+d)*(i%cols));
      int upperY=int(d+(h+d)*(floor(i/cols)%rows));
      rect(leftX,upperY-d,-d,h+2*d);
      rect(leftX+w,upperY-d,d,h+2*d);
      rect(leftX,upperY,w,-d);
      rect(leftX,upperY+h,w,d);
    }
  }

  void mousePressed(){// select panel, if already activated: toggle cube division on mouse release
    int currentRow = int((float)(mouseY-d)/(h+d));
    int currentCol = int((float)(mouseX-d)/(w+d));
    if (currentPanel!= currentRow*cols+currentCol)
    {
      panelChanged=true;
      currentPanel= currentRow*cols+currentCol;
      System.arraycopy(clearZ,0,g.zbuffer,0,clearZ.length);// clears the Zbuffer to get rid of line-drawing artefacts
    }
  }

  void mouseDragged(){// turn division off while rotating
    viewChanged=true;
  }

  void mouseReleased(){// remember state after dragging
    if (panelChanged){
      panelChanged=false;
      viewChanged=false;
      cubeThing.active=true;
    }
    else if(viewChanged){
      viewChanged=false;
    }
    else{
      cubeThing.active=!cubeThing.active;
    }
  }

}



class BufferedMouse{
  float stiffness;
  float currentX, currentY;

  BufferedMouse(float ss){
    
    stiffness=constrain(ss,0.0,1.0);
    currentX=mouseX;
    currentY=mouseY;
  }

  void update(){
    currentX=currentX*stiffness+(1.0-stiffness)*mouseX;
    currentY=currentY*stiffness+(1.0-stiffness)*mouseY;
  }

  void clear(){
    currentX=mouseX;
    currentY=mouseY;
  }

}


// Arcball, related classes and functions by arielm - June 23, 2003
// http://www.chronotext.org

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
    v_down = mouse_to_sphere(bufferedMouse.currentX, bufferedMouse.currentY);
    q_down.set(q_now);
    q_drag.reset();
  }

  void mouseDragged()
  {
    v_drag = mouse_to_sphere(bufferedMouse.currentX, bufferedMouse.currentY);
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

  void add(Vec3 v1, Vec3 v2)
  {
    x = v1.x + v2.x;
    y = v1.y + v2.y;
    z = v1.z + v2.z;
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


