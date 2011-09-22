// This code was written with the _ALPHA_ version 
// of Processing and may not run correctly in the 
// current version.


// wiggle
// created using processing application | www.processing.org
// copyright© www.uncontrol.com | mannytan@uncontrol.com

// ************************************************************************
// initialize
// ************************************************************************
// -----------------------------------
// dragger initializers
// -----------------------------------
boolean mouseStatus = false;          // drag rotation variables
boolean priorMouseStatus = false;
// -----------------------------------
// counters
// -----------------------------------
int i, j, k, x, y, z;
float worldRotationY=1;

// -----------------------------------
// circle initializers
// -----------------------------------
float X_OFFSET = 0;
float Y_OFFSET = 0;

int TOTAL_INCREMENT = 20;

int TOTAL_STACK = 10;
float STACK_SCALAR = 20;

int TOTAL_RINGS = 10;
int RING_SCALAR = 10;

float PLOTTER_SMOOTH = .5;		//smaller number - more smooth
float PLOTTER_ELASTICITY = .35;	        //smaller number

float PLOTTER_DEPTH_SMOOTH = .1;        //smaller number - more smooth
float PLOTTER_DEPTH_ELASTICITY = .6;	//smaller number

float[] tube_pos			 = new float[50];
float[] tube_radius 		 = new float[50];
float   tube_radiusIncrement = 1;

float tube_automatic;
int visualStatus = 1;
// -----------------------------------
// plotter initializers
// -----------------------------------
float[][] a_rot = new float[50][50];
float[][] b_rot = new float[50][50];
float[][] c_rot = new float[50][50];
float[][] d_rot = new float[50][50];
float[][] e_rot = new float[50][50];
float[][] f_rot = new float[50][50];

float[][] a_dep = new float[50][50];
float[][] b_dep = new float[50][50];
float[][] c_dep = new float[50][50];
float[][] d_dep = new float[50][50];
float[][] e_dep = new float[50][50];
float[][] f_dep = new float[50][50];
// -----------------------------------
// general initializers
// -----------------------------------
float[][][] x_pos = new float[50][50][50];
float[][][] y_pos = new float[50][50][50];
float[][][] z_pos = new float[50][50][50];
// ************************************************************************
// set up
// ************************************************************************
void setup() {
  size(400, 400);
  background(255);
  rectMode(CENTER_DIAMETER);
  ellipseMode(CENTER_DIAMETER);
  /*
  for (k=0; k<=TOTAL_STACK; k++) {
    tube_pos[k]=0;
  }
  */
}

// ************************************************************************
// listeners
// ************************************************************************
void mousePressed() {
  mouseStatus = true;
}
void mouseReleased() {
  mouseStatus = false;
}

