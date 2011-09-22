// base26 - spacial visualization of 4-letter words
// (c) 2004 karsten schmidt / info-at-toxi.co.uk
//
// this source is heavily commented for educational purposes and
// released under the creative commons license (http://creativecommons.org/licenses/by-nc-sa/1.0/)
//
// thanks to:
//   ben & casey for inspiration,
//   glen murphy and seb cheverel for the fasttext + blur routines

Vocabulary          vocab;
VoxelSpace          surface;
GUI                 gui;
GUIElement[]        bt_filters;
FastText            ft_default,ft_caps;
Node                rollOverNode;

// background image
BImage      bg;

// interface states
// used to only execute parts of the main loop and if updates are needed
boolean     updateView=true;
boolean     updateVolume=true;
boolean     updateRotation=false;
boolean     autoRotate=true;
boolean     helpRequested=false;
boolean     helpActive=false;

float       stepSize=1;          // resolution used for rendering surface hull
float       isoValue=25;         // threshold value used for surface hull
float       isoExponent=1.25;    // user adjustable iso value offset
float       minPotential=150;    // minimum/standard potentials of a node/voxel
float       basePotential=200; 
float       xRot=2.88;           // current X rotation
float       yRot=-0.64;          // current Y rotation
float       currXRot,currYRot;   // temp X,Y rotation
float       autoAlpha=0;         // angle used for auto-rotation
float       autoRotR=0.1;        // impact of auto-rotation (in radians)
float       centerX=240;         // projection center point
float       centerY=396;
float       clickX,clickY;       // mouse click position
int         typeMask=0x0f;       // word types filter mask
float       snapDistance=10;     // node select radius in pixels (for rollover)
String[]    usage;               // cache for usage/help text

void setup() {
  size(500,600);
  rectMode(CORNERS);
  // load background image
  bg=loadImage("bg.jpg");
  // setup user interface elements
  GUIElement[] uiItems= new GUIElement[13];
  // letter display
  uiItems[0]= new ImagePanel("initial",loadImage("alphabet2.gif"),220,0,60,60,0xd8,ADD);
  // icon buttons
  BImage icon=loadImage("icons.gif");
  uiItems[1]= new IconButton("help",icon,0,16,16,20,22,SUBSTRACT,ADD);
  uiItems[2]= new IconButton("autoR",icon,1,16,16,40,22,SUBSTRACT,ADD);
  uiItems[3]= new IconButton("resMinus",icon,2,16,16,440,22,SUBSTRACT,ADD);
  uiItems[4]= new IconButton("resPlus",icon,3,16,16,460,22,SUBSTRACT,ADD);
  uiItems[5]= new IconButton("isoMinus",icon,2,16,16,380,22,SUBSTRACT,ADD);
  uiItems[6]= new IconButton("isoPlus",icon,3,16,16,400,22,SUBSTRACT,ADD);
  // stepper buttons
  uiItems[7]= new IncrementorButton("nextIni",1,0,25,300,20,310,40);
  uiItems[8]= new IncrementorButton("prevIni",-1,0,25,190,20,200,40);
  // filter type toggles
  bt_filters= new BitToggleButton[4];
  bt_filters[0] = uiItems[9]= new BitToggleButton("filter0",typeMask,0,228,570,8,8);
  bt_filters[1] = uiItems[10]= new BitToggleButton("filter1",typeMask,1,240,570,8,8);
  bt_filters[2] = uiItems[11]= new BitToggleButton("filter2",typeMask,2,252,570,8,8);
  bt_filters[3] = uiItems[12]= new BitToggleButton("filter3",typeMask,3,264,570,8,8);
  // setup GUI with elements
  gui=new GUI(uiItems);
  // load fonts
  ft_default=new FastText("fffharmony.gif");
  ft_caps=new FastText("fffleader_caps2.gif");
  // initialize data set
  vocab=new Vocabulary("4letters.txt");
  // setup 3d volume renderer
  surface=new VoxelSpace(26,26,26,24,24,24,17000);
}

void loop() {
  // don't do anything in 1st frame (causes flickering for some reason)
  if (!firstFrame) {
    // check if user needs help...
    if (helpRequested) {
      // if helpscreen not shown yet, do so or just return
      if (!helpActive) showHelp();
      return;
    }
    // update rotation only while mouse is pressed
    if (updateRotation) {
      xRot=min(max(xRot+(clickY-mouseY)*0.0007,2.2),3.5);
      yRot+=(clickX-mouseX)*0.0007;
      // force update
      updateView=true;
    }
    currXRot=xRot;
    currYRot=yRot;
    // add auto rotation offset if needed
    if (autoRotate) {
      currXRot+=autoRotR*sin(autoAlpha);
      currYRot+=autoRotR*cos(autoAlpha);
      autoAlpha+=(rollOverNode!=null ? 0 : 0.02);
      updateView=true;
    }
    // find out if surface hull needs updating
    updateVolume=(updateVolume || updateIsoValue());
    // only redraw
    if (updateVolume || updateView) {
      background(bg);
      push();
      translate(centerX,centerY,0);
      rotateX(currXRot);
      rotateY(currYRot);
      scale(11);
      // clear rollover state
      rollOverNode=null;
      // filter and show words
      showNodes(vocab.currInitial);
      // show base grid
      drawGrid();
      // update surface hull if needed
      if (updateVolume) {
        surface.update(stepSize,isoValue);
        updateVolume=false;
      }
      // ...or just render cached vertices
      else surface.render();
      // revert to normal 2d view
      pop();
      // show rollover description for node
      if (rollOverNode!=null) {
        rollOverNode.showLabel();
      }
      // update currently selected letter display
      ((ImagePanel)gui.getElementForID("initial")).setOffsetX((int)(vocab.currInitial*60));
      // show interface elements
      gui.draw();
      updateView=false;
    }
  }
}

