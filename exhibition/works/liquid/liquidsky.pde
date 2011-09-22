Particle[] dots;
int count;
int[] bright;
int[] tmpBright;
int iMax;
int[] dx;
int[] dy;

Gradient grad;

void setup(){

  size(200,500);
  background(255);
  noStroke();
  framerate(30);

  iMax=width*height;
  bright=new int[iMax];
  tmpBright=new int[iMax];

  for (int i=0;i<iMax;i++){
        bright[i]=0;
  }
  
  dx=new int[256];
  dy=new int[256];

  for (int i=0;i<256;i++){
    float fi=(float)i;
    float a=7*( fi/255*TWO_PI);
    dx[i]=(int)(4*cos(a));
    dy[i]=(int)(4*sin(a));
  }

  count=600;

  grad=new Gradient(0xffffff,0xffffff);
  grad.addMarker(0.25,0xff8000);
  grad.addMarker(0.5,0x800000);
  grad.addMarker(0.65,0x000000);
  grad.addMarker(0.75,0x800000);
  grad.addMarker(0.85,0xff8000);
  
  dots=new Particle[count];
  for (int i=0;i<count;i++){
    dots[i]=new Particle(width,height);
  }

  for (int i=0;i<count;i++){
    for (int e=0;e<(int)random(count);e++){
      int o=(int)random(count);
      if (o!=i){
        dots[i].addEnemy(dots[o]);
      }
    }
    for (int t=0;t<(int)random(count);t++){
      int o=(int)random(count);
      if (o!=i){
        dots[i].addTarget(dots[o]);
      }
    }
  }
}

void loop(){
  int i;
  for (i=0;i<count;i++){
    dots[i].move();
  }
  for (i=0;i<count;i++){
    dots[i].apply();
  }
  for (i=0;i<count;i++){
    dots[i].render();
  }
  diffuse();
  distort();
}

void diffuse(){
  int r,g,b,c,p,i,x,y;
  for (i=0;i<iMax;i++){
    c=1;
    p=bright[i];
    x=i%width;
    if (x>0){
      p+=bright[i-1];
      c++;
    }
    if (x<width-1){
      p+=bright[i+1];
      c++;
    }
    y=i/width;
   
    if (y>0){
      p+=bright[i-width];
      c++;
    }
    
    p/=c;
    tmpBright[i]=p;
  }
  bright=tmpBright;
}

void distort(){
  int i,x,y,p,idx;
  for (i=0;i<iMax;i++){
    idx=bright[i];
    x=i%width+dx[idx];
    y=i/width+dy[idx];
    if (x>=0 && y>=0 && x<width && y<height){
      p=blend(bright[x+y*width],bright[i],128);
    } else {
      p=bright[i];
    }
    pixels[i]=grad.getColor(p);
  }
}


void display(){
  for (int i=0;i<iMax;i++){
     pixels[i]=grad.getColor(bright[i]);
  }
}

int blend(int a,int b,int f){
  return (a*f+b*(255-f))/255;
}

class Particle{

  float x,y,nx,ny;
  int ix,iy,ip;
  float vx,vy;
  float speed;
  float targetSpeed;
  float angle;
  float targetAngle;
  float cx,cy;
  float MAXSPEED=7;
  float ENEMY_ZONE=60;
  float TARGET_ZONE=60;
  float AVOID_ZONE=12;
  float BORDER=5;
  float CONSTRAIN_RADIUS=0;
  float INNER_CONSTRAIN_RADIUS=60;
  boolean friendDetected=false;
  boolean enemyDetected=false;
  int fd;
  int ed;
  Particle[] targets;
  Particle[] enemies;

  Particle(int w,int h){
    cx=(float)w/2.0f;
    cy=(float)h/4.0f;
    x=random(w);
    y=random(h);
    vx=0;
    vy=0;
    targetSpeed=speed=0;
    targetAngle=angle=random(TWO_PI);
    targets=new Particle[0];
    enemies=new Particle[0];
    ENEMY_ZONE*=ENEMY_ZONE;
    TARGET_ZONE*=TARGET_ZONE;
    AVOID_ZONE*=AVOID_ZONE;
    CONSTRAIN_RADIUS=min(width,height)/2-BORDER;
    CONSTRAIN_RADIUS*=CONSTRAIN_RADIUS;
  }

  void setXY(int xs,int ys){
    x=xs;
    y=ys;
  }

  void addTarget(Particle t){
    for (int i=0;i<targets.length;i++){
      if (targets[i]==t){
        return;
      }
    }
    for (int i=0;i<enemies.length;i++){
      if (enemies[i]==t){
        return;
      }
    }
    Particle[] tempTargets=new Particle[targets.length+1];
    System.arraycopy(targets, 0, tempTargets, 0, targets.length);
    tempTargets[targets.length]=t;
    targets=tempTargets;
  }