void loop() {
  // ************************************************************************
  // start loop code here
  // ************************************************************************
  // -----------------------------------
  // tube_radius resize loop
  // -----------------------------------
  tube_pos[0] = mouseX;
  for (k=1; k<=TOTAL_STACK; k++) {
    tube_pos[k] = (tube_pos[k-1] - tube_pos[k])*.3 + tube_pos[k];
    tube_radius[k] = abs(tube_pos[k-1] - tube_pos[k])*.5;
  }
  tube_radiusIncrement++;

  for (k=0; k<=TOTAL_STACK; k++) {
    for (j=0; j<=(TOTAL_RINGS); j++) {
      // -----------------------------------
      // creates plotter data
      // -----------------------------------
      push();
      d_rot[k][j] = ((a_rot[k][j]-b_rot[k][j])*PLOTTER_SMOOTH)+b_rot[k][j];
      e_rot[k][j] = b_rot[k][j]-( b_rot[k][j]-c_rot[k][j])-(b_rot[k][j]-d_rot[k][j] );
      f_rot[k][j] = e_rot[k][j]-((b_rot[k][j]-e_rot[k][j])*PLOTTER_ELASTICITY);

      d_dep[k][j] = ((a_dep[k][j]-b_dep[k][j])*PLOTTER_DEPTH_SMOOTH)+b_dep[k][j];
      e_dep[k][j] = b_dep[k][j]-( b_dep[k][j]-c_dep[k][j])-(b_dep[k][j]-d_dep[k][j] );
      f_dep[k][j] = e_dep[k][j]-((b_dep[k][j]-e_dep[k][j])*PLOTTER_DEPTH_ELASTICITY);

      if (k==0 && j==0) {
        a_rot[k][j] = b_rot[ 0 ][ 0 ] = mouseX*.03;
        a_dep[k][j] = b_dep[ 0 ][ 0 ] = mouseY*.1;
      } else if (k==0 && j!=0) {
        a_rot[k][j] = b_rot[ 0 ][j-1];
        a_dep[k][j] = b_dep[ 0 ][j-1];
      } else if (k!=0 && j==0) {
        a_rot[k][j] = b_rot[k-1][ 0 ];
        a_dep[k][j] = b_dep[k-1][ 0 ];
      } else if (k!=0 && j!=0) {
        a_rot[k][j] = b_rot[ k ][j-1];
        a_dep[k][j] = b_dep[ k ][j-1];
      }

      b_rot[k][j] = e_rot[k][j];
      c_rot[k][j] = f_rot[k][j];

      b_dep[k][j] = e_dep[k][j];
      c_dep[k][j] = f_dep[k][j];
      pop();

      // -----------------------------------
      // sinusoidal script
      // -----------------------------------
      for (i=0; i<=TOTAL_INCREMENT; i++) {
        push();
        x_pos[k][j][i] = sin((i + (b_rot[k][j]  ))*TWO_PI/TOTAL_INCREMENT)*(tube_radius[k]+(j*RING_SCALAR+(tube_radius[k]*.5))) + X_OFFSET;
        y_pos[k][j][i] = cos((i + (b_rot[k][j]  ))*TWO_PI/TOTAL_INCREMENT)*(tube_radius[k]+(j*RING_SCALAR+(tube_radius[k]*.5))) + Y_OFFSET;
        z_pos[k][j][i] = tube_radius[k] + (k*STACK_SCALAR) + (b_dep[k][j]) - 100;
        pop();
      }
    }
  }

  // -----------------------------------
  // global movement
  // -----------------------------------
  translate(width/2, height/2);
  rotateY(worldRotationY);
  rotateX(PI/4.0);
  worldRotationY+=.004;

  for (k=1; k<=TOTAL_STACK; k++) {
    for (j=1; j<=TOTAL_RINGS; j++) {
      for (i=1; i<=TOTAL_INCREMENT; i++) {
        if (j!=1) {
          if (visualStatus==1) {
            strokeWidth(1);
            stroke((173+(j*7)),(163+(j*7)),(153+(j*7)));
            line(x_pos[k][j][i], y_pos[k][j][i], z_pos[k][j][i], x_pos[k][j-1][i], y_pos[k][j-1][i], z_pos[k][j-1][i]);

          } else if (visualStatus==2 && (j%2)==1) {
            strokeWidth(1);
            stroke((173+(k*5)),(163+(k*5)),(153+(k*5)));
            line(x_pos[k][j][i], y_pos[k][j][i], z_pos[k][j][i], x_pos[k][j][i-1], y_pos[k][j][i-1], z_pos[k][j][i-1]);

          } else if (visualStatus==3 && k!=1 && (j%2)==1) {
            strokeWidth(1);
            stroke((173+(k*7)),(163+(k*7)),(153+(k*7)));
            line(x_pos[k][j][i], y_pos[k][j][i], z_pos[k][j][i], x_pos[k-1][j][i], y_pos[k-1][j][i], z_pos[k-1][j][i]);

          } else if (visualStatus==4) {
            strokeWidth(1);
            stroke((103+(j*2)),(93+(j*2)),(83+(j*2)));
            point(x_pos[k][j][i], y_pos[k][j][i], z_pos[k][j][i]);
          }
        } else {
          strokeWidth(2);
          stroke((173-0),(163-0),(153-0));
          point(x_pos[k][1][i], y_pos[k][1][i], z_pos[k][1][i]);

        }
      }
    }
  }

  // ************************************************************************
  // key listener code
  // ************************************************************************
  if(keyPressed) {
    if(key == '1') {

    }
  }

  // ************************************************************************
  // mouse listener code
  // ************************************************************************
  // mouse press initializer ------------------------------------------------
  if (mouseStatus == true && priorMouseStatus == false) {
    priorMouseStatus = true;

    // mouse press looper -----------------------------------------------------
  } else if (mouseStatus == true && priorMouseStatus == true) {
    priorMouseStatus = true;

    // mouse release initializer ----------------------------------------------
  } else if (mouseStatus == false && priorMouseStatus == true) {
    priorMouseStatus = false;
    if (visualStatus==4) {
      visualStatus=1;
    } else {
      visualStatus++;
    }
    // mouse release looper ---------------------------------------------------
  } else if (mouseStatus == false && priorMouseStatus == false) {
    priorMouseStatus = false;
  }

}

// ************************************************************************
// functions
// ************************************************************************
/*
void draw_year(String year, float x_start, float y_start, float x_end, float y_end){
  fill(102, 153, 204);
}
*/