/********************************************************************
  main event handlers
********************************************************************/

void mouseMoved() {
  // check GUI elements for rollover
  gui.checkElements(false);
  // force redraw
  updateView=true;
}

void mousePressed() {
  // start updating rotation if mouse is not over a word node
  if (rollOverNode==null) {
    clickX=(float)mouseX;
    clickY=(float)mouseY;
    updateRotation=true;
  }
}

void mouseReleased() {
  // turn off help screen (if active)
  if (helpRequested) {
    helpRequested=false;
    updateView=true;
  }
  // if a word is selected, open dictionary.com for it
  if (rollOverNode!=null) {
    link("http://dictionary.reference.com/search?q="+rollOverNode.desc.value, "_new");
  } else {
    // or check if user clicked on a GUI element
    gui.checkElements(true);
  }
  helpActive=false;
  updateRotation=false;
}

void keyReleased() {
  // ignore modifier key events
  if (key==SHIFT || key==CONTROL || key==ALT) return;
  // if not active yet, show help screen
  if ((key=='?' || key=='/') && !helpActive) {
    helpRequested=true;
    helpActive=false;
    return;
  }
  // for all other cases turn off help
  helpRequested=helpActive=false;
  // switch to new initial in data set
  if ((key>='a' && key<='z') || (key>='A' && key<='Z')) {
    vocab.setInitial((float)((key|0x20)-'a'));
    updateVolume=true;
    // update word type filter
  } else if (key>='1' && key<='8') {
    typeMask=(int)key-'0';
    // update filter buttons
    for(int i=0; i<4; i++) ((BitToggleButton)bt_filters[i]).set(((typeMask&(1<<i))>0));
    updateView=updateVolume=true;
    // clear filter mask to show all types
  } else if (key=='9' || key=='0') {
    typeMask=0x0f;
    // update filter buttons
    for(int i=0; i<4; i++) ((BitToggleButton)bt_filters[i]).set(true);
    updateView=updateVolume=true;
    // switch to previous letter
  } else if (key==',' || key=='<' || key==LEFT) {
    vocab.setInitial(max(--vocab.newInitial,0));
    // switch to next letter
  } else if (key=='.' || key=='>' || key==RIGHT) {
    vocab.setInitial(min(++vocab.newInitial,25));
    // increase resolution of surface hull
  } else if (key=='=' || key=='+') {
    adjustSurfaceResolution(-0.15);
    // decreas resolution
  } else if (key=='-' || key=='_') {
    adjustSurfaceResolution(0.15);
    // toggle auto rotation
  } else if (key=='[') {
    adjustIsoOffset(-0.05);
  } else if (key==']') {
    adjustIsoOffset(0.05);
  } else if (key==' ') {
    toggleAutoRotate();
  }
}

// this method is called from the GUI class if user clicked on an interface element
// does same things like in keyReleased() above only triggered via GUI
void handleGUIElement(GUIElement e) {
  // switch letter initial?
  if (e.id=="prevIni") {
    // need to cast the GUIElement into its real class type
    vocab.setInitial(((IncrementorButton)e).apply(vocab.newInitial));
  } else if(e.id=="nextIni") {
    vocab.setInitial(((IncrementorButton)e).apply(vocab.newInitial));
  // help button
  } else if(e.id=="help") {
    if (helpActive) {
      helpRequested=helpActive=false;
    } else {
      helpRequested=true;
      helpActive=false;
    }
  // auto rotate
  } else if(e.id=="autoR") {
    toggleAutoRotate();
  // surface resolution/threshold
  } else if(e.id=="resMinus") {
    adjustSurfaceResolution(0.15);
  } else if(e.id=="resPlus") {
    adjustSurfaceResolution(-0.15);
  } else if(e.id=="isoMinus") {
    adjustIsoOffset(-0.05);
  } else if(e.id=="isoPlus") {
    adjustIsoOffset(0.05);
  // word type filter buttons 
  } else if(e.id.indexOf("filter")!=-1) {
    // need to cast the GUIElement into its real class type
    typeMask=((BitToggleButton)e).toggle(typeMask);
    updateView=updateVolume=true;
  }
}

/********************************************************************
  utility functions, 2nd grade event callbacks and rendering modules
  called from the main loop() method
********************************************************************/

// change and limit step size used for rendering the surface hull
// default is 1 unit, which might be to intense for slower machines
// called from keyReleased() or handleGUIElement() methods
void adjustSurfaceResolution(float v) {
  stepSize=max(min(stepSize+v,2),0.6);
  updateView=updateVolume=true;
}

// set the new offset value used for computing the threshold value
// of the surface hull, see VoxelSpace class for more info
void adjustIsoOffset(float v) {
  isoExponent=max(min(isoExponent+v,1.5),0.75);
  updateView=updateVolume=true;
}

// turn on/off auto rotation
// auto rotation helps eyes to comprehend the 3d wireframe, but
// might slow down experience on slower machines
void toggleAutoRotate(){
  autoRotate=!autoRotate;
  // avoid sudden jump in rotation settings when toggling auto-rotation
  if (!autoRotate) {
    xRot=currXRot;
    yRot=currYRot;
  } else {
    xRot-=autoRotR*sin(autoAlpha);
    yRot-=autoRotR*cos(autoAlpha);
  }
}

// show help screen
void showHelp() {
  // blur current pixel buffer
  blur(3);
  // clear z-buffer to avoid 2d vs 3d fighting
  for(int i=0; i<pixels.length; i++) g.zbuffer[i]=MAX_FLOAT;
  // construct help window
  fill(255,192);
  noStroke();
  int yy=160;
  rect(0,yy,width,yy+260);
  // load help text if not done yet
  if (usage==null) usage=loadStrings("usage.txt");
  yy+=20;
  ft_default.setColor(0);
  // 1st line in bold
  ft_default.write(g,usage[0],50,yy,true);
  ft_default.write(g,usage[0],51,yy,true);
  yy+=30;
  for(int i=1; i<usage.length; i++) {
    ft_default.write(g,usage[i],50,yy,true);
    yy+=20;
  }
  rollOverNode=null;
  helpActive=true;
}

