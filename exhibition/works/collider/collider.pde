//  STRUCTURAL RULES: a variation on the clusters+diagram sketches
//  This includes a set of structural rules where elements requiring support seek other
//  elements of a different assembly to provide support.
//  by A. William Martin
//
//  Special thanks to Simon Greenwold, whose enthusiasm and skill have changed my life,
//    and to Jason van Nest, Matthew Jogan, and Mathew Ford, whose critical thought and
//    insight were invaluable.
//
//  This program was written with Arcball, DXFOut, and PSystem classes written by Simon
//    Greenwold, in Processing version 68 with hooks.



//  ************************************************************************************
//  Global variables and definitions.
//  ************************************************************************************


PSystem ps;
Arcball arcball;
DXFOut dxfOut;
Surface groundPlane;

final int NUMBER_OF_ASSEMBLY_TYPES=4;

final int RANDOM_PLANES_ASSEMBLY=0;
final int RANDOM_COLUMNS_ASSEMBLY=1;
final int GRID_ASSEMBLY=2;
final int CARTESIAN_PLANES_ASSEMBLY=3;

final int COLUMN_ELEMENT=1;
final int BEAM_ELEMENT=2;
final int FLOOR_ELEMENT=3;
final int WALL_ELEMENT=4;

final int PARTICLE_PROVIDES_SUPPORT=1;
final int PARTICLE_NEEDS_SUPPORT=2;
final int PARTICLE_PROVIDES_AND_NEEDS_SUPPORT=3;
final int PARTICLE_SUPPORTS_ONLY_IF_SUPPORTED=4;

final int NULL=0;
final int XY_PLANE=1;
final int XZ_PLANE=2;
final int YZ_PLANE=3;
final int X_AXIS=4;
final int Y_AXIS=5;
final int Z_AXIS=6;

final int DRAW_ALL=1;
final int DRAW_SUPPORTED=2;
final int DRAW_UNSUPPORTED=3;
final int DRAW_BUBBLE_DIAGRAM=4;

final float MIN_WALL_THICKNESS=1;

final int MAXIMUM_NUMBER_OF_ASSEMBLIES = 10;
Assembly assemblies[] = new Assembly[ MAXIMUM_NUMBER_OF_ASSEMBLIES ];


//  ************************************************************************************
//  GUI
//  ************************************************************************************

Button toggleArcball;
Button select[];
Slider nodeSize;

//  ************************************************************************************
//  Primary variables and initial values(where applicable);
//  ************************************************************************************

int numberOfAssemblies = 0;
int currentAssemblyType = RANDOM_PLANES_ASSEMBLY;
float zoomFactor = 1.0;
int visualization = DRAW_ALL;
BFont futura;
float zPosition=0;
boolean gui = true;
int fileNum=0;


//  ************************************************************************************
//  Main program setup() and loop().
//  ************************************************************************************


void setup(){
  dxfOut = (DXFOut)loadPlugin("DXFOut");
  dxfOut.setTriggerKey('w',"out0.dxf");
  size(800,500);
  noLights();
  futura = loadFont( "Futura-Medium.vlw.gz" );
  textFont( futura, 15 );
  
  arcball = (Arcball)loadPlugin("Arcball");
  ps = (PSystem)loadPlugin("PSystem");
  ps.setGravity(0);
  
  groundPlane = ps.loadSurface( "ground.obj" );
  
  toggleArcball = new Button( 10, height-20, 10, 10, "toggle rotation" );
  
  select = new Button[NUMBER_OF_ASSEMBLY_TYPES];
  for( int i=0;i<NUMBER_OF_ASSEMBLY_TYPES;i++ ){
    select[i] = new Button( 10, i*20+10, 10, 10, "" );
  }
  select[currentAssemblyType].switchColor();
  select[0].label = "random planes assembly";
  select[1].label = "random columns assembly";
  select[2].label = "grid assembly";
  select[3].label = "cartesian planes assembly";
  
  nodeSize = new Slider( width-220, 10, 200, 1, 101, 25 );
}

