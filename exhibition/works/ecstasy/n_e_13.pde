
/*
+ the ecstasy of communication
+ software simulation
+ 2004 lucas kuzma
+ http://machinatus.net
*/

Node[] nodes;
int n_nodes = 48;
float angleX;
float angleY;
float earshot;  // how far sound travels
float spread;   // how wide sound travels

int outputLen = 480; // sonia
float[] preBuf = new float[outputLen];

int ARC_STEPS = 12; // arc drawing

// ------------------------------------------------------------------------------
void lineTo(float x1, float y1, float z1, float x2, float y2, float z2, float p){
  // draws line from 1 to 2 with distance determined by percent parameter p
  line(x1,y1,z1,x1+(x2-x1)*p,y1+(y2-y1)*p,z1+(z2-z1)*p);
}
void dotsTo(float x1, float y1, float x2, float y2, float p, float diameter, float spacing){
  // draws dotted line from 1 to 2 with distance determined by percent parameter p
  float d = dist(x1,y1,x2,y2);
  int steps = int(d/spacing);
  float dx = (x2-x1)/steps;
  float dy = (y2-y1)/steps;
  for( int i=0; i<steps*p; i++ ){
    x1 += dx;
    y1 += dy;
    ellipse(x1,y1,diameter,diameter);
  }
}
// ------------------------------------------------------------------------------
float normRad(float r){
  // normalize angle measurement to fall between 0 and TWO_PI
  if( r < 0 ) r+= TWO_PI;
  else if( r > TWO_PI ) r-= TWO_PI;
  else return r;
  return normRad(r);
}
  
// ------------------------------------------------------------------------------
class Node
{

  int id;

  float x; // xposition
  float y; // yposition
  float z; // yposition
  float t; // bearing
  float dt;// bearing dest

  float ae;  // activation energy
  float th;  // threshold
  float fd;  // firing duration
  int lft;   // last fire time ms
  float stim;// stimulation

  float sz;  // size

  Node(int n){
    x = random(-1,1);
    y = random(-1,1);
    z = 0;
    t = random(TWO_PI);
    th = .75;
    ae = random(th);
    sz = .02;
    fd = 0;
    id = n;
    stim = 0;
    lft = 0;
  }

  void trigger(){
    // external trigger
    if( fd > 0 ) return;
    ae += .2;
  }

  void paint(){
    // show stimulation
    sz = .02+stim/500;
    // mouse zoom
    //sz = max(.01, .04 - dist(x,y,float(mouseX-width/2)/150.0,float(mouseY-height/2)/150.0)/40 );
    // draw arcs
    noStroke();
    // ae
    fill(243,54,153);
    arc(x,y,0,TWO_PI*ae,sz,sz*2,ARC_STEPS);
    // th
    fill(20);
    arc(x,y,TWO_PI*th,TWO_PI*th+.2,sz,sz*2,ARC_STEPS);
    // t
    fill(204,204,204);
    arc(x,y,0,TWO_PI-.01,sz*3,sz*4,ARC_STEPS);
    fill(94,94,94);
    arc(x,y,float(t-spread),float(t+spread),sz*3,sz*4,ARC_STEPS);
    // fd
    fill(255,255,62);
    arc(x,y,0,TWO_PI*(fd/25),sz*2,sz*3,ARC_STEPS);
    // earshot
    if( b_ear ){
      fill(225,225,225,100);
      arc(x,y,float(t-spread),float(t+spread),sz*4,sz*38*earshot,ARC_STEPS);
    }
  }
  
  void update(){

    // self-triggering
    ae += .001;

    // firing
    if( ae > th ){
      fd = 20 + int(random(5));
      ae -= .2 + random(.8);  // post-trigger depolarization
      float elapsed = millis() - lft;
      if( elapsed < 500 ) ae = 0.0001;
      lft = millis();
      stim += 5;
    }
    
    // decay
    if( fd > 0 ) fd*=.95;
    if( fd < .001 ) fd = 0;
    if( stim > 0 ) stim*=.99;
    if( stim < .001 ) stim = 0;    

    // rotation
    if( abs(t-dt) < .01 ) dt = 2*noise(millis())*TWO_PI;
    t += ( dt - t )/6;
    
    // movement
    if( b_move ){
      x += mouseY*cos(t)/10000;
      y += mouseY*sin(t)/10000;
      if( y >  1 ) y-=2;
      if( y < -1 ) y+=2;
      if( x >  1 ) x-=2;
      if( x < -1 ) x+=2;      
    }
    if( b_firemove ){
      x += fd*cos(t)/1000;
      y += fd*sin(t)/1000;
      if( y >  1 ) y-=2;
      if( y < -1 ) y+=2;
      if( x >  1 ) x-=2;
      if( x < -1 ) x+=2;      
    }    
    
  }
}