// FULL RGB DIFFUSION FILTER
// based on code by SEB // www.seb.cc
// sorry, had to optimize a bit ;)

void blur(int tt) {
  for(int ttt = 0; ttt <= tt; ttt++){
    int R,G,B,left,right,top,bottom;
    int c,cl,cr,ct,cb;
    int w1=width-1;
    int h1=height-1;
    int index=0;
    for(int y=0;y<height; y++) {
      top=(y>0) ? -width : h1*width;
      bottom=(y==h1) ? -h1*width : width;
      for(int x=0; x<width; x++) {
        // Wraparound offsets
        left=(x>0) ? -1 : w1;
        right=(x<w1) ? 1 : -w1;
        
        c=pixels[index];
        cl=pixels[left+index];
        cr=pixels[right+index];
        ct=pixels[top+index];
        cb=pixels[bottom+index];
        
        // Calculate the sum of all neighbors
        R=((cl>>16 & 255) + (cr>>16 & 255) + (c>>16 & 255) + (ct>>16 & 255) + (cb>>16 & 255)) / 5;
        G=((cl>>8 & 255) + (cr>>8 & 255) + (c>>8 & 255) + (ct>>8 & 255) + (cb>>8 & 255)) / 5;
        B=((cl & 255) + (cr & 255) + (c & 255) + (ct & 255) + (cb & 255)) / 5;
        pixels[index++]=(R<<16)+(G<<8)+B;
      }
    }
  }
}

// interpolate the surface hull's boundary value
// based on the currently displayed number of nodes and their total potential
// is also linked to interpolation of Vocabulary's current letter initial value

boolean updateIsoValue() {
  float isoV=sqrt(surface.totalP)+pow(surface.numNodes,isoExponent);
  if (isoValue!=isoV || abs(vocab.newInitial-vocab.currInitial)>0.01) {
    vocab.currInitial+=(vocab.newInitial-vocab.currInitial)*vocab.iniSpeed;
    if (abs(isoV-isoValue)>0.49) {
      isoValue+=(isoV-isoValue)*0.45;
      return true;
    } else {
      vocab.currInitial=vocab.newInitial;
      isoValue=isoV;
      return true;
    }
  }
  return false;
}

// draw ground grid and a-z labels
void drawGrid() {
  // first draw lines by iterating along Z axis
  ft_default.setColor(0x777777);
  ft_caps.setColor(0x777777);
  int c=(int)'a'-32;
  int xx,zz;
  for(int z=-13; z<13; z++) {
    xx=-14;
    stroke(0,20);
    if (rollOverNode!=null) {
      // if a node is selected/mouse over, draw letter in capitals
      if (rollOverNode.desc.value.charAt(2)-32==c) {
        xx-=2;
        ft_caps.putchar(g,c-65,(int)screenX(xx,1,z),(int)screenY(xx,1,z),false);
        stroke(0,80);
      } else ft_default.putchar(g,c,(int)screenX(xx,1,z),(int)screenY(xx,1,z),false);
    } else ft_default.putchar(g,c,(int)screenX(xx,1,z),(int)screenY(xx,1,z),false);
    c++;
    beginShape(LINES);
    vertex(xx+1,0,z);
    vertex(12,0,z);
    endShape();
  }
  // draw lines by iterating along X axis
  ft_default.setColor(0x444444);
  ft_caps.setColor(0x444444);
  c=(int)'a'-32;
  for(int x=-13; x<13; x++) {
    zz=-14;
    stroke(0,20);
    if (rollOverNode!=null) {
      if (rollOverNode.desc.value.charAt(1)-32==c) {
        zz-=2;
        ft_caps.putchar(g,c-65,(int)screenX(x,1,zz),(int)screenY(x,1,zz),false);
        stroke(0,80);
      } else ft_default.putchar(g,c,(int)screenX(x,1,zz),(int)screenY(x,1,zz),false);
    } else ft_default.putchar(g,c,(int)screenX(x,1,zz),(int)screenY(x,1,zz),false);
    c++;
    beginShape(LINES);
    vertex(x,0,zz+1);
    vertex(x,0,12);
    endShape();
  }
}

// here we update, filter and render all nodes for the current initial
// as the initial of a word is considered a position in "time". as we want time
// to feel continuous and not to be discrete, the initial here is a fractional number.
// there're always one or two sets of initials visible, the frational part of defines
// the visual impact of the 2 sets. eg. an initial value of 4.6 will display words starting with "e"
// and words starting with "f". the e-words will have 40% impact and f-words will have 60%
 