void loop(){
  background(255);
  
  dxfOut.DXFlayer(0);
  if(gui){
    toggleArcball.drawButton();
    if( toggleArcball.checkIfButtonPressed() ){
      arcball.enabled = !arcball.enabled;
    }

    for( int i=0;i<NUMBER_OF_ASSEMBLY_TYPES;i++ ){
      select[i].drawButton();
      if( select[i].checkIfButtonPressed() ){
        select[currentAssemblyType].switchColor();
        currentAssemblyType=i;
        select[i].switchColor();
      }
    }
    
    stroke(#FF9900);
    fill(#FF9900);
    text( zoomFactor, width-45, height-10 );
    
    nodeSize.updateSlider();
  }
  
  checkForAllPossibleConnections();
  

  translate( width/2, height/2 );
  scale( zoomFactor );
  arcball.run();

  if(gui) drawZPlane();

  dxfOut.DXFlayer(2); 
  stroke(0,100,100,50);
  fill(0,50,50,50);
  groundPlane.draw();
  
  for( int i=0;i<numberOfAssemblies;i++){
    assemblies[i].updateAssembly();
    assemblies[i].drawAssembly();
  }

  if(gui) drawCrosshairs();

  ps.draw();
}


//  ************************************************************************************
//  Keyboard handling.
//  ************************************************************************************

void keyPressed(){
  if(key=='0'){gui=!gui;}
  if(key=='1'){visualization=DRAW_ALL;}
  if(key=='2'){visualization=DRAW_SUPPORTED;}
  if(key=='3'){visualization=DRAW_UNSUPPORTED;}
  if(key=='4'){visualization=DRAW_BUBBLE_DIAGRAM;}
  if(key==' '){arcball.enabled=!arcball.enabled;}
  if(key=='-'){zoomFactor-=.1;}
  if(key=='='||key=='+'){zoomFactor+=.1;}
  if(key=='w'){fileNum++;
    dxfOut.setTriggerKey('w',"out"+fileNum+".dxf");}
}



//  ************************************************************************************
//  Primary class definitions
//  ************************************************************************************


class Assembly{
  int type;
  int numberOfElements;
  Element elements[];
  float position[] = new float[3];
  float size;
  
  SelectableParticle center;
  
  public Assembly( int type, float size, float x, float y, float z ){
    println( "New assembly created." );
    
    this.type = type;
    this.size = size;
    position[0]=x; position[1]=y; position[2]=z;
    
    center = new SelectableParticle( nodeSize.value );
    ps.addParticle( center );
    center.setPos( position[0], position[1], position[2] );
    
    int select;
    if( type==RANDOM_PLANES_ASSEMBLY ){
      numberOfElements = 20;
      elements = new Element[numberOfElements];
      float tempPos[] = new float[3];
      for( int i=0;i<numberOfElements;i++){
        select = (int)random(0,1.999999999);
        for( int k=0;k<3;k++ ){ tempPos[k]=position[k]+random(-size/2,size/2); }
        if( select==0 ){
          elements[i] = new Element( type, FLOOR_ELEMENT, i, NULL, tempPos );
        }
        else{
          elements[i] = new Element( type, WALL_ELEMENT, i, NULL, tempPos );
        }
      }
    }
    if( type==RANDOM_COLUMNS_ASSEMBLY ){
      numberOfElements = 16;
      elements = new Element[numberOfElements];
      float tempPos[] = new float[3];
      
      for( int r=0;r<4;r++){
        for( int c=0;c<4;c++){
          tempPos[0] = (size*(float)c)/3-size/2 + position[0];
          tempPos[1] = (size*(float)r)/3-size/2 + position[1];
          tempPos[2] = 0 + position[2];
          elements[r*4+c] = new Element( type, COLUMN_ELEMENT, r*4+c, NULL, tempPos );
          elements[r*4+c].contactPoints[0].pos[2]=elements[r*4+c].position[2]+random(-75,75);
          elements[r*4+c].contactPoints[1].pos[2]=elements[r*4+c].position[2]-elements[r*4+c].dimensions[2];
        }
      }
    }
    if( type==GRID_ASSEMBLY ){
      numberOfElements = 48;
      elements = new Element[numberOfElements];
      float tempPos[] = new float[3];
      
      for( int r=0;r<4;r++){
        for( int c=0;c<4;c++){
          tempPos[0] = (size*(float)c)/3-size/2 + position[0];
          tempPos[1] = (size*(float)r)/3-size/2 + position[1];
          tempPos[2] = 0 + position[2];
          elements[r*4+c] = new Element( type, COLUMN_ELEMENT, r*4+c, NULL, tempPos );
        }
      }
      for( int r=0;r<4;r++){
        for( int c=0;c<4;c++){
          tempPos[0] = (size*(float)c)/3-size/2 + position[0];
          tempPos[1] = 0 + position[1];
          tempPos[2] = (size*(float)r)/3-size/2 + position[2];
          elements[r*4+c+16] = new Element( type, BEAM_ELEMENT, r*4+c+16, Y_AXIS, tempPos );
        }
      }
      for( int r=0;r<4;r++){
        for( int c=0;c<4;c++){
          tempPos[0] = 0 + position[0];
          tempPos[1] = (size*(float)c)/3-size/2 + position[1];
          tempPos[2] = (size*(float)r)/3-size/2 + position[2];
          elements[r*4+c+32] = new Element( type, BEAM_ELEMENT, r*4+c+32, X_AXIS, tempPos );
        }
      }
      
    }
    if( type==CARTESIAN_PLANES_ASSEMBLY ){
      numberOfElements = 108;
      elements = new Element[numberOfElements];
      float tempPos[] = new float[3];
      
      for( float l=0;l<4;l++ ){
        for( float r=0;r<3;r++ ){
          for( float c=0;c<3;c++ ){
            tempPos[0] = (r-1)*(size/3) + position[0];
            tempPos[1] = (c-1)*(size/3) + position[1];
            tempPos[2] = (l-1)*(size/3) + position[2] - size/6;
            elements[(int)(l*9+r*3+c)] = new Element( type, FLOOR_ELEMENT, (int)(l*9+r*3+c), NULL, tempPos );
          }
        }
      }
      
      for( float l=0;l<4;l++ ){
        for( float r=0;r<3;r++ ){
          for( float c=0;c<3;c++ ){
            tempPos[0] = (r-1)*(size/3) + position[0];
            tempPos[1] = (l-1)*(size/3) + position[1] - size/6;
            tempPos[2] = (c-1)*(size/3) + position[2];
            elements[(int)(l*9+r*3+c)+36] = new Element( type, WALL_ELEMENT, (int)(l*9+r*3+c)+36, XZ_PLANE, tempPos );
          }
        }
      }
      
      for( float l=0;l<4;l++ ){
        for( float r=0;r<3;r++ ){
          for( float c=0;c<3;c++ ){
            tempPos[0] = (l-1)*(size/3) + position[0] - size/6;
            tempPos[1] = (r-1)*(size/3) + position[1];
            tempPos[2] = (c-1)*(size/3) + position[2];
            elements[(int)(l*9+r*3+c)+72] = new Element( type, WALL_ELEMENT, (int)(l*9+r*3+c)+72, YZ_PLANE, tempPos );
          }
        }
      }
    }
    
  }
  
  void drawAssembly(){
    for( int i=0;i<numberOfElements;i++ ){
      elements[i].drawElement();
    }
  }
  
  void updateAssembly(){
    //  Check the position of the center particle and compare to the center variables of the Assembly.
    //  If they are different, loop through all Particles in all Elements and move.
    float diff[] = new float[3];
    if( center.pos[0] != position[0] || center.pos[1] != position[1] || center.pos[2] != position[2] ){
      for( int j=0;j<3;j++ ){
        diff[j] = center.pos[j] - position[j];
        position[j]+=diff[j];
        for( int i=0;i<numberOfElements;i++ ){
          elements[i].position[j]+=diff[j];
          for( int k=0;k<elements[i].numberOfContactPoints;k++ ){
            elements[i].contactPoints[k].pos[j]+=diff[j];
          }
        }
      }
    }
  }
}


class Element{
//  int currentNumberOfSupports;
//  int requiredNumberOfSupports;
  int type;
  float dimensions[] = new float[3];
  float position[] = new float[3];
  int assemblyType;
  int elementIndex;
  int orientation;
  
  boolean elementIsConnected;
  
  ContactParticle contactPoints[];
  int numberOfContactPoints;
  
  // CONSTRUCTOR: must generate a different form according to "type".
  public Element( int at, int typ, int index, int orientation, float pos[] ){
    assemblyType = at;
    type = typ;
    elementIndex = index;
    this.orientation = orientation;
    elementIsConnected = false;
    
    arrayCopy( position, pos );
    
    int select;    // Temporary variable for probability selection of wall element orientation: 50/50 xz-plane/yz-plane.

    if( type==FLOOR_ELEMENT && assemblyType==RANDOM_PLANES_ASSEMBLY ){   //Set up sizes first.
      dimensions[0] = random(0,50)+50;
      dimensions[1] = random(0,50)+50;
      dimensions[2] = 2;
    }
    if( type==FLOOR_ELEMENT && assemblyType==CARTESIAN_PLANES_ASSEMBLY ){
      dimensions[0] = 30;
      dimensions[1] = 30;
      dimensions[2] = 2;
    }
    if( type==WALL_ELEMENT && assemblyType==RANDOM_PLANES_ASSEMBLY ){
      for( int i=0;i<3;i++ ){
        dimensions[i] = random(0,50)+50;
      }
      select = (int)random(0,1.999999999);
      dimensions[select] = MIN_WALL_THICKNESS;
    }
    if( type==WALL_ELEMENT && assemblyType==CARTESIAN_PLANES_ASSEMBLY && orientation==XZ_PLANE ){
      dimensions[0] = 30;
      dimensions[1] = MIN_WALL_THICKNESS;
      dimensions[2] = 30;
    }
    if( type==WALL_ELEMENT && assemblyType==CARTESIAN_PLANES_ASSEMBLY && orientation==YZ_PLANE ){
      dimensions[0] = MIN_WALL_THICKNESS;
      dimensions[1] = 30;
      dimensions[2] = 30;
    }
    if( type==COLUMN_ELEMENT && assemblyType==RANDOM_COLUMNS_ASSEMBLY ){
      dimensions[0] = 2;
      dimensions[1] = 2;
      dimensions[2] = 100;
    }
    if( type==COLUMN_ELEMENT && assemblyType==GRID_ASSEMBLY ){
      dimensions[0] = 2;
      dimensions[1] = 2;
      dimensions[2] = 100;
    }
    if( type==BEAM_ELEMENT && assemblyType==GRID_ASSEMBLY ){
      if( orientation == X_AXIS ){
        dimensions[0] = 100;
        dimensions[1] = 2;
        dimensions[2] = 2;
      }
      if( orientation == Y_AXIS ){
        dimensions[0] = 2;
        dimensions[1] = 100;
        dimensions[2] = 2;
      }    
    }
    
    //Now create the particles and member construction.

    if( type==FLOOR_ELEMENT ){
      numberOfContactPoints = 4;
      contactPoints = new ContactParticle[ numberOfContactPoints ];
      for( int i=0;i<numberOfContactPoints;i++ ){
        contactPoints[i] = new ContactParticle( PARTICLE_SUPPORTS_ONLY_IF_SUPPORTED, elementIndex );
        ps.addParticle( contactPoints[i] );
      }
      contactPoints[0].setPos( position[0]-dimensions[0]/2, position[1]-dimensions[1]/2, position[2] );
      contactPoints[1].setPos( position[0]+dimensions[0]/2, position[1]-dimensions[1]/2, position[2] );
      contactPoints[2].setPos( position[0]-dimensions[0]/2, position[1]+dimensions[1]/2, position[2] );
      contactPoints[3].setPos( position[0]+dimensions[0]/2, position[1]+dimensions[1]/2, position[2] );
    }
    if( type==WALL_ELEMENT ){
      numberOfContactPoints = 4;
      contactPoints = new ContactParticle[ numberOfContactPoints ];
      for( int i=0;i<2;i++ ){
        contactPoints[i] = new ContactParticle( PARTICLE_PROVIDES_SUPPORT, elementIndex );
        ps.addParticle( contactPoints[i] );
      }
      for( int i=2;i<4;i++ ){
        contactPoints[i] = new ContactParticle( PARTICLE_NEEDS_SUPPORT, elementIndex );
        ps.addParticle( contactPoints[i] );
      }
      if( dimensions[0]==MIN_WALL_THICKNESS ){
        contactPoints[0].setPos( position[0], position[1]-dimensions[1]/2, position[2]+dimensions[2]/2 );
        contactPoints[1].setPos( position[0], position[1]+dimensions[1]/2, position[2]+dimensions[2]/2 );
        contactPoints[2].setPos( position[0], position[1]-dimensions[1]/2, position[2]-dimensions[2]/2 );
        contactPoints[3].setPos( position[0], position[1]+dimensions[1]/2, position[2]-dimensions[2]/2 );
      }
      else{
        contactPoints[0].setPos( position[0]-dimensions[0]/2, position[1], position[2]+dimensions[2]/2 );
        contactPoints[1].setPos( position[0]+dimensions[0]/2, position[1], position[2]+dimensions[2]/2 );
        contactPoints[2].setPos( position[0]-dimensions[0]/2, position[1], position[2]-dimensions[2]/2 );
        contactPoints[3].setPos( position[0]+dimensions[0]/2, position[1], position[2]-dimensions[2]/2 );
      }
    }
    if( type==COLUMN_ELEMENT ){
      numberOfContactPoints = 2;
      contactPoints = new ContactParticle[ numberOfContactPoints ];

      contactPoints[0] = new ContactParticle( PARTICLE_PROVIDES_SUPPORT, elementIndex );
      ps.addParticle( contactPoints[0] );
      contactPoints[0].setPos( position[0], position[1], position[2]+dimensions[2]/2 );

      contactPoints[1] = new ContactParticle( PARTICLE_NEEDS_SUPPORT, elementIndex );
      ps.addParticle( contactPoints[1] );
      contactPoints[1].setPos( position[0], position[1], position[2]-dimensions[2]/2 );
    }
    if( type==BEAM_ELEMENT && orientation == X_AXIS ){
      numberOfContactPoints = 2;
      contactPoints = new ContactParticle[ numberOfContactPoints ];
      
      contactPoints[0] = new ContactParticle( PARTICLE_SUPPORTS_ONLY_IF_SUPPORTED, elementIndex );
      ps.addParticle( contactPoints[0] );
      contactPoints[0].setPos( position[0]-dimensions[0]/2, position[1], position[2] );

      contactPoints[1] = new ContactParticle( PARTICLE_SUPPORTS_ONLY_IF_SUPPORTED, elementIndex );
      ps.addParticle( contactPoints[1] );
      contactPoints[1].setPos( position[0]+dimensions[0]/2, position[1], position[2] );
    }
    if( type==BEAM_ELEMENT && orientation == Y_AXIS ){
      numberOfContactPoints = 2;
      contactPoints = new ContactParticle[ numberOfContactPoints ];
      
      contactPoints[0] = new ContactParticle( PARTICLE_SUPPORTS_ONLY_IF_SUPPORTED, elementIndex );
      ps.addParticle( contactPoints[0] );
      contactPoints[0].setPos( position[0], position[1]-dimensions[1]/2, position[2] );

      contactPoints[1] = new ContactParticle( PARTICLE_SUPPORTS_ONLY_IF_SUPPORTED, elementIndex );
      ps.addParticle( contactPoints[1] );
      contactPoints[1].setPos( position[0], position[1]+dimensions[1]/2, position[2] );
    }  }
  
  void updateElement(){
/*    if( type==COLUMN_ELEMENT && assemblyType==VERTICAL_COLUMNS_ASSEMBLY ){
      contactPoints[1].pos[0] = contactPoints[0].pos[0];
      contactPoints[1].pos[1] = contactPoints[0].pos[1];
    }*/
  }
  
  void drawElement(){
    
    updateElement();
    
    if( (elementIsConnected && (visualization==DRAW_ALL || visualization==DRAW_SUPPORTED)) ||
        (!elementIsConnected && (visualization==DRAW_ALL || visualization==DRAW_UNSUPPORTED)) ){
    
    push();
    if( elementIsConnected ){
      dxfOut.DXFlayer(1);
      stroke(128,128,128,150);
      fill(192,192,192,100);
    }
    else{
      dxfOut.DXFlayer(4);
      stroke(128,0,0,150);
      fill(192,0,0,25);
    }

    if( type==FLOOR_ELEMENT ){
      beginShape( QUADS );
        vertex( contactPoints[0] ); vertex(contactPoints[1]); vertex(contactPoints[3]); vertex(contactPoints[2]);

        vertex( contactPoints[0] ); vertex(contactPoints[1]); vertex(contactPoints[1].pos[0],contactPoints[1].pos[1],contactPoints[1].pos[2]+dimensions[2]); vertex(contactPoints[0].pos[0],contactPoints[0].pos[1],contactPoints[0].pos[2]+dimensions[2]);
        vertex( contactPoints[1] ); vertex(contactPoints[3]); vertex(contactPoints[3].pos[0],contactPoints[3].pos[1],contactPoints[3].pos[2]+dimensions[2]); vertex(contactPoints[1].pos[0],contactPoints[1].pos[1],contactPoints[1].pos[2]+dimensions[2]);
        vertex( contactPoints[3] ); vertex(contactPoints[2]); vertex(contactPoints[2].pos[0],contactPoints[2].pos[1],contactPoints[2].pos[2]+dimensions[2]); vertex(contactPoints[3].pos[0],contactPoints[3].pos[1],contactPoints[3].pos[2]+dimensions[2]);
        vertex( contactPoints[0] ); vertex(contactPoints[2]); vertex(contactPoints[2].pos[0],contactPoints[2].pos[1],contactPoints[2].pos[2]+dimensions[2]); vertex(contactPoints[0].pos[0],contactPoints[0].pos[1],contactPoints[0].pos[2]+dimensions[2]);

        vertex(contactPoints[0].pos[0],contactPoints[0].pos[1],contactPoints[0].pos[2]+dimensions[2]); vertex(contactPoints[1].pos[0],contactPoints[1].pos[1],contactPoints[1].pos[2]+dimensions[2]);
        vertex(contactPoints[3].pos[0],contactPoints[3].pos[1],contactPoints[3].pos[2]+dimensions[2]); vertex(contactPoints[2].pos[0],contactPoints[2].pos[1],contactPoints[2].pos[2]+dimensions[2]);
      endShape();
      }
    else if (type==WALL_ELEMENT){
      if( dimensions[0]==MIN_WALL_THICKNESS ){
        beginShape( QUADS );
          vertex(contactPoints[0].pos[0]-dimensions[0]/2,contactPoints[0].pos[1],contactPoints[0].pos[2]);vertex(contactPoints[1].pos[0]-dimensions[0]/2,contactPoints[1].pos[1],contactPoints[1].pos[2]);
          vertex(contactPoints[3].pos[0]-dimensions[0]/2,contactPoints[3].pos[1],contactPoints[3].pos[2]);vertex(contactPoints[2].pos[0]-dimensions[0]/2,contactPoints[2].pos[1],contactPoints[2].pos[2]);

          vertex(contactPoints[0].pos[0]-dimensions[0]/2,contactPoints[0].pos[1],contactPoints[0].pos[2]);vertex(contactPoints[0].pos[0]+dimensions[0]/2,contactPoints[0].pos[1],contactPoints[0].pos[2]);
          vertex(contactPoints[1].pos[0]+dimensions[0]/2,contactPoints[1].pos[1],contactPoints[1].pos[2]);vertex(contactPoints[1].pos[0]-dimensions[0]/2,contactPoints[1].pos[1],contactPoints[1].pos[2]);

          vertex(contactPoints[1].pos[0]-dimensions[0]/2,contactPoints[1].pos[1],contactPoints[1].pos[2]);vertex(contactPoints[1].pos[0]+dimensions[0]/2,contactPoints[1].pos[1],contactPoints[1].pos[2]);
          vertex(contactPoints[3].pos[0]+dimensions[0]/2,contactPoints[3].pos[1],contactPoints[3].pos[2]);vertex(contactPoints[3].pos[0]-dimensions[0]/2,contactPoints[3].pos[1],contactPoints[3].pos[2]);

          vertex(contactPoints[3].pos[0]-dimensions[0]/2,contactPoints[3].pos[1],contactPoints[3].pos[2]);vertex(contactPoints[3].pos[0]+dimensions[0]/2,contactPoints[3].pos[1],contactPoints[3].pos[2]);
          vertex(contactPoints[2].pos[0]+dimensions[0]/2,contactPoints[2].pos[1],contactPoints[2].pos[2]);vertex(contactPoints[2].pos[0]-dimensions[0]/2,contactPoints[2].pos[1],contactPoints[2].pos[2]);

          vertex(contactPoints[2].pos[0]-dimensions[0]/2,contactPoints[2].pos[1],contactPoints[2].pos[2]);vertex(contactPoints[2].pos[0]+dimensions[0]/2,contactPoints[2].pos[1],contactPoints[2].pos[2]);
          vertex(contactPoints[0].pos[0]+dimensions[0]/2,contactPoints[0].pos[1],contactPoints[0].pos[2]);vertex(contactPoints[0].pos[0]-dimensions[0]/2,contactPoints[0].pos[1],contactPoints[0].pos[2]);

          vertex(contactPoints[0].pos[0]+dimensions[0]/2,contactPoints[0].pos[1],contactPoints[0].pos[2]);vertex(contactPoints[1].pos[0]+dimensions[0]/2,contactPoints[1].pos[1],contactPoints[1].pos[2]);
          vertex(contactPoints[3].pos[0]+dimensions[0]/2,contactPoints[3].pos[1],contactPoints[3].pos[2]);vertex(contactPoints[2].pos[0]+dimensions[0]/2,contactPoints[2].pos[1],contactPoints[2].pos[2]);
        endShape();
      }
      else{
        beginShape( QUADS );
          vertex(contactPoints[0].pos[0],contactPoints[0].pos[1]-dimensions[1]/2,contactPoints[0].pos[2]);vertex(contactPoints[1].pos[0],contactPoints[1].pos[1]-dimensions[1]/2,contactPoints[1].pos[2]);
          vertex(contactPoints[3].pos[0],contactPoints[3].pos[1]-dimensions[1]/2,contactPoints[3].pos[2]);vertex(contactPoints[2].pos[0],contactPoints[2].pos[1]-dimensions[1]/2,contactPoints[2].pos[2]);

          vertex(contactPoints[0].pos[0],contactPoints[0].pos[1]-dimensions[1]/2,contactPoints[0].pos[2]);vertex(contactPoints[0].pos[0],contactPoints[0].pos[1]+dimensions[1]/2,contactPoints[0].pos[2]);
          vertex(contactPoints[1].pos[0],contactPoints[1].pos[1]+dimensions[1]/2,contactPoints[1].pos[2]);vertex(contactPoints[1].pos[0],contactPoints[1].pos[1]-dimensions[1]/2,contactPoints[1].pos[2]);

          vertex(contactPoints[1].pos[0],contactPoints[1].pos[1]-dimensions[1]/2,contactPoints[1].pos[2]);vertex(contactPoints[1].pos[0],contactPoints[1].pos[1]+dimensions[1]/2,contactPoints[1].pos[2]);
          vertex(contactPoints[3].pos[0],contactPoints[3].pos[1]+dimensions[1]/2,contactPoints[3].pos[2]);vertex(contactPoints[3].pos[0],contactPoints[3].pos[1]-dimensions[1]/2,contactPoints[3].pos[2]);

          vertex(contactPoints[3].pos[0],contactPoints[3].pos[1]-dimensions[1]/2,contactPoints[3].pos[2]);vertex(contactPoints[3].pos[0],contactPoints[3].pos[1]+dimensions[1]/2,contactPoints[3].pos[2]);
          vertex(contactPoints[2].pos[0],contactPoints[2].pos[1]+dimensions[1]/2,contactPoints[2].pos[2]);vertex(contactPoints[2].pos[0],contactPoints[2].pos[1]-dimensions[1]/2,contactPoints[2].pos[2]);

          vertex(contactPoints[2].pos[0],contactPoints[2].pos[1]-dimensions[1]/2,contactPoints[2].pos[2]);vertex(contactPoints[2].pos[0],contactPoints[2].pos[1]+dimensions[1]/2,contactPoints[2].pos[2]);
          vertex(contactPoints[0].pos[0],contactPoints[0].pos[1]+dimensions[1]/2,contactPoints[0].pos[2]);vertex(contactPoints[0].pos[0],contactPoints[0].pos[1]-dimensions[1]/2,contactPoints[0].pos[2]);

          vertex(contactPoints[0].pos[0],contactPoints[0].pos[1]+dimensions[1]/2,contactPoints[0].pos[2]);vertex(contactPoints[1].pos[0],contactPoints[1].pos[1]+dimensions[1]/2,contactPoints[1].pos[2]);
          vertex(contactPoints[3].pos[0],contactPoints[3].pos[1]+dimensions[1]/2,contactPoints[3].pos[2]);vertex(contactPoints[2].pos[0],contactPoints[2].pos[1]+dimensions[1]/2,contactPoints[2].pos[2]);
        endShape();      
      }
    }
    else if( type==COLUMN_ELEMENT ){
      beginShape( QUADS );
        vertex( contactPoints[0].pos[0]-dimensions[0]/2, contactPoints[0].pos[1]-dimensions[1]/2, contactPoints[0].pos[2] );
        vertex( contactPoints[0].pos[0]-dimensions[0]/2, contactPoints[0].pos[1]+dimensions[1]/2, contactPoints[0].pos[2] );
        vertex( contactPoints[0].pos[0]+dimensions[0]/2, contactPoints[0].pos[1]+dimensions[1]/2, contactPoints[0].pos[2] );
        vertex( contactPoints[0].pos[0]+dimensions[0]/2, contactPoints[0].pos[1]-dimensions[1]/2, contactPoints[0].pos[2] );

        vertex( contactPoints[1].pos[0]-dimensions[0]/2, contactPoints[1].pos[1]-dimensions[1]/2, contactPoints[1].pos[2] );
        vertex( contactPoints[1].pos[0]-dimensions[0]/2, contactPoints[1].pos[1]+dimensions[1]/2, contactPoints[1].pos[2] );
        vertex( contactPoints[1].pos[0]+dimensions[0]/2, contactPoints[1].pos[1]+dimensions[1]/2, contactPoints[1].pos[2] );
        vertex( contactPoints[1].pos[0]+dimensions[0]/2, contactPoints[1].pos[1]-dimensions[1]/2, contactPoints[1].pos[2] );
      endShape();
      beginShape( QUAD_STRIP );
        vertex( contactPoints[0].pos[0]-dimensions[0]/2, contactPoints[0].pos[1]-dimensions[1]/2, contactPoints[0].pos[2] );
        vertex( contactPoints[1].pos[0]-dimensions[0]/2, contactPoints[1].pos[1]-dimensions[1]/2, contactPoints[1].pos[2] );
        vertex( contactPoints[1].pos[0]-dimensions[0]/2, contactPoints[1].pos[1]+dimensions[1]/2, contactPoints[1].pos[2] );
        vertex( contactPoints[0].pos[0]-dimensions[0]/2, contactPoints[0].pos[1]+dimensions[1]/2, contactPoints[0].pos[2] );
        vertex( contactPoints[0].pos[0]+dimensions[0]/2, contactPoints[0].pos[1]+dimensions[1]/2, contactPoints[0].pos[2] );
        vertex( contactPoints[1].pos[0]+dimensions[0]/2, contactPoints[1].pos[1]+dimensions[1]/2, contactPoints[1].pos[2] );
        vertex( contactPoints[1].pos[0]+dimensions[0]/2, contactPoints[1].pos[1]-dimensions[1]/2, contactPoints[1].pos[2] );
        vertex( contactPoints[0].pos[0]+dimensions[0]/2, contactPoints[0].pos[1]-dimensions[1]/2, contactPoints[0].pos[2] );
        vertex( contactPoints[0].pos[0]-dimensions[0]/2, contactPoints[0].pos[1]-dimensions[1]/2, contactPoints[0].pos[2] );
        vertex( contactPoints[1].pos[0]-dimensions[0]/2, contactPoints[1].pos[1]-dimensions[1]/2, contactPoints[1].pos[2] );
      endShape();
    }
    else if( type==BEAM_ELEMENT &&  orientation == X_AXIS ){
      beginShape( QUADS );
        vertex( contactPoints[0].pos[0]-1, contactPoints[0].pos[1]-dimensions[1]/2, contactPoints[0].pos[2]-dimensions[2]/2 );
        vertex( contactPoints[0].pos[0]-1, contactPoints[0].pos[1]+dimensions[1]/2, contactPoints[0].pos[2]-dimensions[2]/2 );
        vertex( contactPoints[0].pos[0]-1, contactPoints[0].pos[1]+dimensions[1]/2, contactPoints[0].pos[2]+dimensions[2]/2 );
        vertex( contactPoints[0].pos[0]-1, contactPoints[0].pos[1]-dimensions[1]/2, contactPoints[0].pos[2]+dimensions[2]/2 );

        vertex( contactPoints[1].pos[0]+1, contactPoints[1].pos[1]-dimensions[1]/2, contactPoints[1].pos[2]-dimensions[2]/2 );
        vertex( contactPoints[1].pos[0]+1, contactPoints[1].pos[1]+dimensions[1]/2, contactPoints[1].pos[2]-dimensions[2]/2 );
        vertex( contactPoints[1].pos[0]+1, contactPoints[1].pos[1]+dimensions[1]/2, contactPoints[1].pos[2]+dimensions[2]/2 );
        vertex( contactPoints[1].pos[0]+1, contactPoints[1].pos[1]-dimensions[1]/2, contactPoints[1].pos[2]+dimensions[2]/2 );
      endShape();
      beginShape( QUAD_STRIP );
        vertex( contactPoints[0].pos[0]-1, contactPoints[0].pos[1]-dimensions[1]/2, contactPoints[0].pos[2]-dimensions[2]/2 );
        vertex( contactPoints[1].pos[0]+1, contactPoints[1].pos[1]-dimensions[1]/2, contactPoints[1].pos[2]-dimensions[2]/2 );
        vertex( contactPoints[1].pos[0]+1, contactPoints[1].pos[1]+dimensions[1]/2, contactPoints[1].pos[2]-dimensions[2]/2 );
        vertex( contactPoints[0].pos[0]-1, contactPoints[0].pos[1]+dimensions[1]/2, contactPoints[0].pos[2]-dimensions[2]/2 );
        vertex( contactPoints[0].pos[0]-1, contactPoints[0].pos[1]+dimensions[1]/2, contactPoints[0].pos[2]+dimensions[2]/2 );
        vertex( contactPoints[1].pos[0]+1, contactPoints[1].pos[1]+dimensions[1]/2, contactPoints[1].pos[2]+dimensions[2]/2 );
        vertex( contactPoints[1].pos[0]+1, contactPoints[1].pos[1]-dimensions[1]/2, contactPoints[1].pos[2]+dimensions[2]/2 );
        vertex( contactPoints[0].pos[0]-1, contactPoints[0].pos[1]-dimensions[1]/2, contactPoints[0].pos[2]+dimensions[2]/2 );
        vertex( contactPoints[0].pos[0]-1, contactPoints[0].pos[1]-dimensions[1]/2, contactPoints[0].pos[2]-dimensions[2]/2 );
        vertex( contactPoints[1].pos[0]+1, contactPoints[1].pos[1]-dimensions[1]/2, contactPoints[1].pos[2]-dimensions[2]/2 );
      endShape();
    }
    else if( type==BEAM_ELEMENT &&  orientation == Y_AXIS ){
      beginShape( QUADS );
        vertex( contactPoints[0].pos[0]-dimensions[0]/2, contactPoints[0].pos[1]-1, contactPoints[0].pos[2]-dimensions[2]/2 );
        vertex( contactPoints[0].pos[0]+dimensions[0]/2, contactPoints[0].pos[1]-1, contactPoints[0].pos[2]-dimensions[2]/2 );
        vertex( contactPoints[0].pos[0]+dimensions[0]/2, contactPoints[0].pos[1]-1, contactPoints[0].pos[2]+dimensions[2]/2 );
        vertex( contactPoints[0].pos[0]-dimensions[0]/2, contactPoints[0].pos[1]-1, contactPoints[0].pos[2]+dimensions[2]/2 );

        vertex( contactPoints[1].pos[0]-dimensions[0]/2, contactPoints[1].pos[1]+1, contactPoints[1].pos[2]-dimensions[2]/2 );
        vertex( contactPoints[1].pos[0]+dimensions[0]/2, contactPoints[1].pos[1]+1, contactPoints[1].pos[2]-dimensions[2]/2 );
        vertex( contactPoints[1].pos[0]+dimensions[0]/2, contactPoints[1].pos[1]+1, contactPoints[1].pos[2]+dimensions[2]/2 );
        vertex( contactPoints[1].pos[0]-dimensions[0]/2, contactPoints[1].pos[1]+1, contactPoints[1].pos[2]+dimensions[2]/2 );
      endShape();
      beginShape( QUAD_STRIP );
        vertex( contactPoints[0].pos[0]-dimensions[0]/2, contactPoints[0].pos[1]-1, contactPoints[0].pos[2]-dimensions[2]/2 );
        vertex( contactPoints[1].pos[0]-dimensions[0]/2, contactPoints[1].pos[1]+1, contactPoints[1].pos[2]-dimensions[2]/2 );
        vertex( contactPoints[1].pos[0]+dimensions[0]/2, contactPoints[1].pos[1]+1, contactPoints[1].pos[2]-dimensions[2]/2 );
        vertex( contactPoints[0].pos[0]+dimensions[0]/2, contactPoints[0].pos[1]-1, contactPoints[0].pos[2]-dimensions[2]/2 );
        vertex( contactPoints[0].pos[0]+dimensions[0]/2, contactPoints[0].pos[1]-1, contactPoints[0].pos[2]+dimensions[2]/2 );
        vertex( contactPoints[1].pos[0]+dimensions[0]/2, contactPoints[1].pos[1]+1, contactPoints[1].pos[2]+dimensions[2]/2 );
        vertex( contactPoints[1].pos[0]-dimensions[0]/2, contactPoints[1].pos[1]+1, contactPoints[1].pos[2]+dimensions[2]/2 );
        vertex( contactPoints[0].pos[0]-dimensions[0]/2, contactPoints[0].pos[1]-1, contactPoints[0].pos[2]+dimensions[2]/2 );
        vertex( contactPoints[0].pos[0]-dimensions[0]/2, contactPoints[0].pos[1]-1, contactPoints[0].pos[2]-dimensions[2]/2 );
        vertex( contactPoints[1].pos[0]-dimensions[0]/2, contactPoints[1].pos[1]+1, contactPoints[1].pos[2]-dimensions[2]/2 );
      endShape();
    }
    else{
      translate( position[0], position[1], position[2] );
      box( dimensions[0], dimensions[1], dimensions[2] );
    }
    pop();
  }
  }
}




class ContactParticle extends Particle{
  boolean particleIsSupportingAnotherElement;
  boolean particleIsBeingSupported;
  
  int numberOfOwningAssembly;
  int numberOfOwningElement;
  int type;  
  float seekingRadius;  //  When a particle which provides support comes into the radius of
                      //  particle that needs support, a spring is created between them.
  
  public ContactParticle( int type , int numberOfOwningElement ){
    this.type = type;
    this.numberOfOwningElement = numberOfOwningElement;
    particleIsSupportingAnotherElement = false;
    particleIsBeingSupported = false;
    seekingRadius = 10.0;
    numberOfOwningAssembly = numberOfAssemblies;   //Sets variable at creation, before numberOfAssemblies is incremented.
  }
  
  void lookForPossibleConnections(){
    if( !particleIsSupportingAnotherElement && (type==PARTICLE_PROVIDES_SUPPORT || 
        type==PARTICLE_PROVIDES_AND_NEEDS_SUPPORT || (type==PARTICLE_SUPPORTS_ONLY_IF_SUPPORTED && particleIsBeingSupported)) ) {
      //  Particle looks for another particle in a different Assembly and of the correct element
      //  type to support within the seeking radius(seekingRadius).
      for( int i=0;i<numberOfAssemblies;i++ ){
        if( i!=numberOfOwningAssembly ){
          for( int j=0;j<assemblies[i].numberOfElements;j++ ){
            for( int k=0;k<assemblies[i].elements[j].numberOfContactPoints;k++){
              if( distParticles( this, assemblies[i].elements[j].contactPoints[k] ) < seekingRadius && 
                (assemblies[i].elements[j].contactPoints[k].type==PARTICLE_NEEDS_SUPPORT ||
                  assemblies[i].elements[j].contactPoints[k].type==PARTICLE_PROVIDES_AND_NEEDS_SUPPORT ||
                  assemblies[i].elements[j].contactPoints[k].type==PARTICLE_SUPPORTS_ONLY_IF_SUPPORTED ) ){
                  Spring s = new Spring( this, assemblies[i].elements[j].contactPoints[k] );
                  ps.addForce( s );
                  s.strength = .3;
                  s.restLength = 0.1;
                  s.damping=.1;
                  
                  particleIsSupportingAnotherElement = true;
                  assemblies[i].elements[j].contactPoints[k].particleIsBeingSupported = true;
                  assemblies[numberOfOwningAssembly].elements[numberOfOwningElement].elementIsConnected=true;
                  assemblies[i].elements[j].elementIsConnected=true;
              }
            }
          }
        }
      }
    }
    if( type==PARTICLE_NEEDS_SUPPORT || type==PARTICLE_PROVIDES_AND_NEEDS_SUPPORT || type==PARTICLE_SUPPORTS_ONLY_IF_SUPPORTED ){
      //  Particle looks for another particle in a different Assembly and of the correct element
      //  type that provides support within the seeking radius(seekingRadius).
    }
  }
  
  void draw(){
    if( type==PARTICLE_PROVIDES_SUPPORT ){
      stroke( 0,0,128 );
      fill( 0,0,128 );
    }
    if( type==PARTICLE_NEEDS_SUPPORT ){
      stroke( 128,0,0 );
      fill( 128,0,0 );
    }
    if( type==PARTICLE_SUPPORTS_ONLY_IF_SUPPORTED ){
      stroke( 128,0,128 );
      fill( 128,0,128 );
    }
    push();
    dxfOut.DXFlayer(3);
    translate( pos[0],pos[1],pos[2] );
    box(1);
    pop();
  }

}


void checkForAllPossibleConnections(){
  if( numberOfAssemblies>1 ){
    for( int i=0;i<numberOfAssemblies;i++ ){
      for( int j=0;j<assemblies[i].numberOfElements;j++ ){
        for( int k=0;k<assemblies[i].elements[j].numberOfContactPoints;k++){
          assemblies[i].elements[j].contactPoints[k].lookForPossibleConnections();
        }
      }
    }
  }
}




//  ************************************************************************************
//  Utility functions.
//  ************************************************************************************

float distParticles( Particle a, Particle b ){
  return dist(a.pos[0],a.pos[1],a.pos[2],b.pos[0],b.pos[1],b.pos[2]);
}

void vertex( Particle a ){
  vertex( a.pos[0], a.pos[1], a.pos[2] );
}

void arrayCopy( float array1[], float array2[] ){
  for( int i=0;i<array1.length;i++ ){
    array1[i] = array2[i];
  }
}
  





//  ************************************************************************************
//  SelectableParticle class and bubble diagram stuff.
//  ************************************************************************************


class SelectableParticle extends Particle{

  boolean wait = false;
  boolean hover = false;
  boolean selected = false;

  float radius;

  public SelectableParticle( float radius ) {
    this.radius = radius;
    enableCollision( radius );
  }

  void draw() {
    float d, scX, scY;

    push();
    scX = screenX( pos[0], pos[1], pos[2] );
    scY = screenY( pos[0], pos[1], pos[2] );
    d = dist( mouseX, mouseY, scX, scY );
    
    dxfOut.DXFlayer(0);
    translate(pos[0],pos[1],pos[2]);
    stroke(192);
    fill(192);
    box(3);
    if(visualization==DRAW_BUBBLE_DIAGRAM){
      noStroke();
      fill(128,128,128,100);
      sphere( radius );
    }

    if( d<selectRadius ){ hover=true; }else{ hover=false; }
    
    if( selected || hover ){
      stroke(255,0,0);
      fill(255,0,0);
      box(3);
    }
    pop();
  }
}


final int selectRadius=50;

boolean leftMouseButtonPressed = false;
boolean createAssembly=false;
boolean wait=false;

int numFirstSelectedParticle = -1;

float lastX, lastY;
boolean middleMouseButtonDown = false;

boolean mouseNotOverAnyGUI(){
  if( toggleArcball.mouseOverButton() ) return false;
  for(int i=0;i<NUMBER_OF_ASSEMBLY_TYPES;i++ ){
    if( select[i].mouseOverButton() ) return false;
  }
  if( mouseY<20 ) return false;
  return true;
}

void drawZPlane(){
  rectMode( CORNERS );
  stroke(128);
  fill(255,255,255,50);
  push();
  translate(0,0,zPosition);
    push();
    stroke(0,0,255);
    fill(0,0,255);    
    translate(-300,300);
    box(3);
    pop();
  stroke(224);
  for( int y=-25;y<=25;y++ ){
    line( y*12, -300, y*12, 300 );
  }
  for( int x=-25;x<=25;x++ ){
    line( -300, x*12, 300, x*12 );
  }
  stroke(128);
  fill(255,255,255,50);  
  rect(-300,-300,300,300);
  for( int y=-5;y<=5;y++ ){
    line( y*60, -300, y*60, 300 );
  }
  for( int x=-5;x<=5;x++ ){
    line( -300, x*60, 300, x*60 );
  }
  pop();
}

void drawCrosshairs(){
  stroke(255,0,0);
  line(mouseX-10-width/2,mouseY-height/2,zPosition,mouseX+10-width/2,mouseY-height/2,zPosition);
  line(mouseX-width/2,mouseY-10-height/2,zPosition,mouseX-width/2,mouseY+10-height/2,zPosition);
  line(mouseX-width/2,mouseY-height/2,zPosition-10,mouseX-width/2,mouseY-height/2,zPosition+10);
}


void mouseDragged(){
  if( middleMouseButtonDown ){
    zPosition -= mouseY-lastY;
    lastX=mouseX;
    lastY=mouseY;
  }
}

void mousePressed(){
  if( mouseEvent.getButton() == MouseEvent.BUTTON2 ){
    lastX = mouseX;
    lastY = mouseY;
    arcball.fixed=true;
    middleMouseButtonDown = true;
  }
  
  if (mouseEvent.getButton() == MouseEvent.BUTTON1 && mouseNotOverAnyGUI() ) {
    leftMouseButtonPressed = true;
    createAssembly=true;
    
    int p=-1;
    for( int i=0;i<numberOfAssemblies;i++ ){
      if( assemblies[i].center.hover && !wait){
        createAssembly=false;
        p=i;
        println( "Hovering over node " + p + "." );
        break;
      }
    }
    
    if( numberOfAssemblies>0 && p>=0 ){
      if( numFirstSelectedParticle == -1 && !assemblies[p].center.selected){
        numFirstSelectedParticle=p;
        println( "Node " + numFirstSelectedParticle + " selected." );
        assemblies[p].center.selected = true;
        wait=true;
        createAssembly=false;
        return;
      }
      if( numFirstSelectedParticle == p ){
        assemblies[numFirstSelectedParticle].center.selected=false;
        numFirstSelectedParticle = -1;
        assemblies[p].center.selected = false;
        wait = true;
        createAssembly=false;
        return;
      }
      if( numFirstSelectedParticle != -1 && numFirstSelectedParticle != p ){
        println("Make spring between nodes " + numFirstSelectedParticle + " and " + p + ".");
        Spring s = new Spring( assemblies[p].center, assemblies[numFirstSelectedParticle].center );
        ps.addForce(s);
        assemblies[p].center.selected = false;
        assemblies[numFirstSelectedParticle].center.selected = false;
        numFirstSelectedParticle = -1;
        createAssembly=false;
        wait=true;
        return;
      }
    }
  if(createAssembly){createNewAssembly();}
  }
}

void mouseReleased(){
  leftMouseButtonPressed = false;
  wait = false;
  arcball.fixed = false;
  middleMouseButtonDown = false;
}

void createNewAssembly(){
  createAssembly=false;
  if( numberOfAssemblies < MAXIMUM_NUMBER_OF_ASSEMBLIES ){
    assemblies[numberOfAssemblies] = new Assembly( currentAssemblyType, 100, mouseX-width/2, mouseY-height/2, zPosition );
    numberOfAssemblies++;    
  }
}


//  ************************************************************************************
//  GUI classes: Button, Slider
//  ************************************************************************************


class Button {
  int xPos, yPos, xSize, ySize;
  boolean wait=false;
  color c1 = #FF9900;
  color c2 = #0066FF;
  color current;
  String label;
  
  public Button( int xPos, int yPos, int xSize, int ySize, String label ){
    this.xPos=xPos;
    this.yPos=yPos;
    this.xSize=xSize;
    this.ySize=ySize;
    this.label=label;
    current = c1;
  }
  
  boolean checkIfButtonPressed(){
    if( mousePressed && mouseOverButton() && !wait ){
      wait=true;
      return true;
    }
    if( mousePressed && mouseOverButton() && wait){
      return false;
    } 
    if( !mousePressed ){
      wait=false;
      return false;
    }
    return false;
  }
  
  void switchColor(){
    if( current == c1 ){
      current = c2;
    }
    else{
      current = c1;
    }
  }
  
  void drawButton(){
    rectMode(CORNER);
    stroke(current);
    fill(current);
    rect( xPos, yPos, xSize, ySize );
    text( label, xPos+xSize+3, yPos+ySize );
  }
  
  boolean mouseOverButton(){
    if( mouseX >= xPos && mouseX <= (xPos+xSize) && mouseY >= yPos && mouseY <= (yPos+ySize) ){
      return true;
    }
    return false;
  }
}


class Slider {

  float value, minValue, maxValue;
  float posX, posY, sLength;
  float sHeight = 3;
  color sliderBoxColor;
  float startValue;

  public Slider( float x, float y, float l, float minV, float maxV, float initV ){
    posX = x;
    posY = y;
    sLength = l;
    minValue = minV;
    maxValue = maxV;
    value = initV;
    startValue = initV;
    sliderBoxColor = color( 255, 153, 0 );
  }

  void setSliderColor( int r, int g, int b ){
    sliderBoxColor = color( r, g, b );
  }

  void drawSlider(){

    stroke(200);
    line( posX, posY, posX+sLength, posY );
    line( posX, posY-sHeight, posX, posY+sHeight );
    line( posX+sLength, posY-sHeight, posX+sLength, posY+sHeight );
    line( posX + sLength*((startValue-minValue)/(maxValue-minValue)), posY-sHeight, posX+ sLength*((startValue-minValue)/(maxValue-minValue)), posY+sHeight );
    rectMode( CENTER_DIAMETER );
    stroke( sliderBoxColor );
    fill( sliderBoxColor );
    rect( posX + sLength*((value-minValue)/(maxValue-minValue)), posY, sHeight*2, sHeight*2 );

  }

  void updateSlider(){
    if( mousePressed && mouseOverSlider() ){
      value = ((mouseX-posX)/sLength)*(maxValue-minValue)+minValue;
    }
  drawSlider();
  }
  
  boolean mouseOverSlider(){
    if( mouseX >= posX && mouseX <= (posX+sLength) && mouseY >= (posY-sHeight) && mouseY <= (posY+sHeight) ){
      return true;
    }
    return false;
  }

}
