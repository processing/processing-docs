// This code was written with the _ALPHA_ version 
// of Processing and may not run correctly in the 
// current version.


//     < < < R I C O C H E T
// by Josh Nimoy with code by Mark Napier
// <www.jtnimoy.com>   ||   <www.potatoland.org>

// Instructions:
// Click the two white buttons in the bottom corners
// the right button will show credits and instructions
// while the left button will toggle "trails"
// use the mouse to drag the jiggling letterforms 
// while typing on the keyboard will make new letters.
// In order to clear the background during trails, press spacebar.

// Written Spring 2003, New York, NY


Scene world; //holds all the objects
String objFile; //embeds my OBJ files
Mass nearMass = null; //points to the closest mass to the mouse
boolean bgstat = true;
boolean trails=false;
int MAX_PHYSICSOBJECTS = 20000; //Moore's law
int ticks=0;
float trailsbuttoncolor = 255.0;//some buttons
boolean arrogance = false;
float arrogance_color = 255.0;

public void setup(){
  nearMass = null;
  size(640,300);
  background(#C9F0AF);
  world = new Scene();
  bgstat = true;
  noStroke();
  rect(0,0,width,height);
}

  void mousePressed(){
    if(mouseY>height-Mass.wallbottom){
      if(mouseX<16){
         trails=!trails;
      }else if(mouseX>width-16){
        arrogance=!arrogance;
      }
    }else{
      nearMass = (Mass)world.nearestMass(mouseX,mouseY);
    }
  }


  void mouseReleased(){
    nearMass = null;
  }


  void keyPressed(){
    keydown(key);
  }
  //an artificial keydown
  void keydown(int k){
    world.importOBJ(OBJFile(k));
    if(k==' '){
      fill(#C9F0AF);
      if(bgstat){
        noBackground();
        bgstat = false;
      }else{
        background(#C9F0AF);
        bgstat = true;
      }
      noStroke();
      rect(width/2,height/2,width,height);
    }
  }


void loop(){
  long mill = millis();
  if(mill>5000 && mill<10000){
    arrogance = true;
  }else if(mill>10000 && mill<10100){
    arrogance = false;
  }
  
  rectMode(CORNER);
  fill(#C9F08F);
  noStroke();
  fill(#C9F08F);
  rect(0,height-16,width,height);
  
  fill(trailsbuttoncolor);
  rect(0,height-16,16,height);
  
  fill(arrogance_color);
  rect(width-16,height-16,16,height);

  if(trails){
    noBackground();
    trailsbuttoncolor/=1.1;
  }else{
    background(#C9F0AF);
    trailsbuttoncolor+=(255.0-trailsbuttoncolor)/10.0;
  }

  if(arrogance){
    drawTheText(arrogance_color);
    arrogance_color/=1.1;
  }else{
     if(arrogance_color>254){
         
     }else{
       drawTheText(arrogance_color);
     }
    arrogance_color+=(255.0-arrogance_color)/10.0;
  }  
  ticks++;
  //allows adjustment of temporal kerning by hand
  if(ticks== 1)keydown('r');
  if(ticks==13)keydown('i');
  if(ticks==20)keydown('c');
  if(ticks==30)keydown('o');
  if(ticks==40)keydown('c');
  if(ticks==50)keydown('h');
  if(ticks==60)keydown('e');
  if(ticks==70)keydown('t');

  if(nearMass!=null){
    nearMass.p.x = mouseX;
    nearMass.p.y = mouseY;
    nearMass.v.x =  nearMass.v.y =  nearMass.v.z = 0;
  }
  world.step();

  rectMode(CENTER_DIAMETER);
  stroke(0);
  noFill();
  Spring thisSpring;
  int limiter = 0;
  if(world.all.size()>MAX_PHYSICSOBJECTS){
    limiter=world.all.size()-MAX_PHYSICSOBJECTS;
  }
  
  //draw  
  for(int i=world.all.size()-1;i>=limiter;i--){
    if(world.get(i) instanceof Spring){
      thisSpring = (Spring)world.get(i);

      if(thisSpring.visible){
        if(thisSpring.mass1.v.x>0){
          if(trails){
            darkenLine(10,10,10,(int)thisSpring.mass1.p.x,
              (int)thisSpring.mass1.p.y,
            (int)thisSpring.mass2.p.x,(int)thisSpring.mass2.p.y);
          }else{
            stroke(0,0,0);
            line((int)thisSpring.mass1.p.x,(int)thisSpring.mass1.p.y,
            (int)thisSpring.mass2.p.x,(int)thisSpring.mass2.p.y);
          }
        } else{
          if(trails){
            darkenLine(30,10,10,(int)thisSpring.mass1.p.x,
              (int)thisSpring.mass1.p.y,
            (int)thisSpring.mass2.p.x,(int)thisSpring.mass2.p.y);
          }else{
            stroke(100,120,0);
            line((int)thisSpring.mass1.p.x,(int)thisSpring.mass1.p.y,
            (int)thisSpring.mass2.p.x,(int)thisSpring.mass2.p.y);
          }
        }
      }
    }
  }
}





  class Spring implements Steppable
  {
    public static final double factor = 1000000.0D;
    //
    public double restLength;
    public double springConstant;//added by jtnimoy
    public double dampRate;
    public Mass mass1;
    public Mass mass2;
    //
    static double avTen = 1000D;
    protected static int selAttrib = 0;
    public boolean visible = true;
    //
    private double tension;
    double lenX;
    double lenY;
    double lenZ;
    double len;
    double nlenX;
    double nlenY;
    double nlenZ;
    double nlen;
    double damp;
    double fX;
    double fY;
    double fZ;

    public Spring(double len, double K, double damp, Mass m1, Mass m2)
    {
      tension = 0.0D;
      
      if (len <= 0.0) {
            double lenX = m2.p.x - m1.p.x;
            double lenY = m2.p.y - m1.p.y;
            double lenZ = m2.p.z - m1.p.z;
            restLength = Math.sqrt(lenX*lenX + lenY*lenY + lenZ*lenZ);
      }else{
            restLength = len;
      }
        
      springConstant = K;
      dampRate = damp;
      mass1 = m1;
      mass2 = m2;
    }

    public void step()
    {
      fX=0;
      fY=0;
      fZ=0;
      damp=0;
      // current length of spring
      lenX = mass2.p.x - mass1.p.x;
      lenY = mass2.p.y - mass1.p.y;
      lenZ = mass2.p.z - mass1.p.z;
      len = Math.sqrt(lenX * lenX + lenY * lenY + lenZ * lenZ);
      // next spring length, based on velocity of endpoints
      // the 10000 constant prevents springs from exploding
      //    (100 explodes easily) by scaling velocity down
      nlenX = lenX + ((mass2.v.x - mass1.v.x)/factor);
      nlenY = lenY + ((mass2.v.y - mass1.v.y)/factor);
      nlenZ = lenZ + ((mass2.v.z - mass1.v.z)/factor);
      nlen = Math.sqrt(nlenX * nlenX + nlenY * nlenY + nlenZ * nlenZ);
      // dampFactor is damping rate * (change in spring len
      // relative to original length)
      // multiply back in the 10000 to scale value back up to normal
      //damp = dampRate * (((nlen-len)/len)*Globals.scaleUnit);
      damp = dampRate * ((nlen-len)/len) * factor;
      fX = (lenX * damp) / len;
      fY = (lenY * damp) / len;
      fZ = (lenZ * damp) / len;
      // apply the damping force to the two masses
      mass1.applyForce(fX, fY, fZ);
      mass2.applyForce(-fX, -fY, -fZ);
      // cap the new length at .5 to 1.5 the rest length of spring
      if(len < restLength/2D) {
        len = restLength/2D;
      }
      else if(len > (restLength*3D)/2D) {
        len = (restLength*3D)/2D;
      }
      // calculate tension based on springiness and length of spring
      tension = springConstant * ((restLength-len)/restLength);
      fX = tension * (lenX/len);
      fY = tension * (lenY/len);
      fZ = tension * (lenZ/len);
      // apply the spring tension force to the two masses
      mass1.applyForce(-fX, -fY, -fZ);
      mass2.applyForce(fX, fY, fZ);
    }

  }





  class Mass implements Steppable{
      // Constants for all Masses (gravity is in Physics3D too)
    public static double gravity = -9.8D;
    public static double DT = 20.01D;//time step = 1/100 sec or 10 millis
    public static double accelPerDT = gravity * 0.00001D;
    //
    public int ID;         	// index of this mass in array of masses
    public double m;		// weight
    public Vector3D p;		// contains screen x,y and as x,y,z vector
    public Vector3D v;		// xyz velocity
    public boolean frozen;	// mass can't move
    //
    // 'Register' vars for calculations
    double mag;
    
    // added by added by josh into the system...
    protected static int selAttrib = 0;
    static int wallthresh=0;//bounding box restriction
    static int wallright=0;
    static int walltop=0;
    static int wallbottom=16;

    public Mass(double mass, double x, double y, double z,
                            double Vx, double Vy, double Vz){
      frozen = false;
      m = mass;
      p = new Vector3D(x, y, z);  // position
      v = new Vector3D(Vx, Vy, Vz);   // velocity
    }

    public void applyForce(double fx, double fy, double fz){
      v.x += (DT * fx) / m;
      v.y += (DT * fy) / m;
      v.z += (DT * fz) / m;
    }

    public void step(){
      if(frozen){
        v.x = v.y = v.z = 0.0D;
        return;
      }
      
      v.y += accelPerDT;
      limit();
      p.x += v.x * DT;
      p.y += v.y * DT;
      p.z += v.z * DT;

      //------and now, a basic rectangular 2D wall "bouncing"      
      if(p.y > height-wallbottom){
        p.y = (height-wallbottom)-Math.random();
        v.x = v.z = v.y = 0.0D;
      }

      if(p.y < 0.0D){
        p.y = Math.random();
        v.x = v.z = v.y = 0.0D;
      }

      
      if(p.x > width){
        p.x = width-Math.random();
        v.x = v.z = v.y = 0.0D;
      }

      if(p.x < wallthresh){
        p.x = wallthresh;//Math.random();
        v.x = v.z = v.y = 0.0D;
      }
    }
    public Mass duplicate(){//was this added by jtnimoy?
      return new Mass(m, p.x, p.y, p.z, v.x, v.y, v.z);
    }
    private void limit(){
      mag = v.x * v.x + v.y * v.y + v.z * v.z;

      if(mag > 10.0D){//this was originally 10000D in Mark's code
        double vh = Math.sqrt(mag / 10.0D);//so was this
        v.x /= vh;
        v.y /= vh;
        v.z /= vh;
      }
    }
  }




  class Vertex extends Vector3D
  {
    public int sx;
    public int sy;
    public boolean visible;
    static Color reflectColour = new Color(0x222222);

    public Vertex(double d, double d1, double d2)
    {
      super(d, d1, d2);
      visible = false;
    }

    public Vertex(Vector3D v)
    {
      super(v.x, v.y, v.z);
      visible = false;
    }
  }




class Vector3D
{
    public double x;
    public double y;
    public double z;

    public Vector3D(double x, double y, double z)
    {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public double angle(Vector3D v)
    {
        return Math.acos(cosAngle(v));
    }

    public double cosAngle(Vector3D v)
    {
        double a= Math.sqrt(dotProduct(this));
        double b = Math.sqrt(v.dotProduct(v));
        double c = dotProduct(v);
        return c / (a * b);
    }

    public Vector3D crossProduct(Vector3D v)
    {
        return new Vector3D(y * v.z - z * v.y,
              z * v.x - x * v.z, x * v.y - y * v.x);
    }

    public double dotProduct(Vector3D v)
    {
        return x * v.x + y * v.y + z * v.z;
    }

    public double magnitude()
    {
        return Math.sqrt(dotProduct(this));
    }

    public Vector3D minus(Vector3D v)
    {
        return new Vector3D(x - v.x, y - v.y, z - v.z);
    }

    public Vector3D plus(Vector3D v)
    {
        return new Vector3D(x + v.x, y + v.y, z + v.z);
    }

    public void scale(double s)
    {
        x *= s;
        y *= s;
        z *= s;
    }

    public void subtract(Vector3D v)
    {
        x -= v.x;
        y -= v.y;
        z -= v.z;
    }
}
//////////////////////////////////////////////////////////////////
  class Scene{
    public Vector all;
    private boolean paused;

    public Scene(){
      all = new Vector();
      paused = false;
    }

    // add an array of springs and masses to scene
    public synchronized void add(Steppable[] obj){
      for(int i = 0; i < obj.length; i++){
        all.addElement(obj[i]);
      }
    }

    // add one spring or mass to scene
    public synchronized void add(Steppable o){
      all.addElement(o);
    }

    public synchronized Steppable get(int i){
      return (Steppable)all.elementAt(i);
    }

    public synchronized void remove(Steppable o){
      all.removeElement(o);
    }

    //////////////////////////////////////////////////////////////
    // find nearest mass to mouse click
    // points hold screen x,y coords and spatial x,y,z so we
    // can map screen to 3D space easily

    public Mass nearestMass(int x, int y)
    {
      Mass mass = null;
      double maxDist = 1000000;
      for(int i = 0; i < size(); i++){

        if(get(i) instanceof Mass) {
          Mass m1 = (Mass)get(i);
          double dx = (x - m1.p.x);
          double dy = (y - m1.p.y);
          dx *= dx;
          dy *= dy;
          double dist = 0;
          dist = Math.sqrt(dx+dy);
          if(dist < maxDist){

            maxDist = dist;
            mass = m1;
          }
        }
      }
      return mass;
    }

    public void step(){
      if(!paused){
        int limiter = 0;
        if(all.size()>MAX_PHYSICSOBJECTS){
          limiter=all.size()-MAX_PHYSICSOBJECTS;
        }
        for(int i=all.size()-1; i >= limiter; i--){
          ((Steppable)all.elementAt(i)).step();
        }
      }
    }

    public synchronized int size()
    {
      return all.size();
    }

    public void togglePaused()
    {
      paused = !paused;
    }

    public Vector getMasses(){
      Vector vc = new Vector();
      for(int i=0;i<all.size();i++){
        if(get(i) instanceof Mass)vc.addElement(get(i));
      }
      return vc;
    }

    public Vector getSprings(){
      Vector vc = new Vector();
      for(int i=0;i<all.size();i++){
        if(get(i) instanceof Spring)vc.addElement(get(i));
      }
      return vc;
    }

    public void importOBJ(String dataStr){
      //parses dataStr into spring/mass network
      //according to the OBJ-file formatted data in dataStr.

      //split the lines.
      boolean makeThisOneInvisible = false;
      StringTokenizer st = new StringTokenizer(dataStr,"\n");
      Vector masses = new Vector();
      int startPointer = all.size();
      while (st.hasMoreTokens()) {
        StringTokenizer linetokens = new StringTokenizer(st.nextToken());
        String thisToken = linetokens.nextToken();
        if(thisToken.equals("inv")){
          makeThisOneInvisible = true;
        }else if(thisToken.equals("v")){
          float initX=Float.valueOf(linetokens.nextToken()).floatValue();
          float initY=Float.valueOf(linetokens.nextToken()).floatValue();
          float initZ=Float.valueOf(linetokens.nextToken()).floatValue();
          Mass m = new Mass(70000,  initX*10 + (width-100) ,
                            initY*10 + 100,initZ*10,   -0.399999999,0,0);
          add(m);
          masses.addElement(m);
        }else if(thisToken.equals("f")){
          StringTokenizer bunchtokens;
          int t4 = 0;

          bunchtokens = new StringTokenizer(linetokens.nextToken(),"/");
          int t1 = Integer.valueOf( bunchtokens.nextToken() ).intValue();

          bunchtokens = new StringTokenizer(linetokens.nextToken(),"/");
          int t2 = Integer.valueOf( bunchtokens.nextToken() ).intValue();

          if(!linetokens.hasMoreTokens()){
            Spring spr = addNewSpring((Mass)masses.elementAt(t1-1),
                                          (Mass)masses.elementAt(t2-1));
            if(makeThisOneInvisible){
              spr.visible = false;
              makeThisOneInvisible =false;
            }
          }else{
            bunchtokens = new StringTokenizer(linetokens.nextToken(),"/");
            int t3=Integer.valueOf(bunchtokens.nextToken()).intValue();
            println("-----");
            if(linetokens.hasMoreTokens()){//quad or tri?
              bunchtokens=new StringTokenizer(linetokens.nextToken(),"/");
              t4 = Integer.valueOf( bunchtokens.nextToken() ).intValue();
              //quad

              addNewSpring((Mass)masses.elementAt(t1-1),
                                      (Mass)masses.elementAt(t2-1));
              addNewSpring((Mass)masses.elementAt(t2-1),
                                      (Mass)masses.elementAt(t3-1));
              addNewSpring((Mass)masses.elementAt(t3-1),
                                      (Mass)masses.elementAt(t4-1));

              addNewSpring((Mass)masses.elementAt(t4-1),
                                      (Mass)masses.elementAt(t1-1));

              Spring s1 = addNewSpring((Mass)masses.elementAt(t1-1),
                                      (Mass)masses.elementAt(t3-1));
              s1.visible = false;
              s1 = addNewSpring((Mass)masses.elementAt(t2-1),
                                      (Mass)masses.elementAt(t4-1));
              s1.visible = false;

            }else{
              //triangle
              addNewSpring((Mass)masses.elementAt(t1-1),
                                      (Mass)masses.elementAt(t2-1));
              addNewSpring((Mass)masses.elementAt(t3-1),
                                      (Mass)masses.elementAt(t2-1));
              addNewSpring((Mass)masses.elementAt(t3-1),
                                      (Mass)masses.elementAt(t1-1));
            }

          }

        }
      }
      //get each beginning word.
    }

    Spring addNewSpring(Mass m1, Mass m2){
      //find d
      double d=0;
      double x=0;
      double y=0;
      double z=0;
      x = m1.p.x-m2.p.x;
      y = m1.p.y-m2.p.y;
      z = m1.p.z-m2.p.z;
      x*=x;
      y*=y;
      z*=z;
      d = Math.sqrt(x+y+z);
      Spring s = new Spring(d,1000D,10000D,m1,m2);
      add(s);
      return s;
    }

  }

  String OBJFile(int i){// the letterforms.
    switch(i){
      case 97:return "v 1 0 1\nv 2 0 1\nv 1 0 2\nv 2 0 2\nv 2 1 1\nv 2 1 2\nv 1 1 1\nv 1 1 2\nv 3 0 1\nv 3 0 2\nv 3 1 1\nv 3 1 2\nv 0 1 1\nv 0 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 4 1 1\nv 4 1 2\nv 4 2 1\nv 4 2 2\nv 3 2 1\nv 3 2 2\nv 1 3 1\nv 1 3 2\nv 0 3 1\nv 0 3 2\nv 2 2 1\nv 2 2 2\nv 2 3 1\nv 2 3 2\nv 3 3 1\nv 3 3 2\nv 4 3 1\nv 4 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 4 4 1\nv 4 4 2\nv 3 4 1\nv 3 4 2\nv 1 5 1\nv 1 5 2\nv 0 5 1\nv 0 5 2\nv 4 5 1\nv 4 5 2\nv 3 5 1\nv 3 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 2 9\nf 4 10\nf 9 10\ninv\nf 2 10\ninv\nf 9 4\nf 9 11\nf 10 12\nf 11 12\ninv\nf 9 12\ninv\nf 11 10\nf 11 5\nf 12 6\ninv\nf 11 6\ninv\nf 5 12\ninv\nf 2 11\ninv\nf 4 12\ninv\nf 2 12\ninv\nf 11 4\ninv\nf 9 5\ninv\nf 10 6\ninv\nf 9 6\ninv\nf 5 10\nf 13 7\nf 14 8\nf 13 14\ninv\nf 13 8\ninv\nf 7 14\nf 7 15\nf 8 16\nf 15 16\ninv\nf 7 16\ninv\nf 15 8\nf 15 17\nf 16 18\nf 17 18\ninv\nf 15 18\ninv\nf 17 16\nf 17 13\nf 18 14\ninv\nf 17 14\ninv\nf 13 18\ninv\nf 13 15\ninv\nf 14 16\ninv\nf 13 16\ninv\nf 15 14\ninv\nf 7 17\ninv\nf 8 18\ninv\nf 7 18\ninv\nf 17 8\nf 11 19\nf 12 20\nf 19 20\ninv\nf 11 20\ninv\nf 19 12\nf 19 21\nf 20 22\nf 21 22\ninv\nf 19 22\ninv\nf 21 20\nf 21 23\nf 22 24\nf 23 24\ninv\nf 21 24\ninv\nf 23 22\nf 23 11\nf 24 12\ninv\nf 23 12\ninv\nf 11 24\ninv\nf 11 21\ninv\nf 12 22\ninv\nf 11 22\ninv\nf 21 12\ninv\nf 19 23\ninv\nf 20 24\ninv\nf 19 24\ninv\nf 23 20\nf 15 25\nf 16 26\nf 25 26\ninv\nf 15 26\ninv\nf 25 16\nf 25 27\nf 26 28\nf 27 28\ninv\nf 25 28\ninv\nf 27 26\nf 27 17\nf 28 18\ninv\nf 27 18\ninv\nf 17 28\ninv\nf 17 25\ninv\nf 18 26\ninv\nf 17 26\ninv\nf 25 18\ninv\nf 15 27\ninv\nf 16 28\ninv\nf 15 28\ninv\nf 27 16\nf 15 29\nf 16 30\nf 29 30\ninv\nf 15 30\ninv\nf 29 16\nf 29 31\nf 30 32\nf 31 32\ninv\nf 29 32\ninv\nf 31 30\nf 31 25\nf 32 26\ninv\nf 31 26\ninv\nf 25 32\ninv\nf 15 31\ninv\nf 16 32\ninv\nf 15 32\ninv\nf 31 16\ninv\nf 29 25\ninv\nf 30 26\ninv\nf 29 26\ninv\nf 25 30\nf 29 23\nf 30 24\ninv\nf 29 24\ninv\nf 23 30\nf 23 33\nf 24 34\nf 33 34\ninv\nf 23 34\ninv\nf 33 24\nf 33 31\nf 34 32\ninv\nf 33 32\ninv\nf 31 34\ninv\nf 29 33\ninv\nf 30 34\ninv\nf 29 34\ninv\nf 33 30\ninv\nf 23 31\ninv\nf 24 32\ninv\nf 23 32\ninv\nf 31 24\nf 21 35\nf 22 36\nf 35 36\ninv\nf 21 36\ninv\nf 35 22\nf 35 33\nf 36 34\ninv\nf 35 34\ninv\nf 33 36\ninv\nf 23 35\ninv\nf 24 36\ninv\nf 23 36\ninv\nf 35 24\ninv\nf 21 33\ninv\nf 22 34\ninv\nf 21 34\ninv\nf 33 22\nf 25 37\nf 26 38\nf 37 38\ninv\nf 25 38\ninv\nf 37 26\nf 37 39\nf 38 40\nf 39 40\ninv\nf 37 40\ninv\nf 39 38\nf 39 27\nf 40 28\ninv\nf 39 28\ninv\nf 27 40\ninv\nf 27 37\ninv\nf 28 38\ninv\nf 27 38\ninv\nf 37 28\ninv\nf 25 39\ninv\nf 26 40\ninv\nf 25 40\ninv\nf 39 26\nf 35 41\nf 36 42\nf 41 42\ninv\nf 35 42\ninv\nf 41 36\nf 41 43\nf 42 44\nf 43 44\ninv\nf 41 44\ninv\nf 43 42\nf 43 33\nf 44 34\ninv\nf 43 34\ninv\nf 33 44\ninv\nf 33 41\ninv\nf 34 42\ninv\nf 33 42\ninv\nf 41 34\ninv\nf 35 43\ninv\nf 36 44\ninv\nf 35 44\ninv\nf 43 36\nf 37 45\nf 38 46\nf 45 46\ninv\nf 37 46\ninv\nf 45 38\nf 45 47\nf 46 48\nf 47 48\ninv\nf 45 48\ninv\nf 47 46\nf 47 39\nf 48 40\ninv\nf 47 40\ninv\nf 39 48\ninv\nf 39 45\ninv\nf 40 46\ninv\nf 39 46\ninv\nf 45 40\ninv\nf 37 47\ninv\nf 38 48\ninv\nf 37 48\ninv\nf 47 38\nf 41 49\nf 42 50\nf 49 50\ninv\nf 41 50\ninv\nf 49 42\nf 49 51\nf 50 52\nf 51 52\ninv\nf 49 52\ninv\nf 51 50\nf 51 43\nf 52 44\ninv\nf 51 44\ninv\nf 43 52\ninv\nf 43 49\ninv\nf 44 50\ninv\nf 43 50\ninv\nf 49 44\ninv\nf 41 51\ninv\nf 42 52\ninv\nf 41 52\ninv\nf 51 42\n";
      case 98:return "v 0 0 1\nv 1 0 1\nv 0 0 2\nv 1 0 2\nv 1 1 1\nv 1 1 2\nv 0 1 1\nv 0 1 2\nv 2 0 1\nv 2 0 2\nv 2 1 1\nv 2 1 2\nv 3 0 1\nv 3 0 2\nv 3 1 1\nv 3 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 4 1 1\nv 4 1 2\nv 4 2 1\nv 4 2 2\nv 3 2 1\nv 3 2 2\nv 1 3 1\nv 1 3 2\nv 0 3 1\nv 0 3 2\nv 2 2 1\nv 2 2 2\nv 2 3 1\nv 2 3 2\nv 3 3 1\nv 3 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 4 3 1\nv 4 3 2\nv 4 4 1\nv 4 4 2\nv 3 4 1\nv 3 4 2\nv 1 5 1\nv 1 5 2\nv 0 5 1\nv 0 5 2\nv 2 4 1\nv 2 4 2\nv 2 5 1\nv 2 5 2\nv 3 5 1\nv 3 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 2 9\nf 4 10\nf 9 10\ninv\nf 2 10\ninv\nf 9 4\nf 9 11\nf 10 12\nf 11 12\ninv\nf 9 12\ninv\nf 11 10\nf 11 5\nf 12 6\ninv\nf 11 6\ninv\nf 5 12\ninv\nf 2 11\ninv\nf 4 12\ninv\nf 2 12\ninv\nf 11 4\ninv\nf 9 5\ninv\nf 10 6\ninv\nf 9 6\ninv\nf 5 10\nf 9 13\nf 10 14\nf 13 14\ninv\nf 9 14\ninv\nf 13 10\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 11\nf 16 12\ninv\nf 15 12\ninv\nf 11 16\ninv\nf 9 15\ninv\nf 10 16\ninv\nf 9 16\ninv\nf 15 10\ninv\nf 13 11\ninv\nf 14 12\ninv\nf 13 12\ninv\nf 11 14\nf 5 17\nf 6 18\nf 17 18\ninv\nf 5 18\ninv\nf 17 6\nf 17 19\nf 18 20\nf 19 20\ninv\nf 17 20\ninv\nf 19 18\nf 19 7\nf 20 8\ninv\nf 19 8\ninv\nf 7 20\ninv\nf 7 17\ninv\nf 8 18\ninv\nf 7 18\ninv\nf 17 8\ninv\nf 5 19\ninv\nf 6 20\ninv\nf 5 20\ninv\nf 19 6\nf 15 21\nf 16 22\nf 21 22\ninv\nf 15 22\ninv\nf 21 16\nf 21 23\nf 22 24\nf 23 24\ninv\nf 21 24\ninv\nf 23 22\nf 23 25\nf 24 26\nf 25 26\ninv\nf 23 26\ninv\nf 25 24\nf 25 15\nf 26 16\ninv\nf 25 16\ninv\nf 15 26\ninv\nf 15 23\ninv\nf 16 24\ninv\nf 15 24\ninv\nf 23 16\ninv\nf 21 25\ninv\nf 22 26\ninv\nf 21 26\ninv\nf 25 22\nf 17 27\nf 18 28\nf 27 28\ninv\nf 17 28\ninv\nf 27 18\nf 27 29\nf 28 30\nf 29 30\ninv\nf 27 30\ninv\nf 29 28\nf 29 19\nf 30 20\ninv\nf 29 20\ninv\nf 19 30\ninv\nf 19 27\ninv\nf 20 28\ninv\nf 19 28\ninv\nf 27 20\ninv\nf 17 29\ninv\nf 18 30\ninv\nf 17 30\ninv\nf 29 18\nf 17 31\nf 18 32\nf 31 32\ninv\nf 17 32\ninv\nf 31 18\nf 31 33\nf 32 34\nf 33 34\ninv\nf 31 34\ninv\nf 33 32\nf 33 27\nf 34 28\ninv\nf 33 28\ninv\nf 27 34\ninv\nf 17 33\ninv\nf 18 34\ninv\nf 17 34\ninv\nf 33 18\ninv\nf 31 27\ninv\nf 32 28\ninv\nf 31 28\ninv\nf 27 32\nf 31 25\nf 32 26\ninv\nf 31 26\ninv\nf 25 32\nf 25 35\nf 26 36\nf 35 36\ninv\nf 25 36\ninv\nf 35 26\nf 35 33\nf 36 34\ninv\nf 35 34\ninv\nf 33 36\ninv\nf 31 35\ninv\nf 32 36\ninv\nf 31 36\ninv\nf 35 32\ninv\nf 25 33\ninv\nf 26 34\ninv\nf 25 34\ninv\nf 33 26\nf 27 37\nf 28 38\nf 37 38\ninv\nf 27 38\ninv\nf 37 28\nf 37 39\nf 38 40\nf 39 40\ninv\nf 37 40\ninv\nf 39 38\nf 39 29\nf 40 30\ninv\nf 39 30\ninv\nf 29 40\ninv\nf 29 37\ninv\nf 30 38\ninv\nf 29 38\ninv\nf 37 30\ninv\nf 27 39\ninv\nf 28 40\ninv\nf 27 40\ninv\nf 39 28\nf 35 41\nf 36 42\nf 41 42\ninv\nf 35 42\ninv\nf 41 36\nf 41 43\nf 42 44\nf 43 44\ninv\nf 41 44\ninv\nf 43 42\nf 43 45\nf 44 46\nf 45 46\ninv\nf 43 46\ninv\nf 45 44\nf 45 35\nf 46 36\ninv\nf 45 36\ninv\nf 35 46\ninv\nf 35 43\ninv\nf 36 44\ninv\nf 35 44\ninv\nf 43 36\ninv\nf 41 45\ninv\nf 42 46\ninv\nf 41 46\ninv\nf 45 42\nf 37 47\nf 38 48\nf 47 48\ninv\nf 37 48\ninv\nf 47 38\nf 47 49\nf 48 50\nf 49 50\ninv\nf 47 50\ninv\nf 49 48\nf 49 39\nf 50 40\ninv\nf 49 40\ninv\nf 39 50\ninv\nf 39 47\ninv\nf 40 48\ninv\nf 39 48\ninv\nf 47 40\ninv\nf 37 49\ninv\nf 38 50\ninv\nf 37 50\ninv\nf 49 38\nf 37 51\nf 38 52\nf 51 52\ninv\nf 37 52\ninv\nf 51 38\nf 51 53\nf 52 54\nf 53 54\ninv\nf 51 54\ninv\nf 53 52\nf 53 47\nf 54 48\ninv\nf 53 48\ninv\nf 47 54\ninv\nf 37 53\ninv\nf 38 54\ninv\nf 37 54\ninv\nf 53 38\ninv\nf 51 47\ninv\nf 52 48\ninv\nf 51 48\ninv\nf 47 52\nf 51 45\nf 52 46\ninv\nf 51 46\ninv\nf 45 52\nf 45 55\nf 46 56\nf 55 56\ninv\nf 45 56\ninv\nf 55 46\nf 55 53\nf 56 54\ninv\nf 55 54\ninv\nf 53 56\ninv\nf 51 55\ninv\nf 52 56\ninv\nf 51 56\ninv\nf 55 52\ninv\nf 45 53\ninv\nf 46 54\ninv\nf 45 54\ninv\nf 53 46\n";
      case 99:return "v 1 0 1\nv 2 0 1\nv 1 0 2\nv 2 0 2\nv 2 1 1\nv 2 1 2\nv 1 1 1\nv 1 1 2\nv 3 0 1\nv 3 0 2\nv 3 1 1\nv 3 1 2\nv 0 1 1\nv 0 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 4 1 1\nv 4 1 2\nv 4 2 1\nv 4 2 2\nv 3 2 1\nv 3 2 2\nv 1 3 1\nv 1 3 2\nv 0 3 1\nv 0 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 3 3 1\nv 4 3 1\nv 3 3 2\nv 4 3 2\nv 4 4 1\nv 4 4 2\nv 3 4 1\nv 3 4 2\nv 2 4 1\nv 2 4 2\nv 2 5 1\nv 2 5 2\nv 1 5 1\nv 1 5 2\nv 3 5 1\nv 3 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 2 9\nf 4 10\nf 9 10\ninv\nf 2 10\ninv\nf 9 4\nf 9 11\nf 10 12\nf 11 12\ninv\nf 9 12\ninv\nf 11 10\nf 11 5\nf 12 6\ninv\nf 11 6\ninv\nf 5 12\ninv\nf 2 11\ninv\nf 4 12\ninv\nf 2 12\ninv\nf 11 4\ninv\nf 9 5\ninv\nf 10 6\ninv\nf 9 6\ninv\nf 5 10\nf 13 7\nf 14 8\nf 13 14\ninv\nf 13 8\ninv\nf 7 14\nf 7 15\nf 8 16\nf 15 16\ninv\nf 7 16\ninv\nf 15 8\nf 15 17\nf 16 18\nf 17 18\ninv\nf 15 18\ninv\nf 17 16\nf 17 13\nf 18 14\ninv\nf 17 14\ninv\nf 13 18\ninv\nf 13 15\ninv\nf 14 16\ninv\nf 13 16\ninv\nf 15 14\ninv\nf 7 17\ninv\nf 8 18\ninv\nf 7 18\ninv\nf 17 8\nf 11 19\nf 12 20\nf 19 20\ninv\nf 11 20\ninv\nf 19 12\nf 19 21\nf 20 22\nf 21 22\ninv\nf 19 22\ninv\nf 21 20\nf 21 23\nf 22 24\nf 23 24\ninv\nf 21 24\ninv\nf 23 22\nf 23 11\nf 24 12\ninv\nf 23 12\ninv\nf 11 24\ninv\nf 11 21\ninv\nf 12 22\ninv\nf 11 22\ninv\nf 21 12\ninv\nf 19 23\ninv\nf 20 24\ninv\nf 19 24\ninv\nf 23 20\nf 15 25\nf 16 26\nf 25 26\ninv\nf 15 26\ninv\nf 25 16\nf 25 27\nf 26 28\nf 27 28\ninv\nf 25 28\ninv\nf 27 26\nf 27 17\nf 28 18\ninv\nf 27 18\ninv\nf 17 28\ninv\nf 17 25\ninv\nf 18 26\ninv\nf 17 26\ninv\nf 25 18\ninv\nf 15 27\ninv\nf 16 28\ninv\nf 15 28\ninv\nf 27 16\nf 25 29\nf 26 30\nf 29 30\ninv\nf 25 30\ninv\nf 29 26\nf 29 31\nf 30 32\nf 31 32\ninv\nf 29 32\ninv\nf 31 30\nf 31 27\nf 32 28\ninv\nf 31 28\ninv\nf 27 32\ninv\nf 27 29\ninv\nf 28 30\ninv\nf 27 30\ninv\nf 29 28\ninv\nf 25 31\ninv\nf 26 32\ninv\nf 25 32\ninv\nf 31 26\nf 33 34\nf 35 36\nf 33 35\nf 34 36\ninv\nf 33 36\ninv\nf 34 35\nf 34 37\nf 36 38\nf 37 38\ninv\nf 34 38\ninv\nf 37 36\nf 37 39\nf 38 40\nf 39 40\ninv\nf 37 40\ninv\nf 39 38\nf 39 33\nf 40 35\ninv\nf 39 35\ninv\nf 33 40\ninv\nf 33 37\ninv\nf 35 38\ninv\nf 33 38\ninv\nf 37 35\ninv\nf 34 39\ninv\nf 36 40\ninv\nf 34 40\ninv\nf 39 36\nf 29 41\nf 30 42\nf 41 42\ninv\nf 29 42\ninv\nf 41 30\nf 41 43\nf 42 44\nf 43 44\ninv\nf 41 44\ninv\nf 43 42\nf 43 45\nf 44 46\nf 45 46\ninv\nf 43 46\ninv\nf 45 44\nf 45 29\nf 46 30\ninv\nf 45 30\ninv\nf 29 46\ninv\nf 29 43\ninv\nf 30 44\ninv\nf 29 44\ninv\nf 43 30\ninv\nf 41 45\ninv\nf 42 46\ninv\nf 41 46\ninv\nf 45 42\nf 41 39\nf 42 40\ninv\nf 41 40\ninv\nf 39 42\nf 39 47\nf 40 48\nf 47 48\ninv\nf 39 48\ninv\nf 47 40\nf 47 43\nf 48 44\ninv\nf 47 44\ninv\nf 43 48\ninv\nf 41 47\ninv\nf 42 48\ninv\nf 41 48\ninv\nf 47 42\ninv\nf 39 43\ninv\nf 40 44\ninv\nf 39 44\ninv\nf 43 40\n";
      case 100:return "v 0 0 1\nv 1 0 1\nv 0 0 2\nv 1 0 2\nv 1 1 1\nv 1 1 2\nv 0 1 1\nv 0 1 2\nv 2 0 1\nv 2 0 2\nv 2 1 1\nv 2 1 2\nv 3 0 1\nv 3 0 2\nv 3 1 1\nv 3 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 4 1 1\nv 4 1 2\nv 4 2 1\nv 4 2 2\nv 3 2 1\nv 3 2 2\nv 1 3 1\nv 1 3 2\nv 0 3 1\nv 0 3 2\nv 4 3 1\nv 4 3 2\nv 3 3 1\nv 3 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 4 4 1\nv 4 4 2\nv 3 4 1\nv 3 4 2\nv 1 5 1\nv 1 5 2\nv 0 5 1\nv 0 5 2\nv 2 4 1\nv 2 4 2\nv 2 5 1\nv 2 5 2\nv 3 5 1\nv 3 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 2 9\nf 4 10\nf 9 10\ninv\nf 2 10\ninv\nf 9 4\nf 9 11\nf 10 12\nf 11 12\ninv\nf 9 12\ninv\nf 11 10\nf 11 5\nf 12 6\ninv\nf 11 6\ninv\nf 5 12\ninv\nf 2 11\ninv\nf 4 12\ninv\nf 2 12\ninv\nf 11 4\ninv\nf 9 5\ninv\nf 10 6\ninv\nf 9 6\ninv\nf 5 10\nf 9 13\nf 10 14\nf 13 14\ninv\nf 9 14\ninv\nf 13 10\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 11\nf 16 12\ninv\nf 15 12\ninv\nf 11 16\ninv\nf 9 15\ninv\nf 10 16\ninv\nf 9 16\ninv\nf 15 10\ninv\nf 13 11\ninv\nf 14 12\ninv\nf 13 12\ninv\nf 11 14\nf 5 17\nf 6 18\nf 17 18\ninv\nf 5 18\ninv\nf 17 6\nf 17 19\nf 18 20\nf 19 20\ninv\nf 17 20\ninv\nf 19 18\nf 19 7\nf 20 8\ninv\nf 19 8\ninv\nf 7 20\ninv\nf 7 17\ninv\nf 8 18\ninv\nf 7 18\ninv\nf 17 8\ninv\nf 5 19\ninv\nf 6 20\ninv\nf 5 20\ninv\nf 19 6\nf 15 21\nf 16 22\nf 21 22\ninv\nf 15 22\ninv\nf 21 16\nf 21 23\nf 22 24\nf 23 24\ninv\nf 21 24\ninv\nf 23 22\nf 23 25\nf 24 26\nf 25 26\ninv\nf 23 26\ninv\nf 25 24\nf 25 15\nf 26 16\ninv\nf 25 16\ninv\nf 15 26\ninv\nf 15 23\ninv\nf 16 24\ninv\nf 15 24\ninv\nf 23 16\ninv\nf 21 25\ninv\nf 22 26\ninv\nf 21 26\ninv\nf 25 22\nf 17 27\nf 18 28\nf 27 28\ninv\nf 17 28\ninv\nf 27 18\nf 27 29\nf 28 30\nf 29 30\ninv\nf 27 30\ninv\nf 29 28\nf 29 19\nf 30 20\ninv\nf 29 20\ninv\nf 19 30\ninv\nf 19 27\ninv\nf 20 28\ninv\nf 19 28\ninv\nf 27 20\ninv\nf 17 29\ninv\nf 18 30\ninv\nf 17 30\ninv\nf 29 18\nf 23 31\nf 24 32\nf 31 32\ninv\nf 23 32\ninv\nf 31 24\nf 31 33\nf 32 34\nf 33 34\ninv\nf 31 34\ninv\nf 33 32\nf 33 25\nf 34 26\ninv\nf 33 26\ninv\nf 25 34\ninv\nf 25 31\ninv\nf 26 32\ninv\nf 25 32\ninv\nf 31 26\ninv\nf 23 33\ninv\nf 24 34\ninv\nf 23 34\ninv\nf 33 24\nf 27 35\nf 28 36\nf 35 36\ninv\nf 27 36\ninv\nf 35 28\nf 35 37\nf 36 38\nf 37 38\ninv\nf 35 38\ninv\nf 37 36\nf 37 29\nf 38 30\ninv\nf 37 30\ninv\nf 29 38\ninv\nf 29 35\ninv\nf 30 36\ninv\nf 29 36\ninv\nf 35 30\ninv\nf 27 37\ninv\nf 28 38\ninv\nf 27 38\ninv\nf 37 28\nf 31 39\nf 32 40\nf 39 40\ninv\nf 31 40\ninv\nf 39 32\nf 39 41\nf 40 42\nf 41 42\ninv\nf 39 42\ninv\nf 41 40\nf 41 33\nf 42 34\ninv\nf 41 34\ninv\nf 33 42\ninv\nf 33 39\ninv\nf 34 40\ninv\nf 33 40\ninv\nf 39 34\ninv\nf 31 41\ninv\nf 32 42\ninv\nf 31 42\ninv\nf 41 32\nf 35 43\nf 36 44\nf 43 44\ninv\nf 35 44\ninv\nf 43 36\nf 43 45\nf 44 46\nf 45 46\ninv\nf 43 46\ninv\nf 45 44\nf 45 37\nf 46 38\ninv\nf 45 38\ninv\nf 37 46\ninv\nf 37 43\ninv\nf 38 44\ninv\nf 37 44\ninv\nf 43 38\ninv\nf 35 45\ninv\nf 36 46\ninv\nf 35 46\ninv\nf 45 36\nf 35 47\nf 36 48\nf 47 48\ninv\nf 35 48\ninv\nf 47 36\nf 47 49\nf 48 50\nf 49 50\ninv\nf 47 50\ninv\nf 49 48\nf 49 43\nf 50 44\ninv\nf 49 44\ninv\nf 43 50\ninv\nf 35 49\ninv\nf 36 50\ninv\nf 35 50\ninv\nf 49 36\ninv\nf 47 43\ninv\nf 48 44\ninv\nf 47 44\ninv\nf 43 48\nf 47 41\nf 48 42\ninv\nf 47 42\ninv\nf 41 48\nf 41 51\nf 42 52\nf 51 52\ninv\nf 41 52\ninv\nf 51 42\nf 51 49\nf 52 50\ninv\nf 51 50\ninv\nf 49 52\ninv\nf 47 51\ninv\nf 48 52\ninv\nf 47 52\ninv\nf 51 48\ninv\nf 41 49\ninv\nf 42 50\ninv\nf 41 50\ninv\nf 49 42\n";
      case 101:return "v 0 0 1\nv 1 0 1\nv 0 0 2\nv 1 0 2\nv 1 1 1\nv 1 1 2\nv 0 1 1\nv 0 1 2\nv 2 0 1\nv 2 0 2\nv 2 1 1\nv 2 1 2\nv 3 0 1\nv 3 0 2\nv 3 1 1\nv 3 1 2\nv 4 0 1\nv 4 0 2\nv 4 1 1\nv 4 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 1 3 1\nv 1 3 2\nv 0 3 1\nv 0 3 2\nv 2 2 1\nv 2 2 2\nv 2 3 1\nv 2 3 2\nv 3 2 1\nv 3 2 2\nv 3 3 1\nv 3 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 1 5 1\nv 1 5 2\nv 0 5 1\nv 0 5 2\nv 2 4 1\nv 2 4 2\nv 2 5 1\nv 2 5 2\nv 3 4 1\nv 3 4 2\nv 3 5 1\nv 3 5 2\nv 4 4 1\nv 4 4 2\nv 4 5 1\nv 4 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 2 9\nf 4 10\nf 9 10\ninv\nf 2 10\ninv\nf 9 4\nf 9 11\nf 10 12\nf 11 12\ninv\nf 9 12\ninv\nf 11 10\nf 11 5\nf 12 6\ninv\nf 11 6\ninv\nf 5 12\ninv\nf 2 11\ninv\nf 4 12\ninv\nf 2 12\ninv\nf 11 4\ninv\nf 9 5\ninv\nf 10 6\ninv\nf 9 6\ninv\nf 5 10\nf 9 13\nf 10 14\nf 13 14\ninv\nf 9 14\ninv\nf 13 10\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 11\nf 16 12\ninv\nf 15 12\ninv\nf 11 16\ninv\nf 9 15\ninv\nf 10 16\ninv\nf 9 16\ninv\nf 15 10\ninv\nf 13 11\ninv\nf 14 12\ninv\nf 13 12\ninv\nf 11 14\nf 13 17\nf 14 18\nf 17 18\ninv\nf 13 18\ninv\nf 17 14\nf 17 19\nf 18 20\nf 19 20\ninv\nf 17 20\ninv\nf 19 18\nf 19 15\nf 20 16\ninv\nf 19 16\ninv\nf 15 20\ninv\nf 13 19\ninv\nf 14 20\ninv\nf 13 20\ninv\nf 19 14\ninv\nf 17 15\ninv\nf 18 16\ninv\nf 17 16\ninv\nf 15 18\nf 5 21\nf 6 22\nf 21 22\ninv\nf 5 22\ninv\nf 21 6\nf 21 23\nf 22 24\nf 23 24\ninv\nf 21 24\ninv\nf 23 22\nf 23 7\nf 24 8\ninv\nf 23 8\ninv\nf 7 24\ninv\nf 7 21\ninv\nf 8 22\ninv\nf 7 22\ninv\nf 21 8\ninv\nf 5 23\ninv\nf 6 24\ninv\nf 5 24\ninv\nf 23 6\nf 21 25\nf 22 26\nf 25 26\ninv\nf 21 26\ninv\nf 25 22\nf 25 27\nf 26 28\nf 27 28\ninv\nf 25 28\ninv\nf 27 26\nf 27 23\nf 28 24\ninv\nf 27 24\ninv\nf 23 28\ninv\nf 23 25\ninv\nf 24 26\ninv\nf 23 26\ninv\nf 25 24\ninv\nf 21 27\ninv\nf 22 28\ninv\nf 21 28\ninv\nf 27 22\nf 21 29\nf 22 30\nf 29 30\ninv\nf 21 30\ninv\nf 29 22\nf 29 31\nf 30 32\nf 31 32\ninv\nf 29 32\ninv\nf 31 30\nf 31 25\nf 32 26\ninv\nf 31 26\ninv\nf 25 32\ninv\nf 21 31\ninv\nf 22 32\ninv\nf 21 32\ninv\nf 31 22\ninv\nf 29 25\ninv\nf 30 26\ninv\nf 29 26\ninv\nf 25 30\nf 29 33\nf 30 34\nf 33 34\ninv\nf 29 34\ninv\nf 33 30\nf 33 35\nf 34 36\nf 35 36\ninv\nf 33 36\ninv\nf 35 34\nf 35 31\nf 36 32\ninv\nf 35 32\ninv\nf 31 36\ninv\nf 29 35\ninv\nf 30 36\ninv\nf 29 36\ninv\nf 35 30\ninv\nf 33 31\ninv\nf 34 32\ninv\nf 33 32\ninv\nf 31 34\nf 25 37\nf 26 38\nf 37 38\ninv\nf 25 38\ninv\nf 37 26\nf 37 39\nf 38 40\nf 39 40\ninv\nf 37 40\ninv\nf 39 38\nf 39 27\nf 40 28\ninv\nf 39 28\ninv\nf 27 40\ninv\nf 27 37\ninv\nf 28 38\ninv\nf 27 38\ninv\nf 37 28\ninv\nf 25 39\ninv\nf 26 40\ninv\nf 25 40\ninv\nf 39 26\nf 37 41\nf 38 42\nf 41 42\ninv\nf 37 42\ninv\nf 41 38\nf 41 43\nf 42 44\nf 43 44\ninv\nf 41 44\ninv\nf 43 42\nf 43 39\nf 44 40\ninv\nf 43 40\ninv\nf 39 44\ninv\nf 39 41\ninv\nf 40 42\ninv\nf 39 42\ninv\nf 41 40\ninv\nf 37 43\ninv\nf 38 44\ninv\nf 37 44\ninv\nf 43 38\nf 37 45\nf 38 46\nf 45 46\ninv\nf 37 46\ninv\nf 45 38\nf 45 47\nf 46 48\nf 47 48\ninv\nf 45 48\ninv\nf 47 46\nf 47 41\nf 48 42\ninv\nf 47 42\ninv\nf 41 48\ninv\nf 37 47\ninv\nf 38 48\ninv\nf 37 48\ninv\nf 47 38\ninv\nf 45 41\ninv\nf 46 42\ninv\nf 45 42\ninv\nf 41 46\nf 45 49\nf 46 50\nf 49 50\ninv\nf 45 50\ninv\nf 49 46\nf 49 51\nf 50 52\nf 51 52\ninv\nf 49 52\ninv\nf 51 50\nf 51 47\nf 52 48\ninv\nf 51 48\ninv\nf 47 52\ninv\nf 45 51\ninv\nf 46 52\ninv\nf 45 52\ninv\nf 51 46\ninv\nf 49 47\ninv\nf 50 48\ninv\nf 49 48\ninv\nf 47 50\nf 49 53\nf 50 54\nf 53 54\ninv\nf 49 54\ninv\nf 53 50\nf 53 55\nf 54 56\nf 55 56\ninv\nf 53 56\ninv\nf 55 54\nf 55 51\nf 56 52\ninv\nf 55 52\ninv\nf 51 56\ninv\nf 49 55\ninv\nf 50 56\ninv\nf 49 56\ninv\nf 55 50\ninv\nf 53 51\ninv\nf 54 52\ninv\nf 53 52\ninv\nf 51 54\n";
      case 102:return "v 0 0 1\nv 1 0 1\nv 0 0 2\nv 1 0 2\nv 1 1 1\nv 1 1 2\nv 0 1 1\nv 0 1 2\nv 2 0 1\nv 2 0 2\nv 2 1 1\nv 2 1 2\nv 3 0 1\nv 3 0 2\nv 3 1 1\nv 3 1 2\nv 4 0 1\nv 4 0 2\nv 4 1 1\nv 4 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 1 3 1\nv 1 3 2\nv 0 3 1\nv 0 3 2\nv 2 2 1\nv 2 2 2\nv 2 3 1\nv 2 3 2\nv 3 2 1\nv 3 2 2\nv 3 3 1\nv 3 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 1 5 1\nv 1 5 2\nv 0 5 1\nv 0 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 2 9\nf 4 10\nf 9 10\ninv\nf 2 10\ninv\nf 9 4\nf 9 11\nf 10 12\nf 11 12\ninv\nf 9 12\ninv\nf 11 10\nf 11 5\nf 12 6\ninv\nf 11 6\ninv\nf 5 12\ninv\nf 2 11\ninv\nf 4 12\ninv\nf 2 12\ninv\nf 11 4\ninv\nf 9 5\ninv\nf 10 6\ninv\nf 9 6\ninv\nf 5 10\nf 9 13\nf 10 14\nf 13 14\ninv\nf 9 14\ninv\nf 13 10\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 11\nf 16 12\ninv\nf 15 12\ninv\nf 11 16\ninv\nf 9 15\ninv\nf 10 16\ninv\nf 9 16\ninv\nf 15 10\ninv\nf 13 11\ninv\nf 14 12\ninv\nf 13 12\ninv\nf 11 14\nf 13 17\nf 14 18\nf 17 18\ninv\nf 13 18\ninv\nf 17 14\nf 17 19\nf 18 20\nf 19 20\ninv\nf 17 20\ninv\nf 19 18\nf 19 15\nf 20 16\ninv\nf 19 16\ninv\nf 15 20\ninv\nf 13 19\ninv\nf 14 20\ninv\nf 13 20\ninv\nf 19 14\ninv\nf 17 15\ninv\nf 18 16\ninv\nf 17 16\ninv\nf 15 18\nf 5 21\nf 6 22\nf 21 22\ninv\nf 5 22\ninv\nf 21 6\nf 21 23\nf 22 24\nf 23 24\ninv\nf 21 24\ninv\nf 23 22\nf 23 7\nf 24 8\ninv\nf 23 8\ninv\nf 7 24\ninv\nf 7 21\ninv\nf 8 22\ninv\nf 7 22\ninv\nf 21 8\ninv\nf 5 23\ninv\nf 6 24\ninv\nf 5 24\ninv\nf 23 6\nf 21 25\nf 22 26\nf 25 26\ninv\nf 21 26\ninv\nf 25 22\nf 25 27\nf 26 28\nf 27 28\ninv\nf 25 28\ninv\nf 27 26\nf 27 23\nf 28 24\ninv\nf 27 24\ninv\nf 23 28\ninv\nf 23 25\ninv\nf 24 26\ninv\nf 23 26\ninv\nf 25 24\ninv\nf 21 27\ninv\nf 22 28\ninv\nf 21 28\ninv\nf 27 22\nf 21 29\nf 22 30\nf 29 30\ninv\nf 21 30\ninv\nf 29 22\nf 29 31\nf 30 32\nf 31 32\ninv\nf 29 32\ninv\nf 31 30\nf 31 25\nf 32 26\ninv\nf 31 26\ninv\nf 25 32\ninv\nf 21 31\ninv\nf 22 32\ninv\nf 21 32\ninv\nf 31 22\ninv\nf 29 25\ninv\nf 30 26\ninv\nf 29 26\ninv\nf 25 30\nf 29 33\nf 30 34\nf 33 34\ninv\nf 29 34\ninv\nf 33 30\nf 33 35\nf 34 36\nf 35 36\ninv\nf 33 36\ninv\nf 35 34\nf 35 31\nf 36 32\ninv\nf 35 32\ninv\nf 31 36\ninv\nf 29 35\ninv\nf 30 36\ninv\nf 29 36\ninv\nf 35 30\ninv\nf 33 31\ninv\nf 34 32\ninv\nf 33 32\ninv\nf 31 34\nf 25 37\nf 26 38\nf 37 38\ninv\nf 25 38\ninv\nf 37 26\nf 37 39\nf 38 40\nf 39 40\ninv\nf 37 40\ninv\nf 39 38\nf 39 27\nf 40 28\ninv\nf 39 28\ninv\nf 27 40\ninv\nf 27 37\ninv\nf 28 38\ninv\nf 27 38\ninv\nf 37 28\ninv\nf 25 39\ninv\nf 26 40\ninv\nf 25 40\ninv\nf 39 26\nf 37 41\nf 38 42\nf 41 42\ninv\nf 37 42\ninv\nf 41 38\nf 41 43\nf 42 44\nf 43 44\ninv\nf 41 44\ninv\nf 43 42\nf 43 39\nf 44 40\ninv\nf 43 40\ninv\nf 39 44\ninv\nf 39 41\ninv\nf 40 42\ninv\nf 39 42\ninv\nf 41 40\ninv\nf 37 43\ninv\nf 38 44\ninv\nf 37 44\ninv\nf 43 38\n";
      case 103:return "v 1 0 1\nv 2 0 1\nv 1 0 2\nv 2 0 2\nv 2 1 1\nv 2 1 2\nv 1 1 1\nv 1 1 2\nv 3 0 1\nv 3 0 2\nv 3 1 1\nv 3 1 2\nv 4 0 1\nv 4 0 2\nv 4 1 1\nv 4 1 2\nv 0 1 1\nv 0 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 1 3 1\nv 1 3 2\nv 0 3 1\nv 0 3 2\nv 2 2 1\nv 3 2 1\nv 2 2 2\nv 3 2 2\nv 3 3 1\nv 3 3 2\nv 2 3 1\nv 2 3 2\nv 4 2 1\nv 4 2 2\nv 4 3 1\nv 4 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 4 4 1\nv 4 4 2\nv 3 4 1\nv 3 4 2\nv 2 4 1\nv 2 4 2\nv 2 5 1\nv 2 5 2\nv 1 5 1\nv 1 5 2\nv 3 5 1\nv 3 5 2\nv 4 5 1\nv 4 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 2 9\nf 4 10\nf 9 10\ninv\nf 2 10\ninv\nf 9 4\nf 9 11\nf 10 12\nf 11 12\ninv\nf 9 12\ninv\nf 11 10\nf 11 5\nf 12 6\ninv\nf 11 6\ninv\nf 5 12\ninv\nf 2 11\ninv\nf 4 12\ninv\nf 2 12\ninv\nf 11 4\ninv\nf 9 5\ninv\nf 10 6\ninv\nf 9 6\ninv\nf 5 10\nf 9 13\nf 10 14\nf 13 14\ninv\nf 9 14\ninv\nf 13 10\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 11\nf 16 12\ninv\nf 15 12\ninv\nf 11 16\ninv\nf 9 15\ninv\nf 10 16\ninv\nf 9 16\ninv\nf 15 10\ninv\nf 13 11\ninv\nf 14 12\ninv\nf 13 12\ninv\nf 11 14\nf 17 7\nf 18 8\nf 17 18\ninv\nf 17 8\ninv\nf 7 18\nf 7 19\nf 8 20\nf 19 20\ninv\nf 7 20\ninv\nf 19 8\nf 19 21\nf 20 22\nf 21 22\ninv\nf 19 22\ninv\nf 21 20\nf 21 17\nf 22 18\ninv\nf 21 18\ninv\nf 17 22\ninv\nf 17 19\ninv\nf 18 20\ninv\nf 17 20\ninv\nf 19 18\ninv\nf 7 21\ninv\nf 8 22\ninv\nf 7 22\ninv\nf 21 8\nf 19 23\nf 20 24\nf 23 24\ninv\nf 19 24\ninv\nf 23 20\nf 23 25\nf 24 26\nf 25 26\ninv\nf 23 26\ninv\nf 25 24\nf 25 21\nf 26 22\ninv\nf 25 22\ninv\nf 21 26\ninv\nf 21 23\ninv\nf 22 24\ninv\nf 21 24\ninv\nf 23 22\ninv\nf 19 25\ninv\nf 20 26\ninv\nf 19 26\ninv\nf 25 20\nf 27 28\nf 29 30\nf 27 29\nf 28 30\ninv\nf 27 30\ninv\nf 28 29\nf 28 31\nf 30 32\nf 31 32\ninv\nf 28 32\ninv\nf 31 30\nf 31 33\nf 32 34\nf 33 34\ninv\nf 31 34\ninv\nf 33 32\nf 33 27\nf 34 29\ninv\nf 33 29\ninv\nf 27 34\ninv\nf 27 31\ninv\nf 29 32\ninv\nf 27 32\ninv\nf 31 29\ninv\nf 28 33\ninv\nf 30 34\ninv\nf 28 34\ninv\nf 33 30\nf 28 35\nf 30 36\nf 35 36\ninv\nf 28 36\ninv\nf 35 30\nf 35 37\nf 36 38\nf 37 38\ninv\nf 35 38\ninv\nf 37 36\nf 37 31\nf 38 32\ninv\nf 37 32\ninv\nf 31 38\ninv\nf 28 37\ninv\nf 30 38\ninv\nf 28 38\ninv\nf 37 30\ninv\nf 35 31\ninv\nf 36 32\ninv\nf 35 32\ninv\nf 31 36\nf 23 39\nf 24 40\nf 39 40\ninv\nf 23 40\ninv\nf 39 24\nf 39 41\nf 40 42\nf 41 42\ninv\nf 39 42\ninv\nf 41 40\nf 41 25\nf 42 26\ninv\nf 41 26\ninv\nf 25 42\ninv\nf 25 39\ninv\nf 26 40\ninv\nf 25 40\ninv\nf 39 26\ninv\nf 23 41\ninv\nf 24 42\ninv\nf 23 42\ninv\nf 41 24\nf 37 43\nf 38 44\nf 43 44\ninv\nf 37 44\ninv\nf 43 38\nf 43 45\nf 44 46\nf 45 46\ninv\nf 43 46\ninv\nf 45 44\nf 45 31\nf 46 32\ninv\nf 45 32\ninv\nf 31 46\ninv\nf 31 43\ninv\nf 32 44\ninv\nf 31 44\ninv\nf 43 32\ninv\nf 37 45\ninv\nf 38 46\ninv\nf 37 46\ninv\nf 45 38\nf 39 47\nf 40 48\nf 47 48\ninv\nf 39 48\ninv\nf 47 40\nf 47 49\nf 48 50\nf 49 50\ninv\nf 47 50\ninv\nf 49 48\nf 49 51\nf 50 52\nf 51 52\ninv\nf 49 52\ninv\nf 51 50\nf 51 39\nf 52 40\ninv\nf 51 40\ninv\nf 39 52\ninv\nf 39 49\ninv\nf 40 50\ninv\nf 39 50\ninv\nf 49 40\ninv\nf 47 51\ninv\nf 48 52\ninv\nf 47 52\ninv\nf 51 48\nf 47 45\nf 48 46\ninv\nf 47 46\ninv\nf 45 48\nf 45 53\nf 46 54\nf 53 54\ninv\nf 45 54\ninv\nf 53 46\nf 53 49\nf 54 50\ninv\nf 53 50\ninv\nf 49 54\ninv\nf 47 53\ninv\nf 48 54\ninv\nf 47 54\ninv\nf 53 48\ninv\nf 45 49\ninv\nf 46 50\ninv\nf 45 50\ninv\nf 49 46\nf 43 55\nf 44 56\nf 55 56\ninv\nf 43 56\ninv\nf 55 44\nf 55 53\nf 56 54\ninv\nf 55 54\ninv\nf 53 56\ninv\nf 45 55\ninv\nf 46 56\ninv\nf 45 56\ninv\nf 55 46\ninv\nf 43 53\ninv\nf 44 54\ninv\nf 43 54\ninv\nf 53 44\n";
      case 104:return "v 0 0 1\nv 1 0 1\nv 0 0 2\nv 1 0 2\nv 1 1 1\nv 1 1 2\nv 0 1 1\nv 0 1 2\nv 3 0 1\nv 4 0 1\nv 3 0 2\nv 4 0 2\nv 4 1 1\nv 4 1 2\nv 3 1 1\nv 3 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 4 2 1\nv 4 2 2\nv 3 2 1\nv 3 2 2\nv 1 3 1\nv 1 3 2\nv 0 3 1\nv 0 3 2\nv 2 2 1\nv 2 2 2\nv 2 3 1\nv 2 3 2\nv 3 3 1\nv 3 3 2\nv 4 3 1\nv 4 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 4 4 1\nv 4 4 2\nv 3 4 1\nv 3 4 2\nv 1 5 1\nv 1 5 2\nv 0 5 1\nv 0 5 2\nv 4 5 1\nv 4 5 2\nv 3 5 1\nv 3 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 9 10\nf 11 12\nf 9 11\nf 10 12\ninv\nf 9 12\ninv\nf 10 11\nf 10 13\nf 12 14\nf 13 14\ninv\nf 10 14\ninv\nf 13 12\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 9\nf 16 11\ninv\nf 15 11\ninv\nf 9 16\ninv\nf 9 13\ninv\nf 11 14\ninv\nf 9 14\ninv\nf 13 11\ninv\nf 10 15\ninv\nf 12 16\ninv\nf 10 16\ninv\nf 15 12\nf 5 17\nf 6 18\nf 17 18\ninv\nf 5 18\ninv\nf 17 6\nf 17 19\nf 18 20\nf 19 20\ninv\nf 17 20\ninv\nf 19 18\nf 19 7\nf 20 8\ninv\nf 19 8\ninv\nf 7 20\ninv\nf 7 17\ninv\nf 8 18\ninv\nf 7 18\ninv\nf 17 8\ninv\nf 5 19\ninv\nf 6 20\ninv\nf 5 20\ninv\nf 19 6\nf 13 21\nf 14 22\nf 21 22\ninv\nf 13 22\ninv\nf 21 14\nf 21 23\nf 22 24\nf 23 24\ninv\nf 21 24\ninv\nf 23 22\nf 23 15\nf 24 16\ninv\nf 23 16\ninv\nf 15 24\ninv\nf 15 21\ninv\nf 16 22\ninv\nf 15 22\ninv\nf 21 16\ninv\nf 13 23\ninv\nf 14 24\ninv\nf 13 24\ninv\nf 23 14\nf 17 25\nf 18 26\nf 25 26\ninv\nf 17 26\ninv\nf 25 18\nf 25 27\nf 26 28\nf 27 28\ninv\nf 25 28\ninv\nf 27 26\nf 27 19\nf 28 20\ninv\nf 27 20\ninv\nf 19 28\ninv\nf 19 25\ninv\nf 20 26\ninv\nf 19 26\ninv\nf 25 20\ninv\nf 17 27\ninv\nf 18 28\ninv\nf 17 28\ninv\nf 27 18\nf 17 29\nf 18 30\nf 29 30\ninv\nf 17 30\ninv\nf 29 18\nf 29 31\nf 30 32\nf 31 32\ninv\nf 29 32\ninv\nf 31 30\nf 31 25\nf 32 26\ninv\nf 31 26\ninv\nf 25 32\ninv\nf 17 31\ninv\nf 18 32\ninv\nf 17 32\ninv\nf 31 18\ninv\nf 29 25\ninv\nf 30 26\ninv\nf 29 26\ninv\nf 25 30\nf 29 23\nf 30 24\ninv\nf 29 24\ninv\nf 23 30\nf 23 33\nf 24 34\nf 33 34\ninv\nf 23 34\ninv\nf 33 24\nf 33 31\nf 34 32\ninv\nf 33 32\ninv\nf 31 34\ninv\nf 29 33\ninv\nf 30 34\ninv\nf 29 34\ninv\nf 33 30\ninv\nf 23 31\ninv\nf 24 32\ninv\nf 23 32\ninv\nf 31 24\nf 21 35\nf 22 36\nf 35 36\ninv\nf 21 36\ninv\nf 35 22\nf 35 33\nf 36 34\ninv\nf 35 34\ninv\nf 33 36\ninv\nf 23 35\ninv\nf 24 36\ninv\nf 23 36\ninv\nf 35 24\ninv\nf 21 33\ninv\nf 22 34\ninv\nf 21 34\ninv\nf 33 22\nf 25 37\nf 26 38\nf 37 38\ninv\nf 25 38\ninv\nf 37 26\nf 37 39\nf 38 40\nf 39 40\ninv\nf 37 40\ninv\nf 39 38\nf 39 27\nf 40 28\ninv\nf 39 28\ninv\nf 27 40\ninv\nf 27 37\ninv\nf 28 38\ninv\nf 27 38\ninv\nf 37 28\ninv\nf 25 39\ninv\nf 26 40\ninv\nf 25 40\ninv\nf 39 26\nf 35 41\nf 36 42\nf 41 42\ninv\nf 35 42\ninv\nf 41 36\nf 41 43\nf 42 44\nf 43 44\ninv\nf 41 44\ninv\nf 43 42\nf 43 33\nf 44 34\ninv\nf 43 34\ninv\nf 33 44\ninv\nf 33 41\ninv\nf 34 42\ninv\nf 33 42\ninv\nf 41 34\ninv\nf 35 43\ninv\nf 36 44\ninv\nf 35 44\ninv\nf 43 36\nf 37 45\nf 38 46\nf 45 46\ninv\nf 37 46\ninv\nf 45 38\nf 45 47\nf 46 48\nf 47 48\ninv\nf 45 48\ninv\nf 47 46\nf 47 39\nf 48 40\ninv\nf 47 40\ninv\nf 39 48\ninv\nf 39 45\ninv\nf 40 46\ninv\nf 39 46\ninv\nf 45 40\ninv\nf 37 47\ninv\nf 38 48\ninv\nf 37 48\ninv\nf 47 38\nf 41 49\nf 42 50\nf 49 50\ninv\nf 41 50\ninv\nf 49 42\nf 49 51\nf 50 52\nf 51 52\ninv\nf 49 52\ninv\nf 51 50\nf 51 43\nf 52 44\ninv\nf 51 44\ninv\nf 43 52\ninv\nf 43 49\ninv\nf 44 50\ninv\nf 43 50\ninv\nf 49 44\ninv\nf 41 51\ninv\nf 42 52\ninv\nf 41 52\ninv\nf 51 42\n";
      case 105:return "v 0 0 1\nv 1 0 1\nv 0 0 2\nv 1 0 2\nv 1 1 1\nv 1 1 2\nv 0 1 1\nv 0 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 1 3 1\nv 1 3 2\nv 0 3 1\nv 0 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 1 5 1\nv 1 5 2\nv 0 5 1\nv 0 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 5 9\nf 6 10\nf 9 10\ninv\nf 5 10\ninv\nf 9 6\nf 9 11\nf 10 12\nf 11 12\ninv\nf 9 12\ninv\nf 11 10\nf 11 7\nf 12 8\ninv\nf 11 8\ninv\nf 7 12\ninv\nf 7 9\ninv\nf 8 10\ninv\nf 7 10\ninv\nf 9 8\ninv\nf 5 11\ninv\nf 6 12\ninv\nf 5 12\ninv\nf 11 6\nf 9 13\nf 10 14\nf 13 14\ninv\nf 9 14\ninv\nf 13 10\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 11\nf 16 12\ninv\nf 15 12\ninv\nf 11 16\ninv\nf 11 13\ninv\nf 12 14\ninv\nf 11 14\ninv\nf 13 12\ninv\nf 9 15\ninv\nf 10 16\ninv\nf 9 16\ninv\nf 15 10\nf 13 17\nf 14 18\nf 17 18\ninv\nf 13 18\ninv\nf 17 14\nf 17 19\nf 18 20\nf 19 20\ninv\nf 17 20\ninv\nf 19 18\nf 19 15\nf 20 16\ninv\nf 19 16\ninv\nf 15 20\ninv\nf 15 17\ninv\nf 16 18\ninv\nf 15 18\ninv\nf 17 16\ninv\nf 13 19\ninv\nf 14 20\ninv\nf 13 20\ninv\nf 19 14\nf 17 21\nf 18 22\nf 21 22\ninv\nf 17 22\ninv\nf 21 18\nf 21 23\nf 22 24\nf 23 24\ninv\nf 21 24\ninv\nf 23 22\nf 23 19\nf 24 20\ninv\nf 23 20\ninv\nf 19 24\ninv\nf 19 21\ninv\nf 20 22\ninv\nf 19 22\ninv\nf 21 20\ninv\nf 17 23\ninv\nf 18 24\ninv\nf 17 24\ninv\nf 23 18\n";
      case 106:return "v 2 0 1\nv 3 0 1\nv 2 0 2\nv 3 0 2\nv 3 1 1\nv 3 1 2\nv 2 1 1\nv 2 1 2\nv 3 2 1\nv 3 2 2\nv 2 2 1\nv 2 2 2\nv 3 3 1\nv 3 3 2\nv 2 3 1\nv 2 3 2\nv 3 4 1\nv 3 4 2\nv 2 4 1\nv 2 4 2\nv 0 4 1\nv 1 4 1\nv 0 4 2\nv 1 4 2\nv 1 5 1\nv 1 5 2\nv 0 5 1\nv 0 5 2\nv 2 5 1\nv 2 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 5 9\nf 6 10\nf 9 10\ninv\nf 5 10\ninv\nf 9 6\nf 9 11\nf 10 12\nf 11 12\ninv\nf 9 12\ninv\nf 11 10\nf 11 7\nf 12 8\ninv\nf 11 8\ninv\nf 7 12\ninv\nf 7 9\ninv\nf 8 10\ninv\nf 7 10\ninv\nf 9 8\ninv\nf 5 11\ninv\nf 6 12\ninv\nf 5 12\ninv\nf 11 6\nf 9 13\nf 10 14\nf 13 14\ninv\nf 9 14\ninv\nf 13 10\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 11\nf 16 12\ninv\nf 15 12\ninv\nf 11 16\ninv\nf 11 13\ninv\nf 12 14\ninv\nf 11 14\ninv\nf 13 12\ninv\nf 9 15\ninv\nf 10 16\ninv\nf 9 16\ninv\nf 15 10\nf 13 17\nf 14 18\nf 17 18\ninv\nf 13 18\ninv\nf 17 14\nf 17 19\nf 18 20\nf 19 20\ninv\nf 17 20\ninv\nf 19 18\nf 19 15\nf 20 16\ninv\nf 19 16\ninv\nf 15 20\ninv\nf 15 17\ninv\nf 16 18\ninv\nf 15 18\ninv\nf 17 16\ninv\nf 13 19\ninv\nf 14 20\ninv\nf 13 20\ninv\nf 19 14\nf 21 22\nf 23 24\nf 21 23\nf 22 24\ninv\nf 21 24\ninv\nf 22 23\nf 22 25\nf 24 26\nf 25 26\ninv\nf 22 26\ninv\nf 25 24\nf 25 27\nf 26 28\nf 27 28\ninv\nf 25 28\ninv\nf 27 26\nf 27 21\nf 28 23\ninv\nf 27 23\ninv\nf 21 28\ninv\nf 21 25\ninv\nf 23 26\ninv\nf 21 26\ninv\nf 25 23\ninv\nf 22 27\ninv\nf 24 28\ninv\nf 22 28\ninv\nf 27 24\nf 22 19\nf 24 20\ninv\nf 22 20\ninv\nf 19 24\nf 19 29\nf 20 30\nf 29 30\ninv\nf 19 30\ninv\nf 29 20\nf 29 25\nf 30 26\ninv\nf 29 26\ninv\nf 25 30\ninv\nf 22 29\ninv\nf 24 30\ninv\nf 22 30\ninv\nf 29 24\ninv\nf 19 25\ninv\nf 20 26\ninv\nf 19 26\ninv\nf 25 20\n";
      case 107:return "v 0 0 1\nv 1 0 1\nv 0 0 2\nv 1 0 2\nv 1 1 1\nv 1 1 2\nv 0 1 1\nv 0 1 2\nv 3 0 1\nv 4 0 1\nv 3 0 2\nv 4 0 2\nv 4 1 1\nv 4 1 2\nv 3 1 1\nv 3 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 2 1 1\nv 2 1 2\nv 3 2 1\nv 3 2 2\nv 2 2 1\nv 2 2 2\nv 1 3 1\nv 1 3 2\nv 0 3 1\nv 0 3 2\nv 2 3 1\nv 2 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 3 3 1\nv 3 3 2\nv 3 4 1\nv 3 4 2\nv 2 4 1\nv 2 4 2\nv 1 5 1\nv 1 5 2\nv 0 5 1\nv 0 5 2\nv 4 4 1\nv 4 4 2\nv 4 5 1\nv 4 5 2\nv 3 5 1\nv 3 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 9 10\nf 11 12\nf 9 11\nf 10 12\ninv\nf 9 12\ninv\nf 10 11\nf 10 13\nf 12 14\nf 13 14\ninv\nf 10 14\ninv\nf 13 12\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 9\nf 16 11\ninv\nf 15 11\ninv\nf 9 16\ninv\nf 9 13\ninv\nf 11 14\ninv\nf 9 14\ninv\nf 13 11\ninv\nf 10 15\ninv\nf 12 16\ninv\nf 10 16\ninv\nf 15 12\nf 5 17\nf 6 18\nf 17 18\ninv\nf 5 18\ninv\nf 17 6\nf 17 19\nf 18 20\nf 19 20\ninv\nf 17 20\ninv\nf 19 18\nf 19 7\nf 20 8\ninv\nf 19 8\ninv\nf 7 20\ninv\nf 7 17\ninv\nf 8 18\ninv\nf 7 18\ninv\nf 17 8\ninv\nf 5 19\ninv\nf 6 20\ninv\nf 5 20\ninv\nf 19 6\nf 21 15\nf 22 16\nf 21 22\ninv\nf 21 16\ninv\nf 15 22\nf 15 23\nf 16 24\nf 23 24\ninv\nf 15 24\ninv\nf 23 16\nf 23 25\nf 24 26\nf 25 26\ninv\nf 23 26\ninv\nf 25 24\nf 25 21\nf 26 22\ninv\nf 25 22\ninv\nf 21 26\ninv\nf 21 23\ninv\nf 22 24\ninv\nf 21 24\ninv\nf 23 22\ninv\nf 15 25\ninv\nf 16 26\ninv\nf 15 26\ninv\nf 25 16\nf 17 27\nf 18 28\nf 27 28\ninv\nf 17 28\ninv\nf 27 18\nf 27 29\nf 28 30\nf 29 30\ninv\nf 27 30\ninv\nf 29 28\nf 29 19\nf 30 20\ninv\nf 29 20\ninv\nf 19 30\ninv\nf 19 27\ninv\nf 20 28\ninv\nf 19 28\ninv\nf 27 20\ninv\nf 17 29\ninv\nf 18 30\ninv\nf 17 30\ninv\nf 29 18\nf 17 25\nf 18 26\ninv\nf 17 26\ninv\nf 25 18\nf 25 31\nf 26 32\nf 31 32\ninv\nf 25 32\ninv\nf 31 26\nf 31 27\nf 32 28\ninv\nf 31 28\ninv\nf 27 32\ninv\nf 17 31\ninv\nf 18 32\ninv\nf 17 32\ninv\nf 31 18\ninv\nf 25 27\ninv\nf 26 28\ninv\nf 25 28\ninv\nf 27 26\nf 27 33\nf 28 34\nf 33 34\ninv\nf 27 34\ninv\nf 33 28\nf 33 35\nf 34 36\nf 35 36\ninv\nf 33 36\ninv\nf 35 34\nf 35 29\nf 36 30\ninv\nf 35 30\ninv\nf 29 36\ninv\nf 29 33\ninv\nf 30 34\ninv\nf 29 34\ninv\nf 33 30\ninv\nf 27 35\ninv\nf 28 36\ninv\nf 27 36\ninv\nf 35 28\nf 31 37\nf 32 38\nf 37 38\ninv\nf 31 38\ninv\nf 37 32\nf 37 39\nf 38 40\nf 39 40\ninv\nf 37 40\ninv\nf 39 38\nf 39 41\nf 40 42\nf 41 42\ninv\nf 39 42\ninv\nf 41 40\nf 41 31\nf 42 32\ninv\nf 41 32\ninv\nf 31 42\ninv\nf 31 39\ninv\nf 32 40\ninv\nf 31 40\ninv\nf 39 32\ninv\nf 37 41\ninv\nf 38 42\ninv\nf 37 42\ninv\nf 41 38\nf 33 43\nf 34 44\nf 43 44\ninv\nf 33 44\ninv\nf 43 34\nf 43 45\nf 44 46\nf 45 46\ninv\nf 43 46\ninv\nf 45 44\nf 45 35\nf 46 36\ninv\nf 45 36\ninv\nf 35 46\ninv\nf 35 43\ninv\nf 36 44\ninv\nf 35 44\ninv\nf 43 36\ninv\nf 33 45\ninv\nf 34 46\ninv\nf 33 46\ninv\nf 45 34\nf 39 47\nf 40 48\nf 47 48\ninv\nf 39 48\ninv\nf 47 40\nf 47 49\nf 48 50\nf 49 50\ninv\nf 47 50\ninv\nf 49 48\nf 49 51\nf 50 52\nf 51 52\ninv\nf 49 52\ninv\nf 51 50\nf 51 39\nf 52 40\ninv\nf 51 40\ninv\nf 39 52\ninv\nf 39 49\ninv\nf 40 50\ninv\nf 39 50\ninv\nf 49 40\ninv\nf 47 51\ninv\nf 48 52\ninv\nf 47 52\ninv\nf 51 48\n";
      case 108:return "v 0 0 1\nv 1 0 1\nv 0 0 2\nv 1 0 2\nv 1 1 1\nv 1 1 2\nv 0 1 1\nv 0 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 1 3 1\nv 1 3 2\nv 0 3 1\nv 0 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 1 5 1\nv 1 5 2\nv 0 5 1\nv 0 5 2\nv 2 4 1\nv 2 4 2\nv 2 5 1\nv 2 5 2\nv 3 4 1\nv 3 4 2\nv 3 5 1\nv 3 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 5 9\nf 6 10\nf 9 10\ninv\nf 5 10\ninv\nf 9 6\nf 9 11\nf 10 12\nf 11 12\ninv\nf 9 12\ninv\nf 11 10\nf 11 7\nf 12 8\ninv\nf 11 8\ninv\nf 7 12\ninv\nf 7 9\ninv\nf 8 10\ninv\nf 7 10\ninv\nf 9 8\ninv\nf 5 11\ninv\nf 6 12\ninv\nf 5 12\ninv\nf 11 6\nf 9 13\nf 10 14\nf 13 14\ninv\nf 9 14\ninv\nf 13 10\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 11\nf 16 12\ninv\nf 15 12\ninv\nf 11 16\ninv\nf 11 13\ninv\nf 12 14\ninv\nf 11 14\ninv\nf 13 12\ninv\nf 9 15\ninv\nf 10 16\ninv\nf 9 16\ninv\nf 15 10\nf 13 17\nf 14 18\nf 17 18\ninv\nf 13 18\ninv\nf 17 14\nf 17 19\nf 18 20\nf 19 20\ninv\nf 17 20\ninv\nf 19 18\nf 19 15\nf 20 16\ninv\nf 19 16\ninv\nf 15 20\ninv\nf 15 17\ninv\nf 16 18\ninv\nf 15 18\ninv\nf 17 16\ninv\nf 13 19\ninv\nf 14 20\ninv\nf 13 20\ninv\nf 19 14\nf 17 21\nf 18 22\nf 21 22\ninv\nf 17 22\ninv\nf 21 18\nf 21 23\nf 22 24\nf 23 24\ninv\nf 21 24\ninv\nf 23 22\nf 23 19\nf 24 20\ninv\nf 23 20\ninv\nf 19 24\ninv\nf 19 21\ninv\nf 20 22\ninv\nf 19 22\ninv\nf 21 20\ninv\nf 17 23\ninv\nf 18 24\ninv\nf 17 24\ninv\nf 23 18\nf 17 25\nf 18 26\nf 25 26\ninv\nf 17 26\ninv\nf 25 18\nf 25 27\nf 26 28\nf 27 28\ninv\nf 25 28\ninv\nf 27 26\nf 27 21\nf 28 22\ninv\nf 27 22\ninv\nf 21 28\ninv\nf 17 27\ninv\nf 18 28\ninv\nf 17 28\ninv\nf 27 18\ninv\nf 25 21\ninv\nf 26 22\ninv\nf 25 22\ninv\nf 21 26\nf 25 29\nf 26 30\nf 29 30\ninv\nf 25 30\ninv\nf 29 26\nf 29 31\nf 30 32\nf 31 32\ninv\nf 29 32\ninv\nf 31 30\nf 31 27\nf 32 28\ninv\nf 31 28\ninv\nf 27 32\ninv\nf 25 31\ninv\nf 26 32\ninv\nf 25 32\ninv\nf 31 26\ninv\nf 29 27\ninv\nf 30 28\ninv\nf 29 28\ninv\nf 27 30\n";
      case 109:return "v 0 0 1\nv 1 0 1\nv 0 0 2\nv 1 0 2\nv 1 1 1\nv 1 1 2\nv 0 1 1\nv 0 1 2\nv 4 0 1\nv 5 0 1\nv 4 0 2\nv 5 0 2\nv 5 1 1\nv 5 1 2\nv 4 1 1\nv 4 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 2 1 1\nv 2 1 2\nv 2 2 1\nv 2 2 2\nv 3 1 1\nv 3 1 2\nv 4 2 1\nv 4 2 2\nv 3 2 1\nv 3 2 2\nv 5 2 1\nv 5 2 2\nv 1 3 1\nv 1 3 2\nv 0 3 1\nv 0 3 2\nv 3 3 1\nv 3 3 2\nv 2 3 1\nv 2 3 2\nv 5 3 1\nv 5 3 2\nv 4 3 1\nv 4 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 5 4 1\nv 5 4 2\nv 4 4 1\nv 4 4 2\nv 1 5 1\nv 1 5 2\nv 0 5 1\nv 0 5 2\nv 5 5 1\nv 5 5 2\nv 4 5 1\nv 4 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 9 10\nf 11 12\nf 9 11\nf 10 12\ninv\nf 9 12\ninv\nf 10 11\nf 10 13\nf 12 14\nf 13 14\ninv\nf 10 14\ninv\nf 13 12\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 9\nf 16 11\ninv\nf 15 11\ninv\nf 9 16\ninv\nf 9 13\ninv\nf 11 14\ninv\nf 9 14\ninv\nf 13 11\ninv\nf 10 15\ninv\nf 12 16\ninv\nf 10 16\ninv\nf 15 12\nf 5 17\nf 6 18\nf 17 18\ninv\nf 5 18\ninv\nf 17 6\nf 17 19\nf 18 20\nf 19 20\ninv\nf 17 20\ninv\nf 19 18\nf 19 7\nf 20 8\ninv\nf 19 8\ninv\nf 7 20\ninv\nf 7 17\ninv\nf 8 18\ninv\nf 7 18\ninv\nf 17 8\ninv\nf 5 19\ninv\nf 6 20\ninv\nf 5 20\ninv\nf 19 6\nf 5 21\nf 6 22\nf 21 22\ninv\nf 5 22\ninv\nf 21 6\nf 21 23\nf 22 24\nf 23 24\ninv\nf 21 24\ninv\nf 23 22\nf 23 17\nf 24 18\ninv\nf 23 18\ninv\nf 17 24\ninv\nf 5 23\ninv\nf 6 24\ninv\nf 5 24\ninv\nf 23 6\ninv\nf 21 17\ninv\nf 22 18\ninv\nf 21 18\ninv\nf 17 22\nf 25 15\nf 26 16\nf 25 26\ninv\nf 25 16\ninv\nf 15 26\nf 15 27\nf 16 28\nf 27 28\ninv\nf 15 28\ninv\nf 27 16\nf 27 29\nf 28 30\nf 29 30\ninv\nf 27 30\ninv\nf 29 28\nf 29 25\nf 30 26\ninv\nf 29 26\ninv\nf 25 30\ninv\nf 25 27\ninv\nf 26 28\ninv\nf 25 28\ninv\nf 27 26\ninv\nf 15 29\ninv\nf 16 30\ninv\nf 15 30\ninv\nf 29 16\nf 13 31\nf 14 32\nf 31 32\ninv\nf 13 32\ninv\nf 31 14\nf 31 27\nf 32 28\ninv\nf 31 28\ninv\nf 27 32\ninv\nf 15 31\ninv\nf 16 32\ninv\nf 15 32\ninv\nf 31 16\ninv\nf 13 27\ninv\nf 14 28\ninv\nf 13 28\ninv\nf 27 14\nf 17 33\nf 18 34\nf 33 34\ninv\nf 17 34\ninv\nf 33 18\nf 33 35\nf 34 36\nf 35 36\ninv\nf 33 36\ninv\nf 35 34\nf 35 19\nf 36 20\ninv\nf 35 20\ninv\nf 19 36\ninv\nf 19 33\ninv\nf 20 34\ninv\nf 19 34\ninv\nf 33 20\ninv\nf 17 35\ninv\nf 18 36\ninv\nf 17 36\ninv\nf 35 18\nf 23 29\nf 24 30\ninv\nf 23 30\ninv\nf 29 24\nf 29 37\nf 30 38\nf 37 38\ninv\nf 29 38\ninv\nf 37 30\nf 37 39\nf 38 40\nf 39 40\ninv\nf 37 40\ninv\nf 39 38\nf 39 23\nf 40 24\ninv\nf 39 24\ninv\nf 23 40\ninv\nf 23 37\ninv\nf 24 38\ninv\nf 23 38\ninv\nf 37 24\ninv\nf 29 39\ninv\nf 30 40\ninv\nf 29 40\ninv\nf 39 30\nf 31 41\nf 32 42\nf 41 42\ninv\nf 31 42\ninv\nf 41 32\nf 41 43\nf 42 44\nf 43 44\ninv\nf 41 44\ninv\nf 43 42\nf 43 27\nf 44 28\ninv\nf 43 28\ninv\nf 27 44\ninv\nf 27 41\ninv\nf 28 42\ninv\nf 27 42\ninv\nf 41 28\ninv\nf 31 43\ninv\nf 32 44\ninv\nf 31 44\ninv\nf 43 32\nf 33 45\nf 34 46\nf 45 46\ninv\nf 33 46\ninv\nf 45 34\nf 45 47\nf 46 48\nf 47 48\ninv\nf 45 48\ninv\nf 47 46\nf 47 35\nf 48 36\ninv\nf 47 36\ninv\nf 35 48\ninv\nf 35 45\ninv\nf 36 46\ninv\nf 35 46\ninv\nf 45 36\ninv\nf 33 47\ninv\nf 34 48\ninv\nf 33 48\ninv\nf 47 34\nf 41 49\nf 42 50\nf 49 50\ninv\nf 41 50\ninv\nf 49 42\nf 49 51\nf 50 52\nf 51 52\ninv\nf 49 52\ninv\nf 51 50\nf 51 43\nf 52 44\ninv\nf 51 44\ninv\nf 43 52\ninv\nf 43 49\ninv\nf 44 50\ninv\nf 43 50\ninv\nf 49 44\ninv\nf 41 51\ninv\nf 42 52\ninv\nf 41 52\ninv\nf 51 42\nf 45 53\nf 46 54\nf 53 54\ninv\nf 45 54\ninv\nf 53 46\nf 53 55\nf 54 56\nf 55 56\ninv\nf 53 56\ninv\nf 55 54\nf 55 47\nf 56 48\ninv\nf 55 48\ninv\nf 47 56\ninv\nf 47 53\ninv\nf 48 54\ninv\nf 47 54\ninv\nf 53 48\ninv\nf 45 55\ninv\nf 46 56\ninv\nf 45 56\ninv\nf 55 46\nf 49 57\nf 50 58\nf 57 58\ninv\nf 49 58\ninv\nf 57 50\nf 57 59\nf 58 60\nf 59 60\ninv\nf 57 60\ninv\nf 59 58\nf 59 51\nf 60 52\ninv\nf 59 52\ninv\nf 51 60\ninv\nf 51 57\ninv\nf 52 58\ninv\nf 51 58\ninv\nf 57 52\ninv\nf 49 59\ninv\nf 50 60\ninv\nf 49 60\ninv\nf 59 50\n";
      case 110:return "v 0 0 1\nv 1 0 1\nv 0 0 2\nv 1 0 2\nv 1 1 1\nv 1 1 2\nv 0 1 1\nv 0 1 2\nv 3 0 1\nv 4 0 1\nv 3 0 2\nv 4 0 2\nv 4 1 1\nv 4 1 2\nv 3 1 1\nv 3 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 2 1 1\nv 2 1 2\nv 2 2 1\nv 2 2 2\nv 4 2 1\nv 4 2 2\nv 3 2 1\nv 3 2 2\nv 1 3 1\nv 1 3 2\nv 0 3 1\nv 0 3 2\nv 3 3 1\nv 3 3 2\nv 2 3 1\nv 2 3 2\nv 4 3 1\nv 4 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 4 4 1\nv 4 4 2\nv 3 4 1\nv 3 4 2\nv 1 5 1\nv 1 5 2\nv 0 5 1\nv 0 5 2\nv 4 5 1\nv 4 5 2\nv 3 5 1\nv 3 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 9 10\nf 11 12\nf 9 11\nf 10 12\ninv\nf 9 12\ninv\nf 10 11\nf 10 13\nf 12 14\nf 13 14\ninv\nf 10 14\ninv\nf 13 12\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 9\nf 16 11\ninv\nf 15 11\ninv\nf 9 16\ninv\nf 9 13\ninv\nf 11 14\ninv\nf 9 14\ninv\nf 13 11\ninv\nf 10 15\ninv\nf 12 16\ninv\nf 10 16\ninv\nf 15 12\nf 5 17\nf 6 18\nf 17 18\ninv\nf 5 18\ninv\nf 17 6\nf 17 19\nf 18 20\nf 19 20\ninv\nf 17 20\ninv\nf 19 18\nf 19 7\nf 20 8\ninv\nf 19 8\ninv\nf 7 20\ninv\nf 7 17\ninv\nf 8 18\ninv\nf 7 18\ninv\nf 17 8\ninv\nf 5 19\ninv\nf 6 20\ninv\nf 5 20\ninv\nf 19 6\nf 5 21\nf 6 22\nf 21 22\ninv\nf 5 22\ninv\nf 21 6\nf 21 23\nf 22 24\nf 23 24\ninv\nf 21 24\ninv\nf 23 22\nf 23 17\nf 24 18\ninv\nf 23 18\ninv\nf 17 24\ninv\nf 5 23\ninv\nf 6 24\ninv\nf 5 24\ninv\nf 23 6\ninv\nf 21 17\ninv\nf 22 18\ninv\nf 21 18\ninv\nf 17 22\nf 13 25\nf 14 26\nf 25 26\ninv\nf 13 26\ninv\nf 25 14\nf 25 27\nf 26 28\nf 27 28\ninv\nf 25 28\ninv\nf 27 26\nf 27 15\nf 28 16\ninv\nf 27 16\ninv\nf 15 28\ninv\nf 15 25\ninv\nf 16 26\ninv\nf 15 26\ninv\nf 25 16\ninv\nf 13 27\ninv\nf 14 28\ninv\nf 13 28\ninv\nf 27 14\nf 17 29\nf 18 30\nf 29 30\ninv\nf 17 30\ninv\nf 29 18\nf 29 31\nf 30 32\nf 31 32\ninv\nf 29 32\ninv\nf 31 30\nf 31 19\nf 32 20\ninv\nf 31 20\ninv\nf 19 32\ninv\nf 19 29\ninv\nf 20 30\ninv\nf 19 30\ninv\nf 29 20\ninv\nf 17 31\ninv\nf 18 32\ninv\nf 17 32\ninv\nf 31 18\nf 23 27\nf 24 28\ninv\nf 23 28\ninv\nf 27 24\nf 27 33\nf 28 34\nf 33 34\ninv\nf 27 34\ninv\nf 33 28\nf 33 35\nf 34 36\nf 35 36\ninv\nf 33 36\ninv\nf 35 34\nf 35 23\nf 36 24\ninv\nf 35 24\ninv\nf 23 36\ninv\nf 23 33\ninv\nf 24 34\ninv\nf 23 34\ninv\nf 33 24\ninv\nf 27 35\ninv\nf 28 36\ninv\nf 27 36\ninv\nf 35 28\nf 25 37\nf 26 38\nf 37 38\ninv\nf 25 38\ninv\nf 37 26\nf 37 33\nf 38 34\ninv\nf 37 34\ninv\nf 33 38\ninv\nf 27 37\ninv\nf 28 38\ninv\nf 27 38\ninv\nf 37 28\ninv\nf 25 33\ninv\nf 26 34\ninv\nf 25 34\ninv\nf 33 26\nf 29 39\nf 30 40\nf 39 40\ninv\nf 29 40\ninv\nf 39 30\nf 39 41\nf 40 42\nf 41 42\ninv\nf 39 42\ninv\nf 41 40\nf 41 31\nf 42 32\ninv\nf 41 32\ninv\nf 31 42\ninv\nf 31 39\ninv\nf 32 40\ninv\nf 31 40\ninv\nf 39 32\ninv\nf 29 41\ninv\nf 30 42\ninv\nf 29 42\ninv\nf 41 30\nf 37 43\nf 38 44\nf 43 44\ninv\nf 37 44\ninv\nf 43 38\nf 43 45\nf 44 46\nf 45 46\ninv\nf 43 46\ninv\nf 45 44\nf 45 33\nf 46 34\ninv\nf 45 34\ninv\nf 33 46\ninv\nf 33 43\ninv\nf 34 44\ninv\nf 33 44\ninv\nf 43 34\ninv\nf 37 45\ninv\nf 38 46\ninv\nf 37 46\ninv\nf 45 38\nf 39 47\nf 40 48\nf 47 48\ninv\nf 39 48\ninv\nf 47 40\nf 47 49\nf 48 50\nf 49 50\ninv\nf 47 50\ninv\nf 49 48\nf 49 41\nf 50 42\ninv\nf 49 42\ninv\nf 41 50\ninv\nf 41 47\ninv\nf 42 48\ninv\nf 41 48\ninv\nf 47 42\ninv\nf 39 49\ninv\nf 40 50\ninv\nf 39 50\ninv\nf 49 40\nf 43 51\nf 44 52\nf 51 52\ninv\nf 43 52\ninv\nf 51 44\nf 51 53\nf 52 54\nf 53 54\ninv\nf 51 54\ninv\nf 53 52\nf 53 45\nf 54 46\ninv\nf 53 46\ninv\nf 45 54\ninv\nf 45 51\ninv\nf 46 52\ninv\nf 45 52\ninv\nf 51 46\ninv\nf 43 53\ninv\nf 44 54\ninv\nf 43 54\ninv\nf 53 44\n";
      case 111:return "v 1 0 1\nv 2 0 1\nv 1 0 2\nv 2 0 2\nv 2 1 1\nv 2 1 2\nv 1 1 1\nv 1 1 2\nv 3 0 1\nv 3 0 2\nv 3 1 1\nv 3 1 2\nv 0 1 1\nv 0 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 4 1 1\nv 4 1 2\nv 4 2 1\nv 4 2 2\nv 3 2 1\nv 3 2 2\nv 1 3 1\nv 1 3 2\nv 0 3 1\nv 0 3 2\nv 4 3 1\nv 4 3 2\nv 3 3 1\nv 3 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 4 4 1\nv 4 4 2\nv 3 4 1\nv 3 4 2\nv 2 4 1\nv 2 4 2\nv 2 5 1\nv 2 5 2\nv 1 5 1\nv 1 5 2\nv 3 5 1\nv 3 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 2 9\nf 4 10\nf 9 10\ninv\nf 2 10\ninv\nf 9 4\nf 9 11\nf 10 12\nf 11 12\ninv\nf 9 12\ninv\nf 11 10\nf 11 5\nf 12 6\ninv\nf 11 6\ninv\nf 5 12\ninv\nf 2 11\ninv\nf 4 12\ninv\nf 2 12\ninv\nf 11 4\ninv\nf 9 5\ninv\nf 10 6\ninv\nf 9 6\ninv\nf 5 10\nf 13 7\nf 14 8\nf 13 14\ninv\nf 13 8\ninv\nf 7 14\nf 7 15\nf 8 16\nf 15 16\ninv\nf 7 16\ninv\nf 15 8\nf 15 17\nf 16 18\nf 17 18\ninv\nf 15 18\ninv\nf 17 16\nf 17 13\nf 18 14\ninv\nf 17 14\ninv\nf 13 18\ninv\nf 13 15\ninv\nf 14 16\ninv\nf 13 16\ninv\nf 15 14\ninv\nf 7 17\ninv\nf 8 18\ninv\nf 7 18\ninv\nf 17 8\nf 11 19\nf 12 20\nf 19 20\ninv\nf 11 20\ninv\nf 19 12\nf 19 21\nf 20 22\nf 21 22\ninv\nf 19 22\ninv\nf 21 20\nf 21 23\nf 22 24\nf 23 24\ninv\nf 21 24\ninv\nf 23 22\nf 23 11\nf 24 12\ninv\nf 23 12\ninv\nf 11 24\ninv\nf 11 21\ninv\nf 12 22\ninv\nf 11 22\ninv\nf 21 12\ninv\nf 19 23\ninv\nf 20 24\ninv\nf 19 24\ninv\nf 23 20\nf 15 25\nf 16 26\nf 25 26\ninv\nf 15 26\ninv\nf 25 16\nf 25 27\nf 26 28\nf 27 28\ninv\nf 25 28\ninv\nf 27 26\nf 27 17\nf 28 18\ninv\nf 27 18\ninv\nf 17 28\ninv\nf 17 25\ninv\nf 18 26\ninv\nf 17 26\ninv\nf 25 18\ninv\nf 15 27\ninv\nf 16 28\ninv\nf 15 28\ninv\nf 27 16\nf 21 29\nf 22 30\nf 29 30\ninv\nf 21 30\ninv\nf 29 22\nf 29 31\nf 30 32\nf 31 32\ninv\nf 29 32\ninv\nf 31 30\nf 31 23\nf 32 24\ninv\nf 31 24\ninv\nf 23 32\ninv\nf 23 29\ninv\nf 24 30\ninv\nf 23 30\ninv\nf 29 24\ninv\nf 21 31\ninv\nf 22 32\ninv\nf 21 32\ninv\nf 31 22\nf 25 33\nf 26 34\nf 33 34\ninv\nf 25 34\ninv\nf 33 26\nf 33 35\nf 34 36\nf 35 36\ninv\nf 33 36\ninv\nf 35 34\nf 35 27\nf 36 28\ninv\nf 35 28\ninv\nf 27 36\ninv\nf 27 33\ninv\nf 28 34\ninv\nf 27 34\ninv\nf 33 28\ninv\nf 25 35\ninv\nf 26 36\ninv\nf 25 36\ninv\nf 35 26\nf 29 37\nf 30 38\nf 37 38\ninv\nf 29 38\ninv\nf 37 30\nf 37 39\nf 38 40\nf 39 40\ninv\nf 37 40\ninv\nf 39 38\nf 39 31\nf 40 32\ninv\nf 39 32\ninv\nf 31 40\ninv\nf 31 37\ninv\nf 32 38\ninv\nf 31 38\ninv\nf 37 32\ninv\nf 29 39\ninv\nf 30 40\ninv\nf 29 40\ninv\nf 39 30\nf 33 41\nf 34 42\nf 41 42\ninv\nf 33 42\ninv\nf 41 34\nf 41 43\nf 42 44\nf 43 44\ninv\nf 41 44\ninv\nf 43 42\nf 43 45\nf 44 46\nf 45 46\ninv\nf 43 46\ninv\nf 45 44\nf 45 33\nf 46 34\ninv\nf 45 34\ninv\nf 33 46\ninv\nf 33 43\ninv\nf 34 44\ninv\nf 33 44\ninv\nf 43 34\ninv\nf 41 45\ninv\nf 42 46\ninv\nf 41 46\ninv\nf 45 42\nf 41 39\nf 42 40\ninv\nf 41 40\ninv\nf 39 42\nf 39 47\nf 40 48\nf 47 48\ninv\nf 39 48\ninv\nf 47 40\nf 47 43\nf 48 44\ninv\nf 47 44\ninv\nf 43 48\ninv\nf 41 47\ninv\nf 42 48\ninv\nf 41 48\ninv\nf 47 42\ninv\nf 39 43\ninv\nf 40 44\ninv\nf 39 44\ninv\nf 43 40\n";
      case 112:return "v 0 0 1\nv 1 0 1\nv 0 0 2\nv 1 0 2\nv 1 1 1\nv 1 1 2\nv 0 1 1\nv 0 1 2\nv 2 0 1\nv 2 0 2\nv 2 1 1\nv 2 1 2\nv 3 0 1\nv 3 0 2\nv 3 1 1\nv 3 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 4 1 1\nv 4 1 2\nv 4 2 1\nv 4 2 2\nv 3 2 1\nv 3 2 2\nv 1 3 1\nv 1 3 2\nv 0 3 1\nv 0 3 2\nv 2 2 1\nv 2 2 2\nv 2 3 1\nv 2 3 2\nv 3 3 1\nv 3 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 1 5 1\nv 1 5 2\nv 0 5 1\nv 0 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 2 9\nf 4 10\nf 9 10\ninv\nf 2 10\ninv\nf 9 4\nf 9 11\nf 10 12\nf 11 12\ninv\nf 9 12\ninv\nf 11 10\nf 11 5\nf 12 6\ninv\nf 11 6\ninv\nf 5 12\ninv\nf 2 11\ninv\nf 4 12\ninv\nf 2 12\ninv\nf 11 4\ninv\nf 9 5\ninv\nf 10 6\ninv\nf 9 6\ninv\nf 5 10\nf 9 13\nf 10 14\nf 13 14\ninv\nf 9 14\ninv\nf 13 10\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 11\nf 16 12\ninv\nf 15 12\ninv\nf 11 16\ninv\nf 9 15\ninv\nf 10 16\ninv\nf 9 16\ninv\nf 15 10\ninv\nf 13 11\ninv\nf 14 12\ninv\nf 13 12\ninv\nf 11 14\nf 5 17\nf 6 18\nf 17 18\ninv\nf 5 18\ninv\nf 17 6\nf 17 19\nf 18 20\nf 19 20\ninv\nf 17 20\ninv\nf 19 18\nf 19 7\nf 20 8\ninv\nf 19 8\ninv\nf 7 20\ninv\nf 7 17\ninv\nf 8 18\ninv\nf 7 18\ninv\nf 17 8\ninv\nf 5 19\ninv\nf 6 20\ninv\nf 5 20\ninv\nf 19 6\nf 15 21\nf 16 22\nf 21 22\ninv\nf 15 22\ninv\nf 21 16\nf 21 23\nf 22 24\nf 23 24\ninv\nf 21 24\ninv\nf 23 22\nf 23 25\nf 24 26\nf 25 26\ninv\nf 23 26\ninv\nf 25 24\nf 25 15\nf 26 16\ninv\nf 25 16\ninv\nf 15 26\ninv\nf 15 23\ninv\nf 16 24\ninv\nf 15 24\ninv\nf 23 16\ninv\nf 21 25\ninv\nf 22 26\ninv\nf 21 26\ninv\nf 25 22\nf 17 27\nf 18 28\nf 27 28\ninv\nf 17 28\ninv\nf 27 18\nf 27 29\nf 28 30\nf 29 30\ninv\nf 27 30\ninv\nf 29 28\nf 29 19\nf 30 20\ninv\nf 29 20\ninv\nf 19 30\ninv\nf 19 27\ninv\nf 20 28\ninv\nf 19 28\ninv\nf 27 20\ninv\nf 17 29\ninv\nf 18 30\ninv\nf 17 30\ninv\nf 29 18\nf 17 31\nf 18 32\nf 31 32\ninv\nf 17 32\ninv\nf 31 18\nf 31 33\nf 32 34\nf 33 34\ninv\nf 31 34\ninv\nf 33 32\nf 33 27\nf 34 28\ninv\nf 33 28\ninv\nf 27 34\ninv\nf 17 33\ninv\nf 18 34\ninv\nf 17 34\ninv\nf 33 18\ninv\nf 31 27\ninv\nf 32 28\ninv\nf 31 28\ninv\nf 27 32\nf 31 25\nf 32 26\ninv\nf 31 26\ninv\nf 25 32\nf 25 35\nf 26 36\nf 35 36\ninv\nf 25 36\ninv\nf 35 26\nf 35 33\nf 36 34\ninv\nf 35 34\ninv\nf 33 36\ninv\nf 31 35\ninv\nf 32 36\ninv\nf 31 36\ninv\nf 35 32\ninv\nf 25 33\ninv\nf 26 34\ninv\nf 25 34\ninv\nf 33 26\nf 27 37\nf 28 38\nf 37 38\ninv\nf 27 38\ninv\nf 37 28\nf 37 39\nf 38 40\nf 39 40\ninv\nf 37 40\ninv\nf 39 38\nf 39 29\nf 40 30\ninv\nf 39 30\ninv\nf 29 40\ninv\nf 29 37\ninv\nf 30 38\ninv\nf 29 38\ninv\nf 37 30\ninv\nf 27 39\ninv\nf 28 40\ninv\nf 27 40\ninv\nf 39 28\nf 37 41\nf 38 42\nf 41 42\ninv\nf 37 42\ninv\nf 41 38\nf 41 43\nf 42 44\nf 43 44\ninv\nf 41 44\ninv\nf 43 42\nf 43 39\nf 44 40\ninv\nf 43 40\ninv\nf 39 44\ninv\nf 39 41\ninv\nf 40 42\ninv\nf 39 42\ninv\nf 41 40\ninv\nf 37 43\ninv\nf 38 44\ninv\nf 37 44\ninv\nf 43 38\n";
      case 113:return "v 1 0 1\nv 2 0 1\nv 1 0 2\nv 2 0 2\nv 2 1 1\nv 2 1 2\nv 1 1 1\nv 1 1 2\nv 3 0 1\nv 3 0 2\nv 3 1 1\nv 3 1 2\nv 0 1 1\nv 0 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 4 1 1\nv 4 1 2\nv 4 2 1\nv 4 2 2\nv 3 2 1\nv 3 2 2\nv 1 3 1\nv 1 3 2\nv 0 3 1\nv 0 3 2\nv 4 3 1\nv 4 3 2\nv 3 3 1\nv 3 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 4 4 1\nv 4 4 2\nv 3 4 1\nv 3 4 2\nv 2 4 1\nv 2 4 2\nv 2 5 1\nv 2 5 2\nv 1 5 1\nv 1 5 2\nv 3 5 1\nv 3 5 2\nv 4 5 1\nv 4 5 2\nv 4 6 1\nv 4 6 2\nv 3 6 1\nv 3 6 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 2 9\nf 4 10\nf 9 10\ninv\nf 2 10\ninv\nf 9 4\nf 9 11\nf 10 12\nf 11 12\ninv\nf 9 12\ninv\nf 11 10\nf 11 5\nf 12 6\ninv\nf 11 6\ninv\nf 5 12\ninv\nf 2 11\ninv\nf 4 12\ninv\nf 2 12\ninv\nf 11 4\ninv\nf 9 5\ninv\nf 10 6\ninv\nf 9 6\ninv\nf 5 10\nf 13 7\nf 14 8\nf 13 14\ninv\nf 13 8\ninv\nf 7 14\nf 7 15\nf 8 16\nf 15 16\ninv\nf 7 16\ninv\nf 15 8\nf 15 17\nf 16 18\nf 17 18\ninv\nf 15 18\ninv\nf 17 16\nf 17 13\nf 18 14\ninv\nf 17 14\ninv\nf 13 18\ninv\nf 13 15\ninv\nf 14 16\ninv\nf 13 16\ninv\nf 15 14\ninv\nf 7 17\ninv\nf 8 18\ninv\nf 7 18\ninv\nf 17 8\nf 11 19\nf 12 20\nf 19 20\ninv\nf 11 20\ninv\nf 19 12\nf 19 21\nf 20 22\nf 21 22\ninv\nf 19 22\ninv\nf 21 20\nf 21 23\nf 22 24\nf 23 24\ninv\nf 21 24\ninv\nf 23 22\nf 23 11\nf 24 12\ninv\nf 23 12\ninv\nf 11 24\ninv\nf 11 21\ninv\nf 12 22\ninv\nf 11 22\ninv\nf 21 12\ninv\nf 19 23\ninv\nf 20 24\ninv\nf 19 24\ninv\nf 23 20\nf 15 25\nf 16 26\nf 25 26\ninv\nf 15 26\ninv\nf 25 16\nf 25 27\nf 26 28\nf 27 28\ninv\nf 25 28\ninv\nf 27 26\nf 27 17\nf 28 18\ninv\nf 27 18\ninv\nf 17 28\ninv\nf 17 25\ninv\nf 18 26\ninv\nf 17 26\ninv\nf 25 18\ninv\nf 15 27\ninv\nf 16 28\ninv\nf 15 28\ninv\nf 27 16\nf 21 29\nf 22 30\nf 29 30\ninv\nf 21 30\ninv\nf 29 22\nf 29 31\nf 30 32\nf 31 32\ninv\nf 29 32\ninv\nf 31 30\nf 31 23\nf 32 24\ninv\nf 31 24\ninv\nf 23 32\ninv\nf 23 29\ninv\nf 24 30\ninv\nf 23 30\ninv\nf 29 24\ninv\nf 21 31\ninv\nf 22 32\ninv\nf 21 32\ninv\nf 31 22\nf 25 33\nf 26 34\nf 33 34\ninv\nf 25 34\ninv\nf 33 26\nf 33 35\nf 34 36\nf 35 36\ninv\nf 33 36\ninv\nf 35 34\nf 35 27\nf 36 28\ninv\nf 35 28\ninv\nf 27 36\ninv\nf 27 33\ninv\nf 28 34\ninv\nf 27 34\ninv\nf 33 28\ninv\nf 25 35\ninv\nf 26 36\ninv\nf 25 36\ninv\nf 35 26\nf 29 37\nf 30 38\nf 37 38\ninv\nf 29 38\ninv\nf 37 30\nf 37 39\nf 38 40\nf 39 40\ninv\nf 37 40\ninv\nf 39 38\nf 39 31\nf 40 32\ninv\nf 39 32\ninv\nf 31 40\ninv\nf 31 37\ninv\nf 32 38\ninv\nf 31 38\ninv\nf 37 32\ninv\nf 29 39\ninv\nf 30 40\ninv\nf 29 40\ninv\nf 39 30\nf 33 41\nf 34 42\nf 41 42\ninv\nf 33 42\ninv\nf 41 34\nf 41 43\nf 42 44\nf 43 44\ninv\nf 41 44\ninv\nf 43 42\nf 43 45\nf 44 46\nf 45 46\ninv\nf 43 46\ninv\nf 45 44\nf 45 33\nf 46 34\ninv\nf 45 34\ninv\nf 33 46\ninv\nf 33 43\ninv\nf 34 44\ninv\nf 33 44\ninv\nf 43 34\ninv\nf 41 45\ninv\nf 42 46\ninv\nf 41 46\ninv\nf 45 42\nf 41 39\nf 42 40\ninv\nf 41 40\ninv\nf 39 42\nf 39 47\nf 40 48\nf 47 48\ninv\nf 39 48\ninv\nf 47 40\nf 47 43\nf 48 44\ninv\nf 47 44\ninv\nf 43 48\ninv\nf 41 47\ninv\nf 42 48\ninv\nf 41 48\ninv\nf 47 42\ninv\nf 39 43\ninv\nf 40 44\ninv\nf 39 44\ninv\nf 43 40\nf 47 49\nf 48 50\nf 49 50\ninv\nf 47 50\ninv\nf 49 48\nf 49 51\nf 50 52\nf 51 52\ninv\nf 49 52\ninv\nf 51 50\nf 51 53\nf 52 54\nf 53 54\ninv\nf 51 54\ninv\nf 53 52\nf 53 47\nf 54 48\ninv\nf 53 48\ninv\nf 47 54\ninv\nf 47 51\ninv\nf 48 52\ninv\nf 47 52\ninv\nf 51 48\ninv\nf 49 53\ninv\nf 50 54\ninv\nf 49 54\ninv\nf 53 50\n";
      case 114:return "v 0 0 1\nv 1 0 1\nv 0 0 2\nv 1 0 2\nv 1 1 1\nv 1 1 2\nv 0 1 1\nv 0 1 2\nv 2 0 1\nv 2 0 2\nv 2 1 1\nv 2 1 2\nv 3 0 1\nv 3 0 2\nv 3 1 1\nv 3 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 4 1 1\nv 4 1 2\nv 4 2 1\nv 4 2 2\nv 3 2 1\nv 3 2 2\nv 1 3 1\nv 1 3 2\nv 0 3 1\nv 0 3 2\nv 2 2 1\nv 2 2 2\nv 2 3 1\nv 2 3 2\nv 3 3 1\nv 3 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 4 3 1\nv 4 3 2\nv 4 4 1\nv 4 4 2\nv 3 4 1\nv 3 4 2\nv 1 5 1\nv 1 5 2\nv 0 5 1\nv 0 5 2\nv 4 5 1\nv 4 5 2\nv 3 5 1\nv 3 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 2 9\nf 4 10\nf 9 10\ninv\nf 2 10\ninv\nf 9 4\nf 9 11\nf 10 12\nf 11 12\ninv\nf 9 12\ninv\nf 11 10\nf 11 5\nf 12 6\ninv\nf 11 6\ninv\nf 5 12\ninv\nf 2 11\ninv\nf 4 12\ninv\nf 2 12\ninv\nf 11 4\ninv\nf 9 5\ninv\nf 10 6\ninv\nf 9 6\ninv\nf 5 10\nf 9 13\nf 10 14\nf 13 14\ninv\nf 9 14\ninv\nf 13 10\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 11\nf 16 12\ninv\nf 15 12\ninv\nf 11 16\ninv\nf 9 15\ninv\nf 10 16\ninv\nf 9 16\ninv\nf 15 10\ninv\nf 13 11\ninv\nf 14 12\ninv\nf 13 12\ninv\nf 11 14\nf 5 17\nf 6 18\nf 17 18\ninv\nf 5 18\ninv\nf 17 6\nf 17 19\nf 18 20\nf 19 20\ninv\nf 17 20\ninv\nf 19 18\nf 19 7\nf 20 8\ninv\nf 19 8\ninv\nf 7 20\ninv\nf 7 17\ninv\nf 8 18\ninv\nf 7 18\ninv\nf 17 8\ninv\nf 5 19\ninv\nf 6 20\ninv\nf 5 20\ninv\nf 19 6\nf 15 21\nf 16 22\nf 21 22\ninv\nf 15 22\ninv\nf 21 16\nf 21 23\nf 22 24\nf 23 24\ninv\nf 21 24\ninv\nf 23 22\nf 23 25\nf 24 26\nf 25 26\ninv\nf 23 26\ninv\nf 25 24\nf 25 15\nf 26 16\ninv\nf 25 16\ninv\nf 15 26\ninv\nf 15 23\ninv\nf 16 24\ninv\nf 15 24\ninv\nf 23 16\ninv\nf 21 25\ninv\nf 22 26\ninv\nf 21 26\ninv\nf 25 22\nf 17 27\nf 18 28\nf 27 28\ninv\nf 17 28\ninv\nf 27 18\nf 27 29\nf 28 30\nf 29 30\ninv\nf 27 30\ninv\nf 29 28\nf 29 19\nf 30 20\ninv\nf 29 20\ninv\nf 19 30\ninv\nf 19 27\ninv\nf 20 28\ninv\nf 19 28\ninv\nf 27 20\ninv\nf 17 29\ninv\nf 18 30\ninv\nf 17 30\ninv\nf 29 18\nf 17 31\nf 18 32\nf 31 32\ninv\nf 17 32\ninv\nf 31 18\nf 31 33\nf 32 34\nf 33 34\ninv\nf 31 34\ninv\nf 33 32\nf 33 27\nf 34 28\ninv\nf 33 28\ninv\nf 27 34\ninv\nf 17 33\ninv\nf 18 34\ninv\nf 17 34\ninv\nf 33 18\ninv\nf 31 27\ninv\nf 32 28\ninv\nf 31 28\ninv\nf 27 32\nf 31 25\nf 32 26\ninv\nf 31 26\ninv\nf 25 32\nf 25 35\nf 26 36\nf 35 36\ninv\nf 25 36\ninv\nf 35 26\nf 35 33\nf 36 34\ninv\nf 35 34\ninv\nf 33 36\ninv\nf 31 35\ninv\nf 32 36\ninv\nf 31 36\ninv\nf 35 32\ninv\nf 25 33\ninv\nf 26 34\ninv\nf 25 34\ninv\nf 33 26\nf 27 37\nf 28 38\nf 37 38\ninv\nf 27 38\ninv\nf 37 28\nf 37 39\nf 38 40\nf 39 40\ninv\nf 37 40\ninv\nf 39 38\nf 39 29\nf 40 30\ninv\nf 39 30\ninv\nf 29 40\ninv\nf 29 37\ninv\nf 30 38\ninv\nf 29 38\ninv\nf 37 30\ninv\nf 27 39\ninv\nf 28 40\ninv\nf 27 40\ninv\nf 39 28\nf 35 41\nf 36 42\nf 41 42\ninv\nf 35 42\ninv\nf 41 36\nf 41 43\nf 42 44\nf 43 44\ninv\nf 41 44\ninv\nf 43 42\nf 43 45\nf 44 46\nf 45 46\ninv\nf 43 46\ninv\nf 45 44\nf 45 35\nf 46 36\ninv\nf 45 36\ninv\nf 35 46\ninv\nf 35 43\ninv\nf 36 44\ninv\nf 35 44\ninv\nf 43 36\ninv\nf 41 45\ninv\nf 42 46\ninv\nf 41 46\ninv\nf 45 42\nf 37 47\nf 38 48\nf 47 48\ninv\nf 37 48\ninv\nf 47 38\nf 47 49\nf 48 50\nf 49 50\ninv\nf 47 50\ninv\nf 49 48\nf 49 39\nf 50 40\ninv\nf 49 40\ninv\nf 39 50\ninv\nf 39 47\ninv\nf 40 48\ninv\nf 39 48\ninv\nf 47 40\ninv\nf 37 49\ninv\nf 38 50\ninv\nf 37 50\ninv\nf 49 38\nf 43 51\nf 44 52\nf 51 52\ninv\nf 43 52\ninv\nf 51 44\nf 51 53\nf 52 54\nf 53 54\ninv\nf 51 54\ninv\nf 53 52\nf 53 45\nf 54 46\ninv\nf 53 46\ninv\nf 45 54\ninv\nf 45 51\ninv\nf 46 52\ninv\nf 45 52\ninv\nf 51 46\ninv\nf 43 53\ninv\nf 44 54\ninv\nf 43 54\ninv\nf 53 44\n";
      case 115:return "v 1 0 1\nv 2 0 1\nv 1 0 2\nv 2 0 2\nv 2 1 1\nv 2 1 2\nv 1 1 1\nv 1 1 2\nv 3 0 1\nv 3 0 2\nv 3 1 1\nv 3 1 2\nv 4 0 1\nv 4 0 2\nv 4 1 1\nv 4 1 2\nv 0 1 1\nv 0 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 2 2 1\nv 2 2 2\nv 2 3 1\nv 2 3 2\nv 1 3 1\nv 1 3 2\nv 3 2 1\nv 3 2 2\nv 3 3 1\nv 3 3 2\nv 4 3 1\nv 4 3 2\nv 4 4 1\nv 4 4 2\nv 3 4 1\nv 3 4 2\nv 0 4 1\nv 1 4 1\nv 0 4 2\nv 1 4 2\nv 1 5 1\nv 1 5 2\nv 0 5 1\nv 0 5 2\nv 2 4 1\nv 2 4 2\nv 2 5 1\nv 2 5 2\nv 3 5 1\nv 3 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 2 9\nf 4 10\nf 9 10\ninv\nf 2 10\ninv\nf 9 4\nf 9 11\nf 10 12\nf 11 12\ninv\nf 9 12\ninv\nf 11 10\nf 11 5\nf 12 6\ninv\nf 11 6\ninv\nf 5 12\ninv\nf 2 11\ninv\nf 4 12\ninv\nf 2 12\ninv\nf 11 4\ninv\nf 9 5\ninv\nf 10 6\ninv\nf 9 6\ninv\nf 5 10\nf 9 13\nf 10 14\nf 13 14\ninv\nf 9 14\ninv\nf 13 10\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 11\nf 16 12\ninv\nf 15 12\ninv\nf 11 16\ninv\nf 9 15\ninv\nf 10 16\ninv\nf 9 16\ninv\nf 15 10\ninv\nf 13 11\ninv\nf 14 12\ninv\nf 13 12\ninv\nf 11 14\nf 17 7\nf 18 8\nf 17 18\ninv\nf 17 8\ninv\nf 7 18\nf 7 19\nf 8 20\nf 19 20\ninv\nf 7 20\ninv\nf 19 8\nf 19 21\nf 20 22\nf 21 22\ninv\nf 19 22\ninv\nf 21 20\nf 21 17\nf 22 18\ninv\nf 21 18\ninv\nf 17 22\ninv\nf 17 19\ninv\nf 18 20\ninv\nf 17 20\ninv\nf 19 18\ninv\nf 7 21\ninv\nf 8 22\ninv\nf 7 22\ninv\nf 21 8\nf 19 23\nf 20 24\nf 23 24\ninv\nf 19 24\ninv\nf 23 20\nf 23 25\nf 24 26\nf 25 26\ninv\nf 23 26\ninv\nf 25 24\nf 25 27\nf 26 28\nf 27 28\ninv\nf 25 28\ninv\nf 27 26\nf 27 19\nf 28 20\ninv\nf 27 20\ninv\nf 19 28\ninv\nf 19 25\ninv\nf 20 26\ninv\nf 19 26\ninv\nf 25 20\ninv\nf 23 27\ninv\nf 24 28\ninv\nf 23 28\ninv\nf 27 24\nf 23 29\nf 24 30\nf 29 30\ninv\nf 23 30\ninv\nf 29 24\nf 29 31\nf 30 32\nf 31 32\ninv\nf 29 32\ninv\nf 31 30\nf 31 25\nf 32 26\ninv\nf 31 26\ninv\nf 25 32\ninv\nf 23 31\ninv\nf 24 32\ninv\nf 23 32\ninv\nf 31 24\ninv\nf 29 25\ninv\nf 30 26\ninv\nf 29 26\ninv\nf 25 30\nf 31 33\nf 32 34\nf 33 34\ninv\nf 31 34\ninv\nf 33 32\nf 33 35\nf 34 36\nf 35 36\ninv\nf 33 36\ninv\nf 35 34\nf 35 37\nf 36 38\nf 37 38\ninv\nf 35 38\ninv\nf 37 36\nf 37 31\nf 38 32\ninv\nf 37 32\ninv\nf 31 38\ninv\nf 31 35\ninv\nf 32 36\ninv\nf 31 36\ninv\nf 35 32\ninv\nf 33 37\ninv\nf 34 38\ninv\nf 33 38\ninv\nf 37 34\nf 39 40\nf 41 42\nf 39 41\nf 40 42\ninv\nf 39 42\ninv\nf 40 41\nf 40 43\nf 42 44\nf 43 44\ninv\nf 40 44\ninv\nf 43 42\nf 43 45\nf 44 46\nf 45 46\ninv\nf 43 46\ninv\nf 45 44\nf 45 39\nf 46 41\ninv\nf 45 41\ninv\nf 39 46\ninv\nf 39 43\ninv\nf 41 44\ninv\nf 39 44\ninv\nf 43 41\ninv\nf 40 45\ninv\nf 42 46\ninv\nf 40 46\ninv\nf 45 42\nf 40 47\nf 42 48\nf 47 48\ninv\nf 40 48\ninv\nf 47 42\nf 47 49\nf 48 50\nf 49 50\ninv\nf 47 50\ninv\nf 49 48\nf 49 43\nf 50 44\ninv\nf 49 44\ninv\nf 43 50\ninv\nf 40 49\ninv\nf 42 50\ninv\nf 40 50\ninv\nf 49 42\ninv\nf 47 43\ninv\nf 48 44\ninv\nf 47 44\ninv\nf 43 48\nf 47 37\nf 48 38\ninv\nf 47 38\ninv\nf 37 48\nf 37 51\nf 38 52\nf 51 52\ninv\nf 37 52\ninv\nf 51 38\nf 51 49\nf 52 50\ninv\nf 51 50\ninv\nf 49 52\ninv\nf 47 51\ninv\nf 48 52\ninv\nf 47 52\ninv\nf 51 48\ninv\nf 37 49\ninv\nf 38 50\ninv\nf 37 50\ninv\nf 49 38\n";
      case 116:return "v 0 0 1\nv 1 0 1\nv 0 0 2\nv 1 0 2\nv 1 1 1\nv 1 1 2\nv 0 1 1\nv 0 1 2\nv 2 0 1\nv 2 0 2\nv 2 1 1\nv 2 1 2\nv 3 0 1\nv 3 0 2\nv 3 1 1\nv 3 1 2\nv 2 2 1\nv 2 2 2\nv 1 2 1\nv 1 2 2\nv 2 3 1\nv 2 3 2\nv 1 3 1\nv 1 3 2\nv 2 4 1\nv 2 4 2\nv 1 4 1\nv 1 4 2\nv 2 5 1\nv 2 5 2\nv 1 5 1\nv 1 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 2 9\nf 4 10\nf 9 10\ninv\nf 2 10\ninv\nf 9 4\nf 9 11\nf 10 12\nf 11 12\ninv\nf 9 12\ninv\nf 11 10\nf 11 5\nf 12 6\ninv\nf 11 6\ninv\nf 5 12\ninv\nf 2 11\ninv\nf 4 12\ninv\nf 2 12\ninv\nf 11 4\ninv\nf 9 5\ninv\nf 10 6\ninv\nf 9 6\ninv\nf 5 10\nf 9 13\nf 10 14\nf 13 14\ninv\nf 9 14\ninv\nf 13 10\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 11\nf 16 12\ninv\nf 15 12\ninv\nf 11 16\ninv\nf 9 15\ninv\nf 10 16\ninv\nf 9 16\ninv\nf 15 10\ninv\nf 13 11\ninv\nf 14 12\ninv\nf 13 12\ninv\nf 11 14\nf 11 17\nf 12 18\nf 17 18\ninv\nf 11 18\ninv\nf 17 12\nf 17 19\nf 18 20\nf 19 20\ninv\nf 17 20\ninv\nf 19 18\nf 19 5\nf 20 6\ninv\nf 19 6\ninv\nf 5 20\ninv\nf 5 17\ninv\nf 6 18\ninv\nf 5 18\ninv\nf 17 6\ninv\nf 11 19\ninv\nf 12 20\ninv\nf 11 20\ninv\nf 19 12\nf 17 21\nf 18 22\nf 21 22\ninv\nf 17 22\ninv\nf 21 18\nf 21 23\nf 22 24\nf 23 24\ninv\nf 21 24\ninv\nf 23 22\nf 23 19\nf 24 20\ninv\nf 23 20\ninv\nf 19 24\ninv\nf 19 21\ninv\nf 20 22\ninv\nf 19 22\ninv\nf 21 20\ninv\nf 17 23\ninv\nf 18 24\ninv\nf 17 24\ninv\nf 23 18\nf 21 25\nf 22 26\nf 25 26\ninv\nf 21 26\ninv\nf 25 22\nf 25 27\nf 26 28\nf 27 28\ninv\nf 25 28\ninv\nf 27 26\nf 27 23\nf 28 24\ninv\nf 27 24\ninv\nf 23 28\ninv\nf 23 25\ninv\nf 24 26\ninv\nf 23 26\ninv\nf 25 24\ninv\nf 21 27\ninv\nf 22 28\ninv\nf 21 28\ninv\nf 27 22\nf 25 29\nf 26 30\nf 29 30\ninv\nf 25 30\ninv\nf 29 26\nf 29 31\nf 30 32\nf 31 32\ninv\nf 29 32\ninv\nf 31 30\nf 31 27\nf 32 28\ninv\nf 31 28\ninv\nf 27 32\ninv\nf 27 29\ninv\nf 28 30\ninv\nf 27 30\ninv\nf 29 28\ninv\nf 25 31\ninv\nf 26 32\ninv\nf 25 32\ninv\nf 31 26\n";
      case 117:return "v 0 0 1\nv 1 0 1\nv 0 0 2\nv 1 0 2\nv 1 1 1\nv 1 1 2\nv 0 1 1\nv 0 1 2\nv 3 0 1\nv 4 0 1\nv 3 0 2\nv 4 0 2\nv 4 1 1\nv 4 1 2\nv 3 1 1\nv 3 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 4 2 1\nv 4 2 2\nv 3 2 1\nv 3 2 2\nv 1 3 1\nv 1 3 2\nv 0 3 1\nv 0 3 2\nv 4 3 1\nv 4 3 2\nv 3 3 1\nv 3 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 4 4 1\nv 4 4 2\nv 3 4 1\nv 3 4 2\nv 2 4 1\nv 2 4 2\nv 2 5 1\nv 2 5 2\nv 1 5 1\nv 1 5 2\nv 3 5 1\nv 3 5 2\nv 4 5 1\nv 4 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 9 10\nf 11 12\nf 9 11\nf 10 12\ninv\nf 9 12\ninv\nf 10 11\nf 10 13\nf 12 14\nf 13 14\ninv\nf 10 14\ninv\nf 13 12\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 9\nf 16 11\ninv\nf 15 11\ninv\nf 9 16\ninv\nf 9 13\ninv\nf 11 14\ninv\nf 9 14\ninv\nf 13 11\ninv\nf 10 15\ninv\nf 12 16\ninv\nf 10 16\ninv\nf 15 12\nf 5 17\nf 6 18\nf 17 18\ninv\nf 5 18\ninv\nf 17 6\nf 17 19\nf 18 20\nf 19 20\ninv\nf 17 20\ninv\nf 19 18\nf 19 7\nf 20 8\ninv\nf 19 8\ninv\nf 7 20\ninv\nf 7 17\ninv\nf 8 18\ninv\nf 7 18\ninv\nf 17 8\ninv\nf 5 19\ninv\nf 6 20\ninv\nf 5 20\ninv\nf 19 6\nf 13 21\nf 14 22\nf 21 22\ninv\nf 13 22\ninv\nf 21 14\nf 21 23\nf 22 24\nf 23 24\ninv\nf 21 24\ninv\nf 23 22\nf 23 15\nf 24 16\ninv\nf 23 16\ninv\nf 15 24\ninv\nf 15 21\ninv\nf 16 22\ninv\nf 15 22\ninv\nf 21 16\ninv\nf 13 23\ninv\nf 14 24\ninv\nf 13 24\ninv\nf 23 14\nf 17 25\nf 18 26\nf 25 26\ninv\nf 17 26\ninv\nf 25 18\nf 25 27\nf 26 28\nf 27 28\ninv\nf 25 28\ninv\nf 27 26\nf 27 19\nf 28 20\ninv\nf 27 20\ninv\nf 19 28\ninv\nf 19 25\ninv\nf 20 26\ninv\nf 19 26\ninv\nf 25 20\ninv\nf 17 27\ninv\nf 18 28\ninv\nf 17 28\ninv\nf 27 18\nf 21 29\nf 22 30\nf 29 30\ninv\nf 21 30\ninv\nf 29 22\nf 29 31\nf 30 32\nf 31 32\ninv\nf 29 32\ninv\nf 31 30\nf 31 23\nf 32 24\ninv\nf 31 24\ninv\nf 23 32\ninv\nf 23 29\ninv\nf 24 30\ninv\nf 23 30\ninv\nf 29 24\ninv\nf 21 31\ninv\nf 22 32\ninv\nf 21 32\ninv\nf 31 22\nf 25 33\nf 26 34\nf 33 34\ninv\nf 25 34\ninv\nf 33 26\nf 33 35\nf 34 36\nf 35 36\ninv\nf 33 36\ninv\nf 35 34\nf 35 27\nf 36 28\ninv\nf 35 28\ninv\nf 27 36\ninv\nf 27 33\ninv\nf 28 34\ninv\nf 27 34\ninv\nf 33 28\ninv\nf 25 35\ninv\nf 26 36\ninv\nf 25 36\ninv\nf 35 26\nf 29 37\nf 30 38\nf 37 38\ninv\nf 29 38\ninv\nf 37 30\nf 37 39\nf 38 40\nf 39 40\ninv\nf 37 40\ninv\nf 39 38\nf 39 31\nf 40 32\ninv\nf 39 32\ninv\nf 31 40\ninv\nf 31 37\ninv\nf 32 38\ninv\nf 31 38\ninv\nf 37 32\ninv\nf 29 39\ninv\nf 30 40\ninv\nf 29 40\ninv\nf 39 30\nf 33 41\nf 34 42\nf 41 42\ninv\nf 33 42\ninv\nf 41 34\nf 41 43\nf 42 44\nf 43 44\ninv\nf 41 44\ninv\nf 43 42\nf 43 45\nf 44 46\nf 45 46\ninv\nf 43 46\ninv\nf 45 44\nf 45 33\nf 46 34\ninv\nf 45 34\ninv\nf 33 46\ninv\nf 33 43\ninv\nf 34 44\ninv\nf 33 44\ninv\nf 43 34\ninv\nf 41 45\ninv\nf 42 46\ninv\nf 41 46\ninv\nf 45 42\nf 41 39\nf 42 40\ninv\nf 41 40\ninv\nf 39 42\nf 39 47\nf 40 48\nf 47 48\ninv\nf 39 48\ninv\nf 47 40\nf 47 43\nf 48 44\ninv\nf 47 44\ninv\nf 43 48\ninv\nf 41 47\ninv\nf 42 48\ninv\nf 41 48\ninv\nf 47 42\ninv\nf 39 43\ninv\nf 40 44\ninv\nf 39 44\ninv\nf 43 40\nf 37 49\nf 38 50\nf 49 50\ninv\nf 37 50\ninv\nf 49 38\nf 49 47\nf 50 48\ninv\nf 49 48\ninv\nf 47 50\ninv\nf 39 49\ninv\nf 40 50\ninv\nf 39 50\ninv\nf 49 40\ninv\nf 37 47\ninv\nf 38 48\ninv\nf 37 48\ninv\nf 47 38\n";
      case 118:return "v 0 0 1\nv 1 0 1\nv 0 0 2\nv 1 0 2\nv 1 1 1\nv 1 1 2\nv 0 1 1\nv 0 1 2\nv 3 0 1\nv 4 0 1\nv 3 0 2\nv 4 0 2\nv 4 1 1\nv 4 1 2\nv 3 1 1\nv 3 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 4 2 1\nv 4 2 2\nv 3 2 1\nv 3 2 2\nv 1 3 1\nv 1 3 2\nv 0 3 1\nv 0 3 2\nv 4 3 1\nv 4 3 2\nv 3 3 1\nv 3 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 4 4 1\nv 4 4 2\nv 3 4 1\nv 3 4 2\nv 2 4 1\nv 2 4 2\nv 2 5 1\nv 2 5 2\nv 1 5 1\nv 1 5 2\nv 3 5 1\nv 3 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 9 10\nf 11 12\nf 9 11\nf 10 12\ninv\nf 9 12\ninv\nf 10 11\nf 10 13\nf 12 14\nf 13 14\ninv\nf 10 14\ninv\nf 13 12\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 9\nf 16 11\ninv\nf 15 11\ninv\nf 9 16\ninv\nf 9 13\ninv\nf 11 14\ninv\nf 9 14\ninv\nf 13 11\ninv\nf 10 15\ninv\nf 12 16\ninv\nf 10 16\ninv\nf 15 12\nf 5 17\nf 6 18\nf 17 18\ninv\nf 5 18\ninv\nf 17 6\nf 17 19\nf 18 20\nf 19 20\ninv\nf 17 20\ninv\nf 19 18\nf 19 7\nf 20 8\ninv\nf 19 8\ninv\nf 7 20\ninv\nf 7 17\ninv\nf 8 18\ninv\nf 7 18\ninv\nf 17 8\ninv\nf 5 19\ninv\nf 6 20\ninv\nf 5 20\ninv\nf 19 6\nf 13 21\nf 14 22\nf 21 22\ninv\nf 13 22\ninv\nf 21 14\nf 21 23\nf 22 24\nf 23 24\ninv\nf 21 24\ninv\nf 23 22\nf 23 15\nf 24 16\ninv\nf 23 16\ninv\nf 15 24\ninv\nf 15 21\ninv\nf 16 22\ninv\nf 15 22\ninv\nf 21 16\ninv\nf 13 23\ninv\nf 14 24\ninv\nf 13 24\ninv\nf 23 14\nf 17 25\nf 18 26\nf 25 26\ninv\nf 17 26\ninv\nf 25 18\nf 25 27\nf 26 28\nf 27 28\ninv\nf 25 28\ninv\nf 27 26\nf 27 19\nf 28 20\ninv\nf 27 20\ninv\nf 19 28\ninv\nf 19 25\ninv\nf 20 26\ninv\nf 19 26\ninv\nf 25 20\ninv\nf 17 27\ninv\nf 18 28\ninv\nf 17 28\ninv\nf 27 18\nf 21 29\nf 22 30\nf 29 30\ninv\nf 21 30\ninv\nf 29 22\nf 29 31\nf 30 32\nf 31 32\ninv\nf 29 32\ninv\nf 31 30\nf 31 23\nf 32 24\ninv\nf 31 24\ninv\nf 23 32\ninv\nf 23 29\ninv\nf 24 30\ninv\nf 23 30\ninv\nf 29 24\ninv\nf 21 31\ninv\nf 22 32\ninv\nf 21 32\ninv\nf 31 22\nf 25 33\nf 26 34\nf 33 34\ninv\nf 25 34\ninv\nf 33 26\nf 33 35\nf 34 36\nf 35 36\ninv\nf 33 36\ninv\nf 35 34\nf 35 27\nf 36 28\ninv\nf 35 28\ninv\nf 27 36\ninv\nf 27 33\ninv\nf 28 34\ninv\nf 27 34\ninv\nf 33 28\ninv\nf 25 35\ninv\nf 26 36\ninv\nf 25 36\ninv\nf 35 26\nf 29 37\nf 30 38\nf 37 38\ninv\nf 29 38\ninv\nf 37 30\nf 37 39\nf 38 40\nf 39 40\ninv\nf 37 40\ninv\nf 39 38\nf 39 31\nf 40 32\ninv\nf 39 32\ninv\nf 31 40\ninv\nf 31 37\ninv\nf 32 38\ninv\nf 31 38\ninv\nf 37 32\ninv\nf 29 39\ninv\nf 30 40\ninv\nf 29 40\ninv\nf 39 30\nf 33 41\nf 34 42\nf 41 42\ninv\nf 33 42\ninv\nf 41 34\nf 41 43\nf 42 44\nf 43 44\ninv\nf 41 44\ninv\nf 43 42\nf 43 45\nf 44 46\nf 45 46\ninv\nf 43 46\ninv\nf 45 44\nf 45 33\nf 46 34\ninv\nf 45 34\ninv\nf 33 46\ninv\nf 33 43\ninv\nf 34 44\ninv\nf 33 44\ninv\nf 43 34\ninv\nf 41 45\ninv\nf 42 46\ninv\nf 41 46\ninv\nf 45 42\nf 41 39\nf 42 40\ninv\nf 41 40\ninv\nf 39 42\nf 39 47\nf 40 48\nf 47 48\ninv\nf 39 48\ninv\nf 47 40\nf 47 43\nf 48 44\ninv\nf 47 44\ninv\nf 43 48\ninv\nf 41 47\ninv\nf 42 48\ninv\nf 41 48\ninv\nf 47 42\ninv\nf 39 43\ninv\nf 40 44\ninv\nf 39 44\ninv\nf 43 40\n";
      case 119:return "v 0 0 1\nv 1 0 1\nv 0 0 2\nv 1 0 2\nv 1 1 1\nv 1 1 2\nv 0 1 1\nv 0 1 2\nv 3 0 1\nv 4 0 1\nv 3 0 2\nv 4 0 2\nv 4 1 1\nv 4 1 2\nv 3 1 1\nv 3 1 2\nv 6 0 1\nv 7 0 1\nv 6 0 2\nv 7 0 2\nv 7 1 1\nv 7 1 2\nv 6 1 1\nv 6 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 4 2 1\nv 4 2 2\nv 3 2 1\nv 3 2 2\nv 7 2 1\nv 7 2 2\nv 6 2 1\nv 6 2 2\nv 1 3 1\nv 1 3 2\nv 0 3 1\nv 0 3 2\nv 4 3 1\nv 4 3 2\nv 3 3 1\nv 3 3 2\nv 7 3 1\nv 7 3 2\nv 6 3 1\nv 6 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 4 4 1\nv 4 4 2\nv 3 4 1\nv 3 4 2\nv 7 4 1\nv 7 4 2\nv 6 4 1\nv 6 4 2\nv 2 4 1\nv 2 4 2\nv 2 5 1\nv 2 5 2\nv 1 5 1\nv 1 5 2\nv 3 5 1\nv 3 5 2\nv 5 4 1\nv 5 4 2\nv 5 5 1\nv 5 5 2\nv 4 5 1\nv 4 5 2\nv 6 5 1\nv 6 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 9 10\nf 11 12\nf 9 11\nf 10 12\ninv\nf 9 12\ninv\nf 10 11\nf 10 13\nf 12 14\nf 13 14\ninv\nf 10 14\ninv\nf 13 12\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 9\nf 16 11\ninv\nf 15 11\ninv\nf 9 16\ninv\nf 9 13\ninv\nf 11 14\ninv\nf 9 14\ninv\nf 13 11\ninv\nf 10 15\ninv\nf 12 16\ninv\nf 10 16\ninv\nf 15 12\nf 17 18\nf 19 20\nf 17 19\nf 18 20\ninv\nf 17 20\ninv\nf 18 19\nf 18 21\nf 20 22\nf 21 22\ninv\nf 18 22\ninv\nf 21 20\nf 21 23\nf 22 24\nf 23 24\ninv\nf 21 24\ninv\nf 23 22\nf 23 17\nf 24 19\ninv\nf 23 19\ninv\nf 17 24\ninv\nf 17 21\ninv\nf 19 22\ninv\nf 17 22\ninv\nf 21 19\ninv\nf 18 23\ninv\nf 20 24\ninv\nf 18 24\ninv\nf 23 20\nf 5 25\nf 6 26\nf 25 26\ninv\nf 5 26\ninv\nf 25 6\nf 25 27\nf 26 28\nf 27 28\ninv\nf 25 28\ninv\nf 27 26\nf 27 7\nf 28 8\ninv\nf 27 8\ninv\nf 7 28\ninv\nf 7 25\ninv\nf 8 26\ninv\nf 7 26\ninv\nf 25 8\ninv\nf 5 27\ninv\nf 6 28\ninv\nf 5 28\ninv\nf 27 6\nf 13 29\nf 14 30\nf 29 30\ninv\nf 13 30\ninv\nf 29 14\nf 29 31\nf 30 32\nf 31 32\ninv\nf 29 32\ninv\nf 31 30\nf 31 15\nf 32 16\ninv\nf 31 16\ninv\nf 15 32\ninv\nf 15 29\ninv\nf 16 30\ninv\nf 15 30\ninv\nf 29 16\ninv\nf 13 31\ninv\nf 14 32\ninv\nf 13 32\ninv\nf 31 14\nf 21 33\nf 22 34\nf 33 34\ninv\nf 21 34\ninv\nf 33 22\nf 33 35\nf 34 36\nf 35 36\ninv\nf 33 36\ninv\nf 35 34\nf 35 23\nf 36 24\ninv\nf 35 24\ninv\nf 23 36\ninv\nf 23 33\ninv\nf 24 34\ninv\nf 23 34\ninv\nf 33 24\ninv\nf 21 35\ninv\nf 22 36\ninv\nf 21 36\ninv\nf 35 22\nf 25 37\nf 26 38\nf 37 38\ninv\nf 25 38\ninv\nf 37 26\nf 37 39\nf 38 40\nf 39 40\ninv\nf 37 40\ninv\nf 39 38\nf 39 27\nf 40 28\ninv\nf 39 28\ninv\nf 27 40\ninv\nf 27 37\ninv\nf 28 38\ninv\nf 27 38\ninv\nf 37 28\ninv\nf 25 39\ninv\nf 26 40\ninv\nf 25 40\ninv\nf 39 26\nf 29 41\nf 30 42\nf 41 42\ninv\nf 29 42\ninv\nf 41 30\nf 41 43\nf 42 44\nf 43 44\ninv\nf 41 44\ninv\nf 43 42\nf 43 31\nf 44 32\ninv\nf 43 32\ninv\nf 31 44\ninv\nf 31 41\ninv\nf 32 42\ninv\nf 31 42\ninv\nf 41 32\ninv\nf 29 43\ninv\nf 30 44\ninv\nf 29 44\ninv\nf 43 30\nf 33 45\nf 34 46\nf 45 46\ninv\nf 33 46\ninv\nf 45 34\nf 45 47\nf 46 48\nf 47 48\ninv\nf 45 48\ninv\nf 47 46\nf 47 35\nf 48 36\ninv\nf 47 36\ninv\nf 35 48\ninv\nf 35 45\ninv\nf 36 46\ninv\nf 35 46\ninv\nf 45 36\ninv\nf 33 47\ninv\nf 34 48\ninv\nf 33 48\ninv\nf 47 34\nf 37 49\nf 38 50\nf 49 50\ninv\nf 37 50\ninv\nf 49 38\nf 49 51\nf 50 52\nf 51 52\ninv\nf 49 52\ninv\nf 51 50\nf 51 39\nf 52 40\ninv\nf 51 40\ninv\nf 39 52\ninv\nf 39 49\ninv\nf 40 50\ninv\nf 39 50\ninv\nf 49 40\ninv\nf 37 51\ninv\nf 38 52\ninv\nf 37 52\ninv\nf 51 38\nf 41 53\nf 42 54\nf 53 54\ninv\nf 41 54\ninv\nf 53 42\nf 53 55\nf 54 56\nf 55 56\ninv\nf 53 56\ninv\nf 55 54\nf 55 43\nf 56 44\ninv\nf 55 44\ninv\nf 43 56\ninv\nf 43 53\ninv\nf 44 54\ninv\nf 43 54\ninv\nf 53 44\ninv\nf 41 55\ninv\nf 42 56\ninv\nf 41 56\ninv\nf 55 42\nf 45 57\nf 46 58\nf 57 58\ninv\nf 45 58\ninv\nf 57 46\nf 57 59\nf 58 60\nf 59 60\ninv\nf 57 60\ninv\nf 59 58\nf 59 47\nf 60 48\ninv\nf 59 48\ninv\nf 47 60\ninv\nf 47 57\ninv\nf 48 58\ninv\nf 47 58\ninv\nf 57 48\ninv\nf 45 59\ninv\nf 46 60\ninv\nf 45 60\ninv\nf 59 46\nf 49 61\nf 50 62\nf 61 62\ninv\nf 49 62\ninv\nf 61 50\nf 61 63\nf 62 64\nf 63 64\ninv\nf 61 64\ninv\nf 63 62\nf 63 65\nf 64 66\nf 65 66\ninv\nf 63 66\ninv\nf 65 64\nf 65 49\nf 66 50\ninv\nf 65 50\ninv\nf 49 66\ninv\nf 49 63\ninv\nf 50 64\ninv\nf 49 64\ninv\nf 63 50\ninv\nf 61 65\ninv\nf 62 66\ninv\nf 61 66\ninv\nf 65 62\nf 61 55\nf 62 56\ninv\nf 61 56\ninv\nf 55 62\nf 55 67\nf 56 68\nf 67 68\ninv\nf 55 68\ninv\nf 67 56\nf 67 63\nf 68 64\ninv\nf 67 64\ninv\nf 63 68\ninv\nf 61 67\ninv\nf 62 68\ninv\nf 61 68\ninv\nf 67 62\ninv\nf 55 63\ninv\nf 56 64\ninv\nf 55 64\ninv\nf 63 56\nf 53 69\nf 54 70\nf 69 70\ninv\nf 53 70\ninv\nf 69 54\nf 69 71\nf 70 72\nf 71 72\ninv\nf 69 72\ninv\nf 71 70\nf 71 73\nf 72 74\nf 73 74\ninv\nf 71 74\ninv\nf 73 72\nf 73 53\nf 74 54\ninv\nf 73 54\ninv\nf 53 74\ninv\nf 53 71\ninv\nf 54 72\ninv\nf 53 72\ninv\nf 71 54\ninv\nf 69 73\ninv\nf 70 74\ninv\nf 69 74\ninv\nf 73 70\nf 69 59\nf 70 60\ninv\nf 69 60\ninv\nf 59 70\nf 59 75\nf 60 76\nf 75 76\ninv\nf 59 76\ninv\nf 75 60\nf 75 71\nf 76 72\ninv\nf 75 72\ninv\nf 71 76\ninv\nf 69 75\ninv\nf 70 76\ninv\nf 69 76\ninv\nf 75 70\ninv\nf 59 71\ninv\nf 60 72\ninv\nf 59 72\ninv\nf 71 60\n";
      case 120:return "v 0 0 1\nv 1 0 1\nv 0 0 2\nv 1 0 2\nv 1 1 1\nv 1 1 2\nv 0 1 1\nv 0 1 2\nv 3 0 1\nv 4 0 1\nv 3 0 2\nv 4 0 2\nv 4 1 1\nv 4 1 2\nv 3 1 1\nv 3 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 4 2 1\nv 4 2 2\nv 3 2 1\nv 3 2 2\nv 2 2 1\nv 2 2 2\nv 2 3 1\nv 2 3 2\nv 1 3 1\nv 1 3 2\nv 3 3 1\nv 3 3 2\nv 0 3 1\nv 0 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 4 3 1\nv 4 3 2\nv 4 4 1\nv 4 4 2\nv 3 4 1\nv 3 4 2\nv 1 5 1\nv 1 5 2\nv 0 5 1\nv 0 5 2\nv 4 5 1\nv 4 5 2\nv 3 5 1\nv 3 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 9 10\nf 11 12\nf 9 11\nf 10 12\ninv\nf 9 12\ninv\nf 10 11\nf 10 13\nf 12 14\nf 13 14\ninv\nf 10 14\ninv\nf 13 12\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 9\nf 16 11\ninv\nf 15 11\ninv\nf 9 16\ninv\nf 9 13\ninv\nf 11 14\ninv\nf 9 14\ninv\nf 13 11\ninv\nf 10 15\ninv\nf 12 16\ninv\nf 10 16\ninv\nf 15 12\nf 5 17\nf 6 18\nf 17 18\ninv\nf 5 18\ninv\nf 17 6\nf 17 19\nf 18 20\nf 19 20\ninv\nf 17 20\ninv\nf 19 18\nf 19 7\nf 20 8\ninv\nf 19 8\ninv\nf 7 20\ninv\nf 7 17\ninv\nf 8 18\ninv\nf 7 18\ninv\nf 17 8\ninv\nf 5 19\ninv\nf 6 20\ninv\nf 5 20\ninv\nf 19 6\nf 13 21\nf 14 22\nf 21 22\ninv\nf 13 22\ninv\nf 21 14\nf 21 23\nf 22 24\nf 23 24\ninv\nf 21 24\ninv\nf 23 22\nf 23 15\nf 24 16\ninv\nf 23 16\ninv\nf 15 24\ninv\nf 15 21\ninv\nf 16 22\ninv\nf 15 22\ninv\nf 21 16\ninv\nf 13 23\ninv\nf 14 24\ninv\nf 13 24\ninv\nf 23 14\nf 17 25\nf 18 26\nf 25 26\ninv\nf 17 26\ninv\nf 25 18\nf 25 27\nf 26 28\nf 27 28\ninv\nf 25 28\ninv\nf 27 26\nf 27 29\nf 28 30\nf 29 30\ninv\nf 27 30\ninv\nf 29 28\nf 29 17\nf 30 18\ninv\nf 29 18\ninv\nf 17 30\ninv\nf 17 27\ninv\nf 18 28\ninv\nf 17 28\ninv\nf 27 18\ninv\nf 25 29\ninv\nf 26 30\ninv\nf 25 30\ninv\nf 29 26\nf 25 23\nf 26 24\ninv\nf 25 24\ninv\nf 23 26\nf 23 31\nf 24 32\nf 31 32\ninv\nf 23 32\ninv\nf 31 24\nf 31 27\nf 32 28\ninv\nf 31 28\ninv\nf 27 32\ninv\nf 25 31\ninv\nf 26 32\ninv\nf 25 32\ninv\nf 31 26\ninv\nf 23 27\ninv\nf 24 28\ninv\nf 23 28\ninv\nf 27 24\nf 33 29\nf 34 30\nf 33 34\ninv\nf 33 30\ninv\nf 29 34\nf 29 35\nf 30 36\nf 35 36\ninv\nf 29 36\ninv\nf 35 30\nf 35 37\nf 36 38\nf 37 38\ninv\nf 35 38\ninv\nf 37 36\nf 37 33\nf 38 34\ninv\nf 37 34\ninv\nf 33 38\ninv\nf 33 35\ninv\nf 34 36\ninv\nf 33 36\ninv\nf 35 34\ninv\nf 29 37\ninv\nf 30 38\ninv\nf 29 38\ninv\nf 37 30\nf 31 39\nf 32 40\nf 39 40\ninv\nf 31 40\ninv\nf 39 32\nf 39 41\nf 40 42\nf 41 42\ninv\nf 39 42\ninv\nf 41 40\nf 41 43\nf 42 44\nf 43 44\ninv\nf 41 44\ninv\nf 43 42\nf 43 31\nf 44 32\ninv\nf 43 32\ninv\nf 31 44\ninv\nf 31 41\ninv\nf 32 42\ninv\nf 31 42\ninv\nf 41 32\ninv\nf 39 43\ninv\nf 40 44\ninv\nf 39 44\ninv\nf 43 40\nf 35 45\nf 36 46\nf 45 46\ninv\nf 35 46\ninv\nf 45 36\nf 45 47\nf 46 48\nf 47 48\ninv\nf 45 48\ninv\nf 47 46\nf 47 37\nf 48 38\ninv\nf 47 38\ninv\nf 37 48\ninv\nf 37 45\ninv\nf 38 46\ninv\nf 37 46\ninv\nf 45 38\ninv\nf 35 47\ninv\nf 36 48\ninv\nf 35 48\ninv\nf 47 36\nf 41 49\nf 42 50\nf 49 50\ninv\nf 41 50\ninv\nf 49 42\nf 49 51\nf 50 52\nf 51 52\ninv\nf 49 52\ninv\nf 51 50\nf 51 43\nf 52 44\ninv\nf 51 44\ninv\nf 43 52\ninv\nf 43 49\ninv\nf 44 50\ninv\nf 43 50\ninv\nf 49 44\ninv\nf 41 51\ninv\nf 42 52\ninv\nf 41 52\ninv\nf 51 42\n";
      case 121:return "v 0 0 1\nv 1 0 1\nv 0 0 2\nv 1 0 2\nv 1 1 1\nv 1 1 2\nv 0 1 1\nv 0 1 2\nv 3 0 1\nv 4 0 1\nv 3 0 2\nv 4 0 2\nv 4 1 1\nv 4 1 2\nv 3 1 1\nv 3 1 2\nv 1 2 1\nv 1 2 2\nv 0 2 1\nv 0 2 2\nv 4 2 1\nv 4 2 2\nv 3 2 1\nv 3 2 2\nv 2 2 1\nv 2 2 2\nv 2 3 1\nv 2 3 2\nv 1 3 1\nv 1 3 2\nv 3 3 1\nv 3 3 2\nv 4 3 1\nv 4 3 2\nv 4 4 1\nv 4 4 2\nv 3 4 1\nv 3 4 2\nv 0 4 1\nv 1 4 1\nv 0 4 2\nv 1 4 2\nv 1 5 1\nv 1 5 2\nv 0 5 1\nv 0 5 2\nv 2 4 1\nv 2 4 2\nv 2 5 1\nv 2 5 2\nv 3 5 1\nv 3 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 9 10\nf 11 12\nf 9 11\nf 10 12\ninv\nf 9 12\ninv\nf 10 11\nf 10 13\nf 12 14\nf 13 14\ninv\nf 10 14\ninv\nf 13 12\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 9\nf 16 11\ninv\nf 15 11\ninv\nf 9 16\ninv\nf 9 13\ninv\nf 11 14\ninv\nf 9 14\ninv\nf 13 11\ninv\nf 10 15\ninv\nf 12 16\ninv\nf 10 16\ninv\nf 15 12\nf 5 17\nf 6 18\nf 17 18\ninv\nf 5 18\ninv\nf 17 6\nf 17 19\nf 18 20\nf 19 20\ninv\nf 17 20\ninv\nf 19 18\nf 19 7\nf 20 8\ninv\nf 19 8\ninv\nf 7 20\ninv\nf 7 17\ninv\nf 8 18\ninv\nf 7 18\ninv\nf 17 8\ninv\nf 5 19\ninv\nf 6 20\ninv\nf 5 20\ninv\nf 19 6\nf 13 21\nf 14 22\nf 21 22\ninv\nf 13 22\ninv\nf 21 14\nf 21 23\nf 22 24\nf 23 24\ninv\nf 21 24\ninv\nf 23 22\nf 23 15\nf 24 16\ninv\nf 23 16\ninv\nf 15 24\ninv\nf 15 21\ninv\nf 16 22\ninv\nf 15 22\ninv\nf 21 16\ninv\nf 13 23\ninv\nf 14 24\ninv\nf 13 24\ninv\nf 23 14\nf 17 25\nf 18 26\nf 25 26\ninv\nf 17 26\ninv\nf 25 18\nf 25 27\nf 26 28\nf 27 28\ninv\nf 25 28\ninv\nf 27 26\nf 27 29\nf 28 30\nf 29 30\ninv\nf 27 30\ninv\nf 29 28\nf 29 17\nf 30 18\ninv\nf 29 18\ninv\nf 17 30\ninv\nf 17 27\ninv\nf 18 28\ninv\nf 17 28\ninv\nf 27 18\ninv\nf 25 29\ninv\nf 26 30\ninv\nf 25 30\ninv\nf 29 26\nf 25 23\nf 26 24\ninv\nf 25 24\ninv\nf 23 26\nf 23 31\nf 24 32\nf 31 32\ninv\nf 23 32\ninv\nf 31 24\nf 31 27\nf 32 28\ninv\nf 31 28\ninv\nf 27 32\ninv\nf 25 31\ninv\nf 26 32\ninv\nf 25 32\ninv\nf 31 26\ninv\nf 23 27\ninv\nf 24 28\ninv\nf 23 28\ninv\nf 27 24\nf 21 33\nf 22 34\nf 33 34\ninv\nf 21 34\ninv\nf 33 22\nf 33 31\nf 34 32\ninv\nf 33 32\ninv\nf 31 34\ninv\nf 23 33\ninv\nf 24 34\ninv\nf 23 34\ninv\nf 33 24\ninv\nf 21 31\ninv\nf 22 32\ninv\nf 21 32\ninv\nf 31 22\nf 33 35\nf 34 36\nf 35 36\ninv\nf 33 36\ninv\nf 35 34\nf 35 37\nf 36 38\nf 37 38\ninv\nf 35 38\ninv\nf 37 36\nf 37 31\nf 38 32\ninv\nf 37 32\ninv\nf 31 38\ninv\nf 31 35\ninv\nf 32 36\ninv\nf 31 36\ninv\nf 35 32\ninv\nf 33 37\ninv\nf 34 38\ninv\nf 33 38\ninv\nf 37 34\nf 39 40\nf 41 42\nf 39 41\nf 40 42\ninv\nf 39 42\ninv\nf 40 41\nf 40 43\nf 42 44\nf 43 44\ninv\nf 40 44\ninv\nf 43 42\nf 43 45\nf 44 46\nf 45 46\ninv\nf 43 46\ninv\nf 45 44\nf 45 39\nf 46 41\ninv\nf 45 41\ninv\nf 39 46\ninv\nf 39 43\ninv\nf 41 44\ninv\nf 39 44\ninv\nf 43 41\ninv\nf 40 45\ninv\nf 42 46\ninv\nf 40 46\ninv\nf 45 42\nf 40 47\nf 42 48\nf 47 48\ninv\nf 40 48\ninv\nf 47 42\nf 47 49\nf 48 50\nf 49 50\ninv\nf 47 50\ninv\nf 49 48\nf 49 43\nf 50 44\ninv\nf 49 44\ninv\nf 43 50\ninv\nf 40 49\ninv\nf 42 50\ninv\nf 40 50\ninv\nf 49 42\ninv\nf 47 43\ninv\nf 48 44\ninv\nf 47 44\ninv\nf 43 48\nf 47 37\nf 48 38\ninv\nf 47 38\ninv\nf 37 48\nf 37 51\nf 38 52\nf 51 52\ninv\nf 37 52\ninv\nf 51 38\nf 51 49\nf 52 50\ninv\nf 51 50\ninv\nf 49 52\ninv\nf 47 51\ninv\nf 48 52\ninv\nf 47 52\ninv\nf 51 48\ninv\nf 37 49\ninv\nf 38 50\ninv\nf 37 50\ninv\nf 49 38\n";
      case 122:return "v 0 0 1\nv 1 0 1\nv 0 0 2\nv 1 0 2\nv 1 1 1\nv 1 1 2\nv 0 1 1\nv 0 1 2\nv 2 0 1\nv 2 0 2\nv 2 1 1\nv 2 1 2\nv 3 0 1\nv 3 0 2\nv 3 1 1\nv 3 1 2\nv 3 2 1\nv 3 2 2\nv 2 2 1\nv 2 2 2\nv 1 2 1\nv 1 2 2\nv 2 3 1\nv 2 3 2\nv 1 3 1\nv 1 3 2\nv 0 3 1\nv 0 3 2\nv 1 4 1\nv 1 4 2\nv 0 4 1\nv 0 4 2\nv 1 5 1\nv 1 5 2\nv 0 5 1\nv 0 5 2\nv 2 4 1\nv 2 4 2\nv 2 5 1\nv 2 5 2\nv 3 4 1\nv 3 4 2\nv 3 5 1\nv 3 5 2\nf 1 2\nf 3 4\nf 1 3\nf 2 4\ninv\nf 1 4\ninv\nf 2 3\nf 2 5\nf 4 6\nf 5 6\ninv\nf 2 6\ninv\nf 5 4\nf 5 7\nf 6 8\nf 7 8\ninv\nf 5 8\ninv\nf 7 6\nf 7 1\nf 8 3\ninv\nf 7 3\ninv\nf 1 8\ninv\nf 1 5\ninv\nf 3 6\ninv\nf 1 6\ninv\nf 5 3\ninv\nf 2 7\ninv\nf 4 8\ninv\nf 2 8\ninv\nf 7 4\nf 2 9\nf 4 10\nf 9 10\ninv\nf 2 10\ninv\nf 9 4\nf 9 11\nf 10 12\nf 11 12\ninv\nf 9 12\ninv\nf 11 10\nf 11 5\nf 12 6\ninv\nf 11 6\ninv\nf 5 12\ninv\nf 2 11\ninv\nf 4 12\ninv\nf 2 12\ninv\nf 11 4\ninv\nf 9 5\ninv\nf 10 6\ninv\nf 9 6\ninv\nf 5 10\nf 9 13\nf 10 14\nf 13 14\ninv\nf 9 14\ninv\nf 13 10\nf 13 15\nf 14 16\nf 15 16\ninv\nf 13 16\ninv\nf 15 14\nf 15 11\nf 16 12\ninv\nf 15 12\ninv\nf 11 16\ninv\nf 9 15\ninv\nf 10 16\ninv\nf 9 16\ninv\nf 15 10\ninv\nf 13 11\ninv\nf 14 12\ninv\nf 13 12\ninv\nf 11 14\nf 15 17\nf 16 18\nf 17 18\ninv\nf 15 18\ninv\nf 17 16\nf 17 19\nf 18 20\nf 19 20\ninv\nf 17 20\ninv\nf 19 18\nf 19 11\nf 20 12\ninv\nf 19 12\ninv\nf 11 20\ninv\nf 11 17\ninv\nf 12 18\ninv\nf 11 18\ninv\nf 17 12\ninv\nf 15 19\ninv\nf 16 20\ninv\nf 15 20\ninv\nf 19 16\nf 21 19\nf 22 20\nf 21 22\ninv\nf 21 20\ninv\nf 19 22\nf 19 23\nf 20 24\nf 23 24\ninv\nf 19 24\ninv\nf 23 20\nf 23 25\nf 24 26\nf 25 26\ninv\nf 23 26\ninv\nf 25 24\nf 25 21\nf 26 22\ninv\nf 25 22\ninv\nf 21 26\ninv\nf 21 23\ninv\nf 22 24\ninv\nf 21 24\ninv\nf 23 22\ninv\nf 19 25\ninv\nf 20 26\ninv\nf 19 26\ninv\nf 25 20\nf 27 25\nf 28 26\nf 27 28\ninv\nf 27 26\ninv\nf 25 28\nf 25 29\nf 26 30\nf 29 30\ninv\nf 25 30\ninv\nf 29 26\nf 29 31\nf 30 32\nf 31 32\ninv\nf 29 32\ninv\nf 31 30\nf 31 27\nf 32 28\ninv\nf 31 28\ninv\nf 27 32\ninv\nf 27 29\ninv\nf 28 30\ninv\nf 27 30\ninv\nf 29 28\ninv\nf 25 31\ninv\nf 26 32\ninv\nf 25 32\ninv\nf 31 26\nf 29 33\nf 30 34\nf 33 34\ninv\nf 29 34\ninv\nf 33 30\nf 33 35\nf 34 36\nf 35 36\ninv\nf 33 36\ninv\nf 35 34\nf 35 31\nf 36 32\ninv\nf 35 32\ninv\nf 31 36\ninv\nf 31 33\ninv\nf 32 34\ninv\nf 31 34\ninv\nf 33 32\ninv\nf 29 35\ninv\nf 30 36\ninv\nf 29 36\ninv\nf 35 30\nf 29 37\nf 30 38\nf 37 38\ninv\nf 29 38\ninv\nf 37 30\nf 37 39\nf 38 40\nf 39 40\ninv\nf 37 40\ninv\nf 39 38\nf 39 33\nf 40 34\ninv\nf 39 34\ninv\nf 33 40\ninv\nf 29 39\ninv\nf 30 40\ninv\nf 29 40\ninv\nf 39 30\ninv\nf 37 33\ninv\nf 38 34\ninv\nf 37 34\ninv\nf 33 38\nf 37 41\nf 38 42\nf 41 42\ninv\nf 37 42\ninv\nf 41 38\nf 41 43\nf 42 44\nf 43 44\ninv\nf 41 44\ninv\nf 43 42\nf 43 39\nf 44 40\ninv\nf 43 40\ninv\nf 39 44\ninv\nf 37 43\ninv\nf 38 44\ninv\nf 37 44\ninv\nf 43 38\ninv\nf 41 39\ninv\nf 42 40\ninv\nf 41 40\ninv\nf 39 42\n";

      default:
      return "";
    }

  }

void drawTheText(float mysterybuttoncolor){
  int sometext[] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
    int imagewidth   =  608;
    int imageheight  =  16;
    int i=0;
    for(int y=height-16;y<(height-16)+imageheight;y++){
      for(int x=16;x<16+imagewidth;x++){
        color b = color((mysterybuttoncolor/255.0)* 0xC9,
                  (mysterybuttoncolor/255.0)  *0xF0,
                  (mysterybuttoncolor/255.0) * 0x8F);
        if(sometext[i]==0)setPixel(x,y,b);
        i++;
      }    
  }
}
///////////////////////////////////////////////////////
void darkenLine(int r,int g,int b, int x0,int y0,int x1, int y1){
  //copied and pasted from ORIGAMI
  if(x0<0 || x0>width || x1<0 || x1>width || y0<0 ||
                              y0>height || y1<0 || y1>height){
    return;
  }
  int dy = y1 - y0;
  int dx = x1 - x0;
  int stepx, stepy;
  if (dy < 0) { dy = -dy;  stepy = -1; } else {stepy = 1;}
  if (dx < 0) { dx = -dx;  stepx = -1; } else {stepx = 1;}
  dy <<= 1;
  dx <<= 1;
  //point(x0,y0);

  if (dx>dy) {
    int fraction=dy-(dx>>1);
    //int ogx0 = x0;
    //int ogy0 = y0;
    double d;
    while (x0!=x1){
      if(fraction>=0){
        y0 += stepy;
        fraction -= dx;
      }
      x0 += stepx;
      fraction += dy;
      //darken this pixel
      Color c;
      try{
        c = new Color(pixels[width*y0+x0]);
      }catch(ArrayIndexOutOfBoundsException e){
        c = Color.black;
      }

      int rr = c.getRed()-r;
      int gg = c.getGreen()-g;
      int bb = c.getBlue()-b;
      try{
        pixels[width*y0+x0] = (color(rr,gg,bb));
     }catch(ArrayIndexOutOfBoundsException e){}
       //p5.point(x0,y0);

     }
   }else {
     int fraction = dx - (dy>>1);
     //int ogx0 = x0;
     //int ogy0 = y0;
     double d;
     while (y0 != y1) {
       if (fraction >= 0) {
         x0 += stepx;
         fraction -= dy;
       }
       y0 += stepy;
       fraction += dx;
       //darken this pixel
       Color c;
       try{
         c = new Color(pixels[width*y0+x0]);
       }catch(ArrayIndexOutOfBoundsException e){
         c = Color.black;
       }
       int rr = c.getRed()-r;
       int gg = c.getGreen()-g;
       int bb = c.getBlue()-b;
       try{
         pixels[width*y0+x0] = (color(rr,gg,bb));
      }catch(ArrayIndexOutOfBoundsException e){}
        //p5.point(x0,y0);
      }
    }
  }




/**
 * The <code>Steppable</code> interface should be implemented by any
 * class whose instances can take steps, ie. animations, physics
 * simulations, timers. The class must define a method of no arguments
 * called <code>step</code>.
 * <p>
 * This interface provides a common protocol for objects that
 * can be driven by an Engine.
 * <p>
 *
 * @see     Engine
 */

public interface Steppable {
    /**
     * An Engine calls the <code>step</code> function while executing.
     * <p>
     * The method <code>step</code> may contain any code.
     */
    public abstract void step();
}


// the end