void showNodes(float id) {
  // get floored integer of selected initial
  int id1=(int)id;
  // get the index of the following initial
  int id2=(int)(id1+1)%26;
  // get the fractional part only, eg. frac of 4.23=0.23
  float frac=id-id1;
  // and its reversed value 1-frac, as impact factor for 1st set
  float ifrac=1-frac;
  // make node size based on inverted fractional part
  float s=ifrac*0.33;
  float p;
  Node[] nodes=vocab.items[id1];
  // this array will hold only nodes which will get through the word type filter
  // and is then used for updating the surface hull
  // disable nodes if their impact is less than 10%
  Node[] volumeNodes=new Node[(ifrac>0.1 ? vocab.itemCounts[id1] : 0) + (frac>0.1 ? vocab.itemCounts[id2] : 0)];
  int vNIndex=0;
  // stores the sum potential of all nodes used
  float totalP=0;
  // skip, if selected less than 10%
  if (ifrac>0.1) {
    for(int i=0; i<vocab.itemCounts[id1]; i++) {
      // check if node matches current filter type
      if ((nodes[i].desc.type&typeMask)>0) {
        // compute current node potential
        p=ifrac*nodes[i].maxP;
        nodes[i].potential=p;
        nodes[i].show(s);
        // add node to list
        volumeNodes[vNIndex++]=nodes[i];
        totalP+=p;
      }
    }
  }
  // do the same for next initial
  if (frac>0.1) {
    s=frac*0.33;
    nodes=vocab.items[id2];
    for(int i=0; i<vocab.itemCounts[id2]; i++) {
      if ((nodes[i].desc.type&typeMask)>0) {
        p=frac*nodes[i].maxP;
        nodes[i].potential=p;
        nodes[i].show(s);
        volumeNodes[vNIndex++]=nodes[i];
        totalP+=p;
      }
    }
  }
  surface.setNodes(volumeNodes,vNIndex,totalP);
  // show number of nodes
  ft_default.setColor(0xffffff);
  ft_default.write(g,"words: "+nf(surface.numNodes,3),223,70,true);
}

/********************************************************************
subclass definitions below

Node class is used to define a voxel and its description
nodes are created when parsing the word list in the Vocabulary class below

*********************************************************************/

class Node {
  // 3d position
  float x,y,z;
  // strength of node used for computing surface hull
  float potential,maxP;
  // transformed screen position
  int scrX,scrY;
  // flag, if mouse is over node
  boolean isMouseOver;
  // description container
  Descriptor desc;
  
  Node(float xx,float yy,float zz, String d) {
    x=xx; y=yy; z=zz;
    potential=0;
    desc=new Descriptor(d);
  }
  // show node, parameter s = display size
  void show(float s) {
    push();
    translate(x-13,y,z-13);
    scrX=(int)screenX(0,0,0);
    scrY=(int)screenY(0,0,0);
    isMouseOver=((abs(mouseX-scrX)+abs(mouseY-scrY))<snapDistance);
    if (isMouseOver) {
      // if rolled over more than one node, only select if nearer to camera
      if (rollOverNode!=null) {
        isMouseOver=(screenZ(x,y,z)<screenZ(rollOverNode.x,rollOverNode.y,rollOverNode.z));
      }
      if (isMouseOver) {
        stroke(0);
        beginShape(LINES);
        vertex(0,0,0);vertex(0,-y,0);
        endShape();
        beginShape(LINE_STRIP);
        vertex(-0.25,-y,-0.25);
        vertex(0.25,-y,-0.25);
        vertex(0.25,-y,0.25);
        vertex(-0.25,-y,0.25);
        vertex(-0.25,-y,-0.25);
        endShape();
        noStroke();
        fill(0);
        // double in size when selected
        s*=2;
        rollOverNode=this;
      }
    }
    // use colour based on word type
    if (!isMouseOver) {
      int c=NodeTypes.palette[desc.type];
      fill(c>>16,c>>8&0xff,c&0xff);
    }
    box(s);
    pop();
  }
  
  // draw rollover label/info for selected node
  void showLabel() {
    noStroke();
    fill(255);
    rect(scrX,scrY-16,width,scrY);
    rect(0,scrY,width,scrY+1);
    rect(0,scrY,16,scrY+16);
    ft_default.setColor(0);
    // word in bold
    ft_default.write(g,desc.label,scrX+10,scrY-12,true);
    ft_default.write(g,desc.label,scrX+11,scrY-12,true);
    ft_default.write(g,"> "+NodeTypes.labels[desc.type],scrX+45,scrY-12,true);
    ft_default.putchar(g,(int)desc.value.charAt(3)-0x40,4,scrY+3,true);
  }
}

// Node descriptor classes
// used to parse and colour code word types

final static class NodeTypes {
  // node types use a binary code as ID
  // 1 = adjective/adverb
  // 2 = noun
  // 4 = verb
  // 8 = misc/other
  // the type value of a node is used as index for the
  // following lookup tables for colour and labeling
  static int[]  palette={
    0,
    0xff0044, // adj
    0xffff00, // noun
    0xff9900, // adj+noun
    0x00ffff, // verb
    0xff66ff, // a+v
    0x77ff00, // n+v
    0xffffff, // a+n+v
    0x336666  // misc
  };
  static String[] labels={
    "",
    "adjective / adverb",
    "noun",
    "adjective + noun",
    "verb",
    "adjective + verb",
    "noun + verb",
    "adj. + noun + verb",
    "other"
  };
}

// data container and parser
// the engine supports "politically correct" versions of a word
// the class constructor splits a line from the word list file
// and extracts the actual word, display version and type
// have a look at the file 4letters.txt to see the format used

class Descriptor {
  String label;
  String value;
  int    type;
  
  Descriptor(String l) {
    String[] parts=splitStrings(l,',');
    if (parts.length>1) {
      value=parts[0];
      if (parts[1].charAt(0)>='a') {
        label=parts[1];
        if (parts.length>2) type=Integer.parseInt(parts[2]);
      } else {
        label=value;
        type=Integer.parseInt(parts[1]);
      }
    } else {
      label=value=parts[0];
    }
  }
}

// main data set class
// responsible for parsing and storing the wordlist

class Vocabulary {
  // all words are stored in this 2d array:
  // 1st index = word initials
  // 2nd index = all words for that initial
  Node[][] items;
  // store number of words for each initial
  int[] itemCounts;
  // currently select initial 0=a, 1=b... 25=z
  // as in the context of the visualisation the 1st letter of each word is considered
  // the 4th dimension (or time) a float value is used to smoothly interpolate between datasets
  // when switching initials
  float currInitial=0.1;
  // interpolation speed when switching initials
  float iniSpeed=0.5;
  // index of letter to interpolate to
  float newInitial=0;
  