  void addEnemy(Particle t){
    for (int i=0;i<enemies.length;i++){
      if (enemies[i]==t){
        return;
      }
    }
    for (int i=0;i<targets.length;i++){
      if (targets[i]==t){
        return;
      }
    }
    Particle[] tempEnemies=new Particle[enemies.length+1];
    System.arraycopy(enemies, 0, tempEnemies, 0, enemies.length);
    tempEnemies[enemies.length]=t;
    enemies=tempEnemies;
  }

  void move(){
    this.updateDirection();
    this.checkTargets();
    this.checkContraints();
    this.updateSpeed();
    nx=x+vx;
    ny=y+vy;
  }

  void checkContraints(){
    if (x<BORDER || y<BORDER || x>width-BORDER || y>height-BORDER){
      float dx=cx-x;
      float dy=cy-y;
      angle=turn(angle,atan2(dy,dx),.1f);
      speed*=.94;
    }
  }

  void updateDirection(){
    targetAngle=random(TWO_PI);
    angle=turn(angle,targetAngle,.2f);
    targetSpeed=random(speed+MAXSPEED/2);
    speed=(15*speed+targetSpeed)/16;
  }

  void checkTargets(){
    float dMin=TARGET_ZONE+1;
    float pointAngle=angle;
    friendDetected=false;
    for (int i=0;i<targets.length;i++){
      float dx=targets[i].x-x;
      float dy=targets[i].y-y;
      float d=dx*dx+dy*dy;
      if (d<=TARGET_ZONE && d<dMin){
        if (d>AVOID_ZONE){
          dMin=d;
          pointAngle=atan2(dy,dx);
        }
        fd=i;
        friendDetected=true;
      }
    }
    enemyDetected=false;
    dMin=TARGET_ZONE+1;
    float  fleeAngle=angle;
    for (int i=0;i<enemies.length;i++){
      float dx=enemies[i].x-x;
      float dy=enemies[i].y-y;
      float d=dx*dx+dy*dy;
      if (d<=ENEMY_ZONE && d<dMin){
        dMin=d;
        fleeAngle=-atan2(dy,dx);
        enemyDetected=true;
        ed=i;
      }
    }
    if (friendDetected){
      angle=turn(angle,pointAngle,.1);
      speed*=.95;
    }
    if (enemyDetected){
      angle=turn(angle,fleeAngle,.1);
      speed*=1.05;
    }
  }

  void updateSpeed(){
    speed=min(speed,MAXSPEED);
    vx=cos(angle)*speed;
    vy=sin(angle)*speed;
  }

  void apply(){
    x=nx;
    y=ny;
    ix=(int)x;
    iy=(int)y;
    ip=ix+iy*width;
  }

  float turn(float currentAngle,float targetAngle,float percent){
    float aDif=targetAngle-currentAngle;
    if (aDif>PI){
      aDif=-(TWO_PI-aDif);
    } else if (aDif<-PI){
      aDif=TWO_PI+aDif;
    }
    return currentAngle+aDif*percent;
  }

  void render(){
     if (x<0 || x>=width || y<0 || y>=height || ip<0 || ip>=iMax){
        return;
     }
     if (enemyDetected || friendDetected){
      bright[ip]=255;
    } else {
      bright[ip]=0;
    }
  }

}

class Gradient
{
  Marker[] markers;
  int[] palette;
  Gradient(int c1,int c2){
    markers=new Marker[2];
    markers[0]=new Marker(0,c1);
    markers[1]=new Marker(1,c2);
    palette=new int[256];
    this.updatePalette();
  }

  void addMarker(float p,int c){
    Marker[] tempMarkers=new Marker[markers.length+1];
    int iAdd=0;
    for (int i=0;i<markers.length;i++){
     if (markers[i].position<p || iAdd==1){
         tempMarkers[i+iAdd]=markers[i];
     } else  {
         tempMarkers[i+iAdd]=new Marker(p,c);
         iAdd=1;
         tempMarkers[i+iAdd]=markers[i];
     }
    }
    markers=tempMarkers;
    this.updatePalette();
  }

  void updatePalette(){
    int p1,p2,p,r,g,b,step,steps;
    Marker currentMarker,nextMarker;
    for (int i=0;i<markers.length-1;i++){
      currentMarker=markers[i];
      nextMarker=markers[i+1];
      p1=currentMarker.getPalettePos();
      p2=nextMarker.getPalettePos();
      steps=p2-p1;
      step=0;
      for (p=p1;p<p2;p++){
        r=((currentMarker.col & 0xff0000)*(steps-step) + (nextMarker.col & 0xff0000)*(step))/steps;
        g=((currentMarker.col & 0x00ff00)*(steps-step) + (nextMarker.col & 0x00ff00)*(step))/steps;
        b=((currentMarker.col & 0x0000ff)*(steps-step) + (nextMarker.col & 0x0000ff)*(step))/steps;
        palette[p]=0xff000000 | (r & 0xff0000) | (g & 0x00ff00) | (b & 0x0000ff);
        step++;
      }
    }
  }
  
  int getColor(int c){
      return palette[c];
  }
  
}

class Marker{
  float position;
  int col;
  Marker(float p,int c){
    position=p;
    col=c;
  }

  int getPalettePos(){
    return (int)(position*255);
  }
}