void arc(float x, float y, float ta, float tb, float ra, float rb, int s){
  // draw an arc at x and y, from angle ta to tb, with radius from ra to rb, in s steps
  push();
  translate(x,y);
  rotate(ta);
  beginShape(POLYGON);
  float a = (tb-ta)/s;
  for( int i=0; i<=s; i++ ){
    vertex(rb*cos(a*i),rb*sin(a*i));
  }
  for( int i=s; i>=0; i-- ){
    vertex(ra*cos(a*i),ra*sin(a*i));
  }
  endShape();
  pop();
}

// ------------------------------------------------------------------------------ sonia
void liveOutputEvent(){

  // clear
  for(int i=0;i<outputLen;i++){
    preBuf[i] = 0;
  }
  // node num -> freq
  for(int n=0; n<n_nodes; n++){
      for(int i=0;i<outputLen;i++){
        preBuf[i] += nodes[n].fd*sin(i*n*.01)/(480);
      }
  }
  
  // filter
  int span = int(mouseX/10);
  for( int i=0; i<outputLen; i++ ){
    float sum=0;
    for( int j=1-span; j<span; j++ ){
      int index = i+j;
      if(index<0) index += outputLen;
      if(index>=outputLen) index -= outputLen;
      sum += (span-abs(j))*(span-abs(j))*preBuf[index];
    }
    LiveOutput.data[i] = min(1,sum/(span*span*10));
  }
  
}

float hump(float sa) {
  sa = (sa - 0.5) * 2; //scale from -2 to 2
  sa = sa*sa;
if(sa > 1) { sa = 1; }
  return 1-sa;
}

// ------------------------------------------------------------------------------ setup
void setup()
{
  size(480,480);
  framerate(20);
  ellipseMode(CENTER_DIAMETER);
  rectMode(CENTER_DIAMETER);
  g.depthTest = false;

  // ------------------------------------------ sonia
  Sonia.start(this,11000);
  LiveOutput.start(outputLen,outputLen*2);
  LiveOutput.startStream();

  nodes = new Node[n_nodes];
  for( int i=0; i<n_nodes; i++ ){
    nodes[i] = new Node(i);
  }
}

// ------------------------------------------------------------------------------ switches

boolean b_smooth = false;
boolean b_draw = true;
boolean b_fade = false;
boolean b_move = false;
boolean b_ear = true;
boolean b_firemove = true;

void keyPressed() { 
  if( key == 's' ){
    b_smooth = !b_smooth;
    if(b_smooth) smooth(); else noSmooth();
  }
  if( key == 'd' ) b_draw = !b_draw;
  if( key == 'f' ) b_fade = !b_fade;
  if( key == 'r' ) b_move = !b_move;
  if( key == 'e' ) b_ear = !b_ear;  
  if( key == 'm' ) b_firemove = !b_firemove;  
  if( key == 'Z' ) saveFrame();
}

// ------------------------------------------------------------------------------ loop
void loop()
{

  if( b_fade ){
    fill(255,255,255,100);
    rect(width/2,height/2,width, height);
  } else {
    background(255);
  }

  // ------------------------------------------ draw audio buffer
  
  color c = color(200,66,148,50);
  for( int i=0; i<outputLen; i++ ){
    set(width-i,(height/2)+int(height*LiveOutput.data[i]),c);
  }  
 
  // ------------------------------------------ geometry

  translate(height/2, height/2, 0);
  scale(240);
   
  // ------------------------------------------ nodes

  boolean connected;

  // update nodes
  for( int i=0; i<n_nodes; i++ ){
    // test earshot
    for( int j=0; j<n_nodes; j++ ){
      if( j == i ) continue;

      // adjust network
      if(mousePressed == true){
        earshot = float(mouseY) / 200;
        spread = float(mouseX) / 300;
      }
      connected = false;
      // show network
      if( dist(nodes[i].x, nodes[i].y, nodes[i].z, nodes[j].x, nodes[j].y, nodes[j].z) < earshot ){
        float tb = atan2( nodes[j].y - nodes[i].y, nodes[j].x - nodes[i].x );
        fill(194,41,121);
        noStroke();
        // little dot toward nodes in earshot
        if( b_draw )
          ellipse(nodes[i].x+nodes[i].sz*4.5*cos(tb),nodes[i].y+nodes[i].sz*4.5*sin(tb),nodes[i].sz/2,nodes[i].sz/2);
        float tb_t = normRad(tb - nodes[i].t);
        if( tb_t < spread || tb_t > TWO_PI-spread ){
          stroke(117,94,235,75);
          line(nodes[i].x, nodes[i].y, nodes[j].x, nodes[j].y);
          connected = true;
        }
      }

      // fire
      if( nodes[i].fd >= 1 ){ // fired
        if( connected ){
          noStroke();
          fill(0,255,255,80);
          dotsTo(nodes[j].x, nodes[j].y, nodes[i].x, nodes[i].y, float(nodes[i].fd)/25, .02, .01 );
          if( nodes[i].fd == 1 ) nodes[j].trigger();
        }
      }
    }
    nodes[i].update();
    if( b_draw ) nodes[i].paint();
  }

}

// ------------------------------------------------------------------------------
public void stop(){
  Sonia.stop();
  super.stop();
}