  Vocabulary(String fileName) {
    // load wordlist
    String[] words=loadStrings(fileName);
    items=new Node[26][];
    itemCounts=new int[26];
    int c=0;
    int index=0;
    char currID=0;
    // parse and index word list
    // the hashtable stores all combinations of the last 3 letters in a word
    // which in this context represent points in 3d space
    // after parsing all words this table will contain something like a histogram/spectrum
    // of the frequency of each point's occurance.
    // these values are then used as field strength for each node and as such define the general shape
    // of the surface hull around the nodes
    Hashtable uniquePoints=new Hashtable(words.length/2);
    for(int i=0; i<words.length; i++) {
      // create a sub array for each initial
      // all words starting with "a" are in items[0], "b" items[1] etc.
      if(words[i].charAt(0)!=currID) {
        currID=words[i].charAt(0);
        c=(int)(currID-'a');
        items[c]=new Node[200];
        itemCounts[c]=0;
        index=0;
      }
      // check if point already exists
      String checkPoint=words[i].substring(1,4);
      if (!uniquePoints.containsKey(checkPoint)) {
        // create new entry, if new point
        uniquePoints.put(checkPoint,new Integer(1));
      } else {
        // or increase count for that point
        int v=((Integer)uniquePoints.get(checkPoint)).intValue()+1;
        uniquePoints.remove(checkPoint);
        uniquePoints.put(checkPoint,new Integer(v));
      }
      // add new node to array
      // the 2nd, 3rd and 4th letter are interpreted as XYZ coordinates
      items[c][index++]=new Node(normalizeChar(words[i].charAt(1)),normalizeChar(words[i].charAt(3)),normalizeChar(words[i].charAt(2)),words[i]);
      itemCounts[c]++;
    }
    println("total words: "+words.length);
    println("unique points: "+uniquePoints.size());
    // set max potential of each node based on its number of occurence, see hashtable above
    for(int i=0; i<26; i++) {
      for(int j=0; j<itemCounts[i]; j++) {
        items[i][j].maxP=minPotential+basePotential*((Integer)uniquePoints.get(items[i][j].desc.value.substring(1,4))).intValue();
      }
    }
  }
  
  // turn letters into numbers, 0 based so that a=0, b=1 etc.
  float normalizeChar(char c) {
    return (float)(c-'a');
  }
  
  // set new initial to interpolate too
  void setInitial(float i) {
    // adjust interpolation speed to actual distance
    // between current and new letters
    iniSpeed=max(1/(abs(i-currInitial)+1),0.2);
    newInitial=i;
    isoValue-=0.5;
  }
}

// VoxelSpace is responsible for rendering the surface hull
// basically, it's a marching squares implementation on either the
// XZ or YZ plane, which combined creates a 3d wireframe mesh of the
// iso surface around the nodes

class VoxelSpace {
  // space dimensions
  int w, h, d;
  // half width,height,depth
  int w2, h2, d2;
  // number of discrete steps along each axis
  int gridX, gridY, gridZ;
  // scale factor
  float xscale, yscale, zscale;
  // number of nodes used
  int numNodes;
  // current total power/potential of all nodes
  float totalP;
  
  // vertice cache
  float[] cacheX,cacheY,cacheZ;
  
  // current list of nodes/voxels in the space
  Node[] nodes;
  
  // internally used lookup tables by the marching square algorithm
  // see comments in renderSlice() method for more detail
  float[][] _sliceData;
  boolean[][] _edgeFlags;
  
  int[][] _edges = {{0, 1}, {1, 2}, {2, 3}, {3, 0}};
  int[][] _offsets = {{0, 0}, {1, 0}, {1, 1}, {0, 1}};
  int[][] _lines = {
    {-1, -1, -1, -1, -1},
    {0, 3, -1, -1, -1},
    {0, 1, -1, -1, -1},
    {3, 1, -1, -1, -1},
    {1, 2, -1, -1, -1},
    {1, 2, 0, 3, -1},
    {0, 2, -1, -1, -1},
    {3, 2, -1, -1, -1},
    {3, 2, -1, -1, -1},
    {0, 2, -1, -1, -1},
    {3, 2, 0, 2, -1},
    {1, 2, -1, -1, -1},
    {3, 1, -1, -1, -1},
    {0, 1, -1, -1, -1},
    {0, 3, -1, -1, -1},
    {-1, -1, -1, -1, -1}
  };
  
  // vertex counter
  int vCount;
  
  VoxelSpace(int ww, int hh, int dd, int xs, int ys, int zs, int cacheSize) {
    w = ww;
    h = hh;
    d = dd;
    w2 = (w >> 1);
    d2 = (d >> 1);
    xscale = (float)w/xs;
    yscale = (float)h/ys;
    zscale = (float)d/zs;
    gridX = xs+1;
    gridY = ys+1;
    gridZ = zs+1;
    _sliceData = new float[gridX][gridY];
    _edgeFlags = new boolean[gridX][gridY];
    // cache arrays for vertex list
    cacheX=new float[cacheSize];
    cacheY=new float[cacheSize];
    cacheZ=new float[cacheSize];
  }
  
  // updates node list, called from showNodes() above
  void setNodes(Node[] n, int num, float p) {
    nodes = n;
    numNodes=num;
    totalP=p;
  }
  
  // compute new surface hull
  // s=step size
  // isoV = threshold value to be used for finding surface
  void update(float s,float isoV) {
    vCount=0;
    for(float i=0; i<=d; i+=s) {
      renderSlice(true,i,isoV);
      renderSlice(false,i,isoV);
    }
    nodes=null;
  }
  
  // render current contents of vertex cache
  void render() {
    beginShape(LINES);
    for(int i=0; i<vCount; i++) {
      stroke(0,16+cacheY[i]*2);
      vertex(cacheX[i],cacheY[i],cacheZ[i]);
    }
    endShape();
  }
  
  // marching square implementation based on code/descriptions by paul bourke
  void renderSlice(boolean zSlice,float currSlice, float isoV) {
    float sum,dx,dy,dz,distsq,currX,currY,currZ;
    // decide if XY or ZY plane
    // only difference between the 2 cases is that
    // we either iterate along the X or Z axis
    // the algorithm starts computing the strength of all nodes at all
    // grid points on the selected slice/plane
    // each result is stored in the 2d _sliceData array for the next part
    // the result values can also be understood as field strength 
    if (zSlice) {
      currX = 0;
      for (int x = 0; x < gridX; x++) {
        currY = 0;
        for (int y = 0; y < gridY; y++) {
          // reset all edges to unused
          _edgeFlags[x][y] = false;
          sum = 0;
          // iterate through all nodes and sum up their potential
          // based on their distance to the current grid point
          // the further away a node, the less impact it has on that point
          for(int i=0; i<numNodes; i++){
            dx = currX - nodes[i].x;
            dy = currY - nodes[i].y;
            dz = currSlice - nodes[i].z;
            // simplified pythagorean, only uses squared distance to avoid sqrt()
            // 0.0001 offset to avoid division by 0
            sum += nodes[i].potential/((dx*dx+dy*dy+dz*dz)+0.0001);
          }
          _sliceData[x][y] = sum;
          // step along Y axis
          currY += yscale;
        }
        // step along X
        currX += xscale;
      }
      currSlice-=d2;
    } else {
      currZ = 0;
      // same steps as above, only in ZY plane
      for (int z = 0; z < gridZ; z++) {
        currY = 0;
        for (int y = 0; y < gridY; y++) {
          _edgeFlags[z][y] = false;
          sum = 0;
          for(int i=0; i<numNodes; i++){
            dx = currSlice - nodes[i].x;
            dy = currY - nodes[i].y;
            dz = currZ - nodes[i].z;
            sum += nodes[i].potential/((dx*dx+dy*dy+dz*dz)+0.0001);
          }
          _sliceData[z][y] = sum;
          currY += yscale;
        }
        currZ += zscale;
      }
      currSlice-=w2;
    }
    
    // those values are described below
    int[] startP;
    int[] endP;
    int startOffsetX;
    int startOffsetY;
    int endOffsetX;
    int endOffsetY;
    int corners;
    int[] currEdges;
    int yy,n;
    float v1;
    float dV;
    float lerpF;
    float vx1,vy1,vx2,vy2;
    
    // main slice rendering pass
    // re-process values in _sliceData array and determine if
    // the field strength at each point is less than the given
    // threshold value. we have found an intersection with the 
    // boundary surface, if the current point's value is below,
    // but one of it's neighbour is >= threshold value
    beginShape(LINES);
    int gX1=(zSlice ? gridX-1 : gridZ-1);
    int gY1=gridY-1;
    for (int y = 0; y < gY1; y++) {
      yy=y+1;
      for (int x = 0,xx=1; x < gX1; x++) {
        // check if this edge hasn't already been processed
        if (!_edgeFlags[x][y]) {
          corners = 0;
          // compare all 4 corners of the current grid square/cell with
          // the iso threshold value and set respective codes
          // 1=bottom left
          // 2=bottom right
          // 4=top right
          // 8=top left
          if (_sliceData[x][y] < isoV) {
            corners |= 1;
          }
          if (_sliceData[xx][y] < isoV) {
            corners |= 2;
          }
          if (_sliceData[xx][yy] < isoV) {
            corners |= 4;
          }
          if (_sliceData[x][yy] < isoV) {
            corners |= 8;
          }
          
          // if the result of corners=0 the entire square is within the surface area
          // if it is 1+2+4+8=15 the square is totally outside
          // in both cases no further steps are needed and we can skip that next part
          
          if (corners > 0 && corners < 0x0f) {
            n = 0;
            // here the algorithm makes heavy use of the lookup tables (defined above)
            // to compute the exact position of the surface line(s) in the current cell and at same
            // time take care of all possible symmetries.
            // note that there're 2 special cases where there will be 2 lines crossing the cell
            // this only happens when diagonally opposite points are within the surface and the other 2 outside
            currEdges=_lines[corners];
            // a value of -1 in the currEdges array means no more edges to check
            while (currEdges[n] != -1) {
              // retrieve edges involved
              int[] edge1 = _edges[currEdges[n++]];
              int[] edge2 = _edges[currEdges[n++]];
              
              // get indexes of start/end point relative to current grid xy position
              startP = _offsets[edge1[0]];
              endP = _offsets[edge1[1]];
              // get absolut grid position of those points by adding current xy's
              startOffsetX = x + startP[0];
              startOffsetY = y + startP[1];
              endOffsetX = x + endP[0];
              endOffsetY = y + endP[1];
              // get field value for the start point
              v1 = _sliceData[startOffsetX][startOffsetY];
              // compute difference in field strength to end point
              dV = _sliceData[endOffsetX][endOffsetY] - v1;
              // get linear interpolation factor based difference in field strengths
              lerpF = (dV != 0) ? (isoV - v1) / dV : 0.5;
              // compute interpolated position of start vertex
              vx1 = (xscale * (startOffsetX + lerpF * (endOffsetX - startOffsetX)))-w2;
              vy1 = (yscale * (startOffsetY + lerpF * (endOffsetY - startOffsetY)));
              
              // now do the same thing for the end point of the line
              startP = _offsets[edge2[0]];
              endP = _offsets[edge2[1]];
              startOffsetX = x + startP[0];
              startOffsetY = y + startP[1];
              endOffsetX = x + endP[0];
              endOffsetY = y + endP[1];
              v1 = _sliceData[startOffsetX][startOffsetY];
              dV = _sliceData[endOffsetX][endOffsetY] - v1;
              lerpF = (dV != 0) ? (isoV - v1) / dV : 0.5;
              vx2 = (xscale * (startOffsetX + lerpF * (endOffsetX - startOffsetX)))-w2;
              vy2 = (yscale * (startOffsetY + lerpF * (endOffsetY - startOffsetY)));
              
              // add the render pipeline and vertex cache
              if (zSlice) {
                vertex(vx1, vy1, currSlice);
                vertex(vx2, vy2, currSlice);
                cacheX[vCount]=vx1;
                cacheY[vCount]=vy1;
                cacheZ[vCount++]=currSlice;
                cacheX[vCount]=vx2;
                cacheY[vCount]=vy2;
                cacheZ[vCount++]=currSlice;
              } else {
                vertex(currSlice, vy1, vx1);
                vertex(currSlice, vy2, vx2);
                cacheX[vCount]=currSlice;
                cacheY[vCount]=vy1;
                cacheZ[vCount++]=vx1;
                cacheX[vCount]=currSlice;
                cacheY[vCount]=vy2;
                cacheZ[vCount++]=vx2;
              }
              // set edge as already processed
              _edgeFlags[x][y] = true;
            }
          }
        }
        xx++;
      }
    }
    endShape();
  }
}

// alternative text class for bitmap fonts
// based on code by the great glen murphy (http://glenmurphy.com)
// added flexible target image support and Z-buffer clearing

class FastText {
  int characters;
  int charWidth[] = new int[255];
  int charHeight;
  int chars[][];
  int lineHeight;
  int col;
  int wh = width*height;
  BImage img;
  
  FastText(String fontFile) {
    loadFont(fontFile);
    charHeight = img.height;
    lineHeight = charHeight;
    // find the characters' endpoints.
    int currWidth = 0;
    int maxWidth = 0;
    for(int i = 0; i < img.width; i++) {
      currWidth++;
      if(img.pixels[i] == 0xffff0000) {
        charWidth[characters++] = currWidth;
        if(currWidth > maxWidth) maxWidth = currWidth;
        currWidth = 0;
      }
    }
    // create the character sprites.
    chars = new int[characters][maxWidth*charHeight];
    int indent = 0;
    for(int i = 0; i < characters; i++) {
      for(int u = 0; u < charWidth[i]*charHeight; u++) {
        chars[i][u] = img.pixels[indent + (u/charWidth[i])*img.width + (u%charWidth[i])];
      }
      indent += charWidth[i];
    }
  }
  void setLineHeight(int h) {
    lineHeight = h;
  }
  void setColor(int c) {
    col=c;
  }
  void loadFont(String name) {
    img = loadImage(name);
  }
  void putchar(BImage img, int c, int x, int y, boolean clearZ) {
    int[] pix=img.pixels;
    y*=img.width;
    for(int i = 0; i < charWidth[c]*charHeight; i++) {
      int xpos = x + i%charWidth[c];
      int pos = xpos + y + (i/charWidth[c])*img.width;
      if(chars[c][i] == 0xff000000 && xpos < img.width && pos > 0 && pos < wh) {
        pix[pos] = col;
        if (clearZ) g.zbuffer[pos]=0;
      }
    }
  }
  void write(BImage img, String text, int x, int y, int wrap, boolean clearZ) {
    int indent = 0;
    for(int i = 0; i < text.length(); i++) {
      int c = (int)text.charAt(i);
      if(c == 10 || (wrap > 0 && indent > wrap)) {
        indent = 0;
        y += lineHeight;
      }
      if(c != 10) {
        putchar(img, c-32, x+indent, y,clearZ);
        indent += charWidth[c-32];
      }
    }
  }
  void write(BImage img, String text, int x, int y, boolean clearZ) {
    write(img, text, x, y, -1, clearZ);
  }
}

/***********************************************************************
compact, lightweight implementation of a GUI
all custom element types need to extend the GUIElement template class
***********************************************************************/

class GUI {
  GUIElement[] elements;
  int numElements;
  
  GUI() {
    this(1);
  }
  GUI(int n) {
    elements=new GUIElement[n];
    numElements=0;
  }
  GUI(GUIElement[] e) {
    elements=e;
    numElements=e.length;
  }
  
  // add new interface element
  void addElement(GUIElement e) {
    if (numElements==elements.length) {
      GUIElement[] enew=new GUIElement[numElements<<1];
      System.arraycopy(elements,0,enew,0,numElements);
    }
    elements[numElements++]=e;
  }
  
  // returns the UI element with that name
  // if you're going to call a custom method in the returned element,
  // you'll need to recast the returned handle to the specific element type used
  // for example:
  // ImagePanel panel=(ImagePanel)gui.getElementForID("mainPanel");
  // panel.setOffsetX(mouseX);
  
  GUIElement getElementForID(String id) {
    for(int i=0; i<numElements; i++) {
      if (elements[i].id==id) return elements[i];
    }
    return null;
  }
  
  // this method compares all elements with mouse position
  // for example:
  // void mouseMoved() {
    //   gui.checkElements(false);
  // }
  //
  // void mouseReleased() {
    //   gui.checkElements(true);
  // }
  //
  // if parameter is "true" and mouse is over an element,
  // the handleGUIElement() method will be called in the main class
  // with the selected element as argument
  
  void checkElements(boolean apply) {
    GUIElement e=null;
    for(int i=0; i<numElements; i++) {
      if (elements[i].mouseOver() && apply) e=elements[i];
    }
    if (e!=null) handleGUIElement(e);
  }
  
  // draw all elements in their current state
  void draw() {
    for(int i=0; i<numElements; i++) elements[i].draw();
  }
}

// interface element template class on which all others are based (extend)

abstract class GUIElement {
  // flag, if currently rollover
  boolean active;
  // flag, if element receives mouse clicks
  boolean enabled;
  // element name
  String id;
  // bounding rect on screen
  int x1,y1,x2,y2;
  
  // check if mouse is in bounds
  boolean mouseOver() {
    if (enabled) {
      return (active=(mouseX>=x1 && mouseX<=x2 && mouseY>=y1 && mouseY<=y2));
    }
    return false;
  }
  
  // make element clickable
  void enable() {
    enabled=true;
  }
  
  // cancle mouse clicks for element
  void disable() {
    enabled=false;
  }
  
  // every element class needs to provide its own draw() method
  abstract void draw();
}

// an arrow button class which adds its assigned value
// to a passed in argument when element is clicked
// element value can be also negative

// *here used to switch the currently displayed initial...

class IncrementorButton extends GUIElement {
  // assigned element value
  float value;
  // min/max limits for target value
  float minV,maxV;
  
  IncrementorButton(String i, float v, float mi, float mx, int xx, int yy, int xx2, int yy2) {
    id=i;
    value=v;
    minV=mi; maxV=mx;
    x1=xx; y1=yy;
    x2=xx2; y2=yy2;
    enabled=true;
  }
  
  void draw() {
    fill((active ? 255 : 153));
    noStroke();
    beginShape(TRIANGLES);
    if (value>0) {
      vertex(x1,y1);
      vertex(x2,(y1+y2)*0.5);
      vertex(x1,y2);
    } else {
      vertex(x2,y1);
      vertex(x1,(y1+y2)*0.5);
      vertex(x2,y2);
    }
    endShape();
  }
  
  // add element value to incoming param and limit result
  float apply(float v) {
    return max(minV,min(maxV,v+value));
  }
}

// 2-state icon button class
// to avoid numerous loadImage() calls, all icons are stored within a single image
// and the icon to be used is specified via pixel offsets

class IconButton extends GUIElement {
  // image handle
  BImage icon;
  // start offset in image and width/height of icon
  int offX,w,h;
  // blend modes used for on/off states (see reference for blend() method)
  int drawModeOff,drawModeOn;
  
  IconButton(String i, BImage img, int icon_id, int ww, int hh, int xx, int yy, int dm_off, int dm_on) {
    icon=img;
    id=i;
    w=ww; h=hh;
    offX=icon_id*w;
    x1=xx; y1=yy;
    x2=x1+w; y2=y1+h;
    drawModeOff=dm_off;
    drawModeOn=dm_on;
    enabled=true;
  }
  
  void draw() {
    if (active) {
      blend(icon,offX,h,offX+w,2*h,x1,y1,x2,y2,drawModeOn);
    } else {
      blend(icon,offX,0,offX+w,h,x1,y1,x2,y2,drawModeOff);
    }
  }
}

// 2d scrollable image area
// here used to display the selected letter initial
// use setOffsetX()/setOffsetY() methods to scroll

class ImagePanel extends GUIElement {
  BImage img;
  int w,h;
  int bgCol;
  int drawMode;
  int offsetX, offsetY;
  int minW,minH;
  int ox,oy;
  
  ImagePanel(String i, BImage im, int xx, int yy, int ww, int hh, int bg, int dm) {
    id=i;
    img=im;
    x1=xx; y1=yy;
    w=ww; h=hh;
    x2=x1+w; y2=y1+h;
    bgCol=bg;
    drawMode=dm;
    minW = min(img.width,w);
    minH = min(img.height,h);
    ox= x1+(img.width<w ? (w-img.width)/2 : 0);
    oy= y1+(img.height<h ? (h-img.height)/2 : 0);
  }
  
  void draw() {
    noStroke();
    fill(bgCol);
    rect(x1,y1,x2,y2);
    fill(0xff);
    // draw border
    rect(x1,y1-4,x2,y1); // top
    rect(x1-4,y1,x1,y2+4); // left
    rect(x2,y1,x2+4,y2+4); // right
    rect(x1,y2,x2,y2+4); // bottom
    blend(img, offsetX, offsetY, offsetX+minW, offsetY+minH, ox, oy, ox+minW, oy+minH, drawMode);
  }
  
  void setOffsetX(int x) {
    offsetX=x;
  }
  
  void setOffsetY(int y) {
    offsetY=y;
  }
}

// button class to toggle a certain bit value within a number
// here used for switching bits in the word type filter mask (see NodeTypes class above)

class BitToggleButton extends GUIElement {
  int bit,bitVal,complBitVal;
  boolean state;
  int y12;
  
  BitToggleButton(String i, int mask, int b, int xx, int yy, int ww, int hh) {
    id=i;
    x1=xx; y1=yy;
    x2=x1+ww; y12=y1+hh;
    y2=y1+2*hh+2;
    bit=b;
    // get bit value
    bitVal=1<<bit;
    // get the inverted bit value
    complBitVal=0xffffffff^bitVal;
    // find out if bit is currently set or not
    state=((mask&bitVal)!=0);
    enabled=true;
  }
  
  void draw() {
    stroke((active? 255 : 153));
    fill(192);
    rect(x1,y1,x2,y12);
    rect(x1,y12+2,x2,y2);
    noStroke();
    // get colour of word type the bit is associated with 
    fill(NodeTypes.palette[bitVal]>>16&0xff, NodeTypes.palette[bitVal]>>8&0xff, NodeTypes.palette[bitVal]&0xff);
    if (state) rect(x1+2,y1+2,x2-1,y12-1);
    else rect(x1+2,y12+4,x2-1,y2-1);
  }
  
  // turn on/off the bit and update mask value
  int toggle(int newmask) {
    state=!state;
    // first take all other bits (not ours)
    // then add our new value (or 0 if currently switched off)
    return (newmask & complBitVal) | (state ? bitVal : 0);
  }
  // force new state
  void set(boolean s) {
    state=s;
  }
}

