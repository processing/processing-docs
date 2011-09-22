
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//LiquidLiquid by v3ga <http://processing.v3ga.net>
//October 2004
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//
//
//uses :
//- fastblur by Quasimondo <http://incubator.quasimondo.com>
//

public class LiquidWen extends BApplet
{

	
	// > Globals
	// ---------------------------------
	
	BFont				metaFont;
	boolean				isTimerRun	 = false;
	timer				timer;
	
	Scene				scene[];
	Scene				currentScene;
	
	boolean				isSmooth;
	
	void setup()
	{
		size(500,500);
		
	
		// > Scene Array Allocation
		scene = new Scene[showMeTheUglyHiddenScreen ? 2 : 1];		
		
		// > Create Scene
		scene[0] = new SceneMetaText();
		scene[0].init();

		if (showMeTheUglyHiddenScreen)
		{
			scene[1] = new SceneCube();	
			scene[1].init();
			currentScene = scene[1];
		}
		else
		{
			currentScene = scene[0];
		}
		// > Setup fonts
		metaFont = loadFont("Meta-Bold.vlw.gz");
		textFont(metaFont,25);

		// > Drawing
		isSmooth = false;
		noSmooth();

		
	}

	void loop()
	{
	  // > Get dt
	  if (!isTimerRun)
	  {
	    timer = new timer(millis());
	    isTimerRun = true;
	  }
	  float dt = timer.M_getDelta(millis())/1000.0f;
	  
	  currentScene.run(dt);
	}

	void	mousePressed()
	{
		currentScene.handleMousePressed();
	}

	void keyPressed()
	{
		currentScene.handleKeyPressed();
	
		if (key == '+') 
		{
			isSmooth = !isSmooth;
			if (isSmooth)
				smooth();
			else
				noSmooth();
		};
	}
	

//	 ==================================================
//	 class EdgeVertex
//	 ==================================================
	class EdgeVertex
	{
	  float x,y;
	  EdgeVertex(float x, float y){this.x=x;this.y=y;}
	};


//	 ==================================================
//	 class Metaballs2D
//	 ==================================================
	class Metaballs2D
	{
	  // Isovalue
	  // ------------------
	  float isovalue;
	  
	  // Grid
	  // ------------------
	  int  resx,resy;
	  float stepx,stepy;
	  float[] gridValue;
	  int nbGridValue;  

	  // Voxels      
	  // ------------------
	  int[] voxel;
	  int nbVoxel;
	  
	  // EdgeVertex
	  // ------------------
	  EdgeVertex[] edgeVrt;
	  int nbEdgeVrt;  
	  
	  // Lines
	  // what we pass to the renderer
	  // ------------------
	  int[] lineToDraw;  
	  int nbLineToDraw;
	  
	  // Constructor
	  // ------------------
	  Metaballs2D(){}

	  
	  // init(int, int)
	  // ------------------
	  void init(int resx, int resy)
	  {
	 	this.resx = resx;
		this.resy = resy;

		this.stepx = 1.0f/( (float)(resx-1));
		this.stepy = 1.0f/( (float)(resy-1));

		// Allocate gridValue
		nbGridValue	= resx*resy;
		gridValue	= new float[nbGridValue];
		
		
		// Allocate voxels
		nbVoxel		= nbGridValue;
		voxel		= new int[nbVoxel];

		// Allocate EdgeVertices
        edgeVrt = new EdgeVertex [2*nbVoxel];
        nbEdgeVrt = 0;

		// Allocate Lines
		lineToDraw = new int[2*nbVoxel];
	        nbLineToDraw = 0;
		
	        // Precompute some values
		int x,y,n,index;
		n = 0;
		for (x=0 ; x<resx ; x++)
			for (y=0 ; y<resy ; y++)
			{
				index = 2*n;
				// index to edgeVrt
                voxel[x+resx*y] = index;
				// values
                edgeVrt[index]   = new EdgeVertex(x*stepx, y*stepy);
                edgeVrt[index+1] = new EdgeVertex(x*stepx, y*stepy);
                // gridValue Clear
                gridValue[x+resx*y] = 0;
				// Next!
				n++;
			}
		
	  }
	  
	  // computeIsovalue()
	  // ------------------
	  void computeIsovalue(float dt)
	  {

	    // A simple test : put a metaball on center of the screen
	/*
		float	ballx = 0.5f;
		float	bally = 0.5f;
		float	vx,vy;
		float	dist;

		int x,y;
		vx = 0.0f;
		for (x=0 ; x<resx; x++)
		{	
			vy = 0.0f;
			for (y=0 ; y<resy; y++)
			{
				dist = (float)sqrt((vx-ballx)*(vx-ballx) + (vy-bally)*(vy-bally));
				gridValue[x+resx*y] = 10.0f/(dist*dist+0.001f);
				vy+=stepy;
			}
			vx+=stepx;
		}
	*/
	    
	            
	  }

	  
	  // computeMesh()
	  // ------------------
	  void computeMesh(float dt)
	  {
		// Compute IsoValue
		computeIsovalue(dt);
		// Get Lines indices

		int					x,y,squareIndex,n;
		int					iEdge;
		int					offx, offy, offAB;
		int					toCompute;
		int					offset;
		float					t;
		float					vx,vy;
		int[]                                   edgeOffsetInfo;

		nbLineToDraw = 0;
		vx	     = 0.0f;
		for (x=0 ; x<resx-1 ; x++)
		{
			vy = 0.0f;
			for (y=0 ; y<resy-1 ; y++)
			{
				offset		= x + resx*y;
				squareIndex     = getSquareIndex(x,y);

				n	        = 0;
				while ( (iEdge = MetaballsTable.edgeCut[squareIndex][n++]) != -1)
				{
					edgeOffsetInfo          = MetaballsTable.edgeOffsetInfo[iEdge];
					offx			= edgeOffsetInfo[0];
					offy			= edgeOffsetInfo[1];
					offAB			= edgeOffsetInfo[2];

	                               lineToDraw[nbLineToDraw++] = voxel[(x+offx) + resx*(y+offy)] + offAB;
				}

	                        toCompute = MetaballsTable.edgeToCompute[squareIndex];
				if (toCompute>0)
				{
	                                if ( (toCompute & 1) > 0) // Edge 0
					{
						t	= (isovalue - gridValue[offset]) / (gridValue[offset+1] - gridValue[offset]+0.000001f); 
						edgeVrt[voxel[offset]].x = vx*(1.0f-t) + t*(vx+stepx);
	                                }
					if ( (toCompute & 2) > 0) // Edge 3
					{
						t	= (isovalue - gridValue[offset]) / (gridValue[offset+resx] - gridValue[offset]+0.000001f); 
						edgeVrt[voxel[offset]+1].y = vy*(1.0f-t) + t*(vy+stepy);
					}
				
				} // toCompute
				vy += stepy;
			}	// for y

			vx += stepx;
		}	// for x

		nbLineToDraw /= 2;
	    
	  }

	  // getSquareIndex(int,int)
	  // ------------------
	  int getSquareIndex(int x, int y)
	  {
	    int squareIndex = 0;
	        int offy  = resx*y;
	        int offy1 = resx*(y+1);
		if (gridValue[x+offy]				< isovalue) squareIndex |= 1;
		if (gridValue[x+1+offy]		        < isovalue) squareIndex |= 2;
		if (gridValue[x+1+offy1]	        < isovalue) squareIndex |= 4;
		if (gridValue[x+offy1]		        < isovalue) squareIndex |= 8;
	   return squareIndex;
	  }
	  
	  // setIsoValue(float)
	  // ------------------
	  void setIsoValue(float newIso){this.isovalue = newIso;}
	  
	  // draw()
	  // ------------------
	  void draw()
	  {
	        
	        int iA,iB;
	        int iLine;
		for (iLine = 0 ; iLine<nbLineToDraw ; iLine++)
		{
	                iA = lineToDraw[iLine*2];
	                iB = lineToDraw[iLine*2+1];
	                
	                line (edgeVrt[iA].x*(float)width, edgeVrt[iA].y*(float)height, edgeVrt[iB].x*(float)width, edgeVrt[iB].y*(float)height); 
		}
	  
	  }

	  // drawGrid()
	  // ------------------
	  void drawGrid(int wx, int wy)
	  {
		int	x,y;
		float	vx,vy;
		float	sx = this.stepx*wx;
		float	sy = this.stepy*wy;

		vy = 0.0f;
		for (x=0 ; x<resx ; x++)
		{
	                line(0.0f,vy,wx,vy);
			vy += sy;
		}	

		vx = 0.0f;
		for (y=0 ; y<resy ; y++)
		{
	                line(vx,0.0f,vx,wy);
			vx += sx;
		}	
		

	  }
	};


//	 ==================================================
//	 class EdgeDetection
//	 ==================================================
	class EdgeDetection extends Metaballs2D
	{
	  
	    BImage img;
	  
	   EdgeDetection(int imgWidth, int imgHeight)
	   {

	     img = new BImage(imgWidth, imgHeight);
	     init(imgWidth, imgHeight);
	   } 
	  
	  // computeIsovalue()
	  // ------------------
	  void computeIsovalue(float dt)
	  {
	    int pixel, R,G,B;
	    int x,y;
	    int offset;
	    for (y=0 ; y<img.height;y++)
	      for (x=0 ; x<img.width;x++)
	    {
	      offset = x+img.width*y;
	      // Add R,G,B
	      pixel = img.pixels[offset];
	      R = (pixel & 0x00FF0000)>>16;
	      G = (pixel & 0x0000FF00)>>8;
	      B = (pixel & 0x000000FF);
	      gridValue[offset] =  (float) (R+G+B);   
	    }
	  
	    // A simple test : put a metaball on center of the screen
			float	ballx = (float)mouseX/(float)width;
			float	bally = (float)mouseY/(float)height;
			float	vx,vy;
			float	dist;

			//int x,y;
			vx = 0.0f;
			for (x=0 ; x<resx; x++)
			{	
				vy = 0.0f;
				for (y=0 ; y<resy; y++)
				{
					dist = (float)sqrt((vx-ballx)*(vx-ballx) + (vy-bally)*(vy-bally));
					gridValue[x+resx*y] -= 2.0f/(dist*dist+0.001f);
					vy+=stepy;
				}
				vx+=stepx;
			}
	  }

	  // getSquareIndex()
	  // ------------------
	  int getSquareIndex(int x, int y)
	  {
	    int squareIndex = 0;
	      
	    int offy  = resx*y;
	    int offy1 = resx*(y+1);
		if (gridValue[x+offy]				< isovalue) squareIndex |= 1;
		if (gridValue[x+1+offy]		        < isovalue) squareIndex |= 2;
		if (gridValue[x+1+offy1]	        < isovalue) squareIndex |= 4;
		if (gridValue[x+offy1]		        < isovalue) squareIndex |= 8;
	   return squareIndex;
	  }

	  // copyToImg()
	  // ------------------
	  void copyRenderTargetToImg(BImage imgToCopy)
	  {
	    System.arraycopy(imgToCopy.pixels, 0, img.pixels,0, imgToCopy.width*imgToCopy.height);
	  }

	  // copyToImg()
	  // ------------------
	  void copyScreenToImg(BGraphics buffer)
	  {
	    for (int i=0 ; i<img.height ; i++)
	        System.arraycopy(buffer.pixels, i*buffer.width, img.pixels,i*img.width, img.width);
	  }
	  
	  
	  // blurImg()
	  // ------------------
	  void blurImg(int radius)
	  {
	    fastblur(this.img, radius);
	  }


	  // drawImage()
	  // ------------------
	  void drawImageScreen()
	  {
	    image(img, 0,0,width, height);
	  }

	};

//	 ==================================================
//	 class EdgeDetection
//	 ==================================================
	class EdgeDetectionEx extends EdgeDetection
	{
	  
	    EdgeDetectionEx(int imgWidth, int imgHeight)
		{
	    	super(imgWidth, imgHeight);
	    } 
	  
	  // computeIsovalue()
	  // ------------------
	  void computeIsovalue(float dt)
	  {
	    int pixel, R,G,B;
	    int 	x,y;
	    int 	offset;
	    float 	dist;
		float	vx,vy;
		float	targetValue;
		
		// A simple test : put a metaball on center of the screen
		float	ballx = (float)mouseX/(float)width;
		float	bally = (float)mouseY/(float)height;
		
		float	ballx2, bally2;
    
		vy = 0.0f;
	    for (y=0 ; y<img.height;y++)
	    {
	      vx = 0.0f;
	      for (x=0 ; x<img.width;x++)
	      {
	      	offset = x+img.width*y;
		      // Add R,G,B
		      pixel = img.pixels[offset];
		      R = (pixel & 0x00FF0000)>>16;
		      G = (pixel & 0x0000FF00)>>8;
		      B = (pixel & 0x000000FF);
		      targetValue = (float) (R+G+B);
		      //gridValue[offset] =  (float) (R+G+B);   
		    
		    
		      // Add metaball effect
		      if (mousePressed == true)
		      {
		      	  float s = 5.0f;
			      dist = (float)sqrt((vx-ballx)*(vx-ballx) + (vy-bally)*(vy-bally));
			      targetValue -= s/(dist*dist+0.001f);
		      
			      ballx2 = -ballx + 1.0f;
			      bally2 = -bally + 1.0f;
			      
			      dist = (float)sqrt((vx-ballx2)*(vx-ballx2) + (vy-bally2)*(vy-bally2));
			      targetValue -= s/(dist*dist+0.001f);
		      
		      }
		      gridValue[offset] += (targetValue - gridValue[offset])*2.0f*dt;
		      vx+=stepx;
	      }
	      vy+=stepy;
	    }
	    

	  }


};
	
	
//	 ==================================================
//	 class MetaballsTable
//	 ==================================================
	static class MetaballsTable
	{
	  // Edge Cut Array
	  // ------------------------------
	  static int edgeCut[][] =   
	  {
		{-1, -1, -1, -1, -1}, //0
		{ 0,  3, -1, -1, -1}, //3
		{ 0,  1, -1, -1, -1}, //1
		{ 3,  1, -1, -1, -1}, //2
		{ 1,  2, -1, -1, -1}, //0
		{ 1,  2,  0,  3, -1}, //3
		{ 0,  2, -1, -1, -1}, //1
		{ 3,  2, -1, -1, -1}, //2
		{ 3,  2, -1, -1, -1}, //2
		{ 0,  2, -1, -1, -1}, //1
		{ 1,  2,  0,  3, -1}, //3
		{ 1,  2, -1, -1, -1}, //0
		{ 3,  1, -1, -1, -1}, //2
		{ 0,  1, -1, -1, -1}, //1
		{ 0,  3, -1, -1, -1}, //3
		{-1, -1, -1, -1, -1}  //0
	  };

	  // EdgeOffsetInfo Array
	  // ------------------------------
	  static int edgeOffsetInfo[][] =  
	  {
	 	{0,0,0},
		{1,0,1},
		{0,1,0},
		{0,0,1}
	 
	  };

	  // EdgeToCompute Array
	  // ------------------------------
	  static int edgeToCompute[] = {0,3,1,2,0,3,1,2,2,1,3,0,2,1,3,0};


	}

//	 ==================================================
//	 class Scene
//	 ==================================================
	class Scene
	{
		int		renderTargetw = 100;
		int		renderTargeth = 100; 
		BGraphics	buffer = new BGraphics(renderTargetw, renderTargeth);
		
		void 	init(){};
		void	run(float dt){};
		void	handleKeyPressed(){};
		void	handleMousePressed(){};
	}
	
//	 ==================================================
//	 class SceneMetaText
//	 ==================================================
	class SceneMetaText extends Scene
	{
		EdgeDetectionEx		edgeDetection;
		float 				angleTexte;
		float				angleTexteSpeed;
		String				s;
		
	   // init()
	   // ------------------
		void init()
		{
			// > EdgeDetection
			edgeDetection = new EdgeDetectionEx(renderTargetw,renderTargeth);
		
			// > Some parameters
			rectMode(CENTER_DIAMETER);
			angleTexte 		= 0.0f;
			angleTexteSpeed	= 3.0f*1;
			s				= "Processing";
			
			
		}


	   // run()
	   // ------------------
		void run(float dt)
		{
			
			  // draw Scene
			background(255);
			
			buffer.background(255);
			buffer.fill(0);
			buffer.push();
			buffer.translate(renderTargetw/2, renderTargeth/2);
			buffer.rotateZ(angleTexte*PI/180.0f);
			buffer.textFont(metaFont, 20); 
			buffer.text(s,-38.0f, 4.0f);
	 		buffer.pop();
	 		
	 		angleTexte = angleTexteSpeed*dt*0.0f+8.0f; 
	 		if (angleTexte>360.0f) angleTexte -= 360.0f;

			edgeDetection.copyScreenToImg(buffer);
	 		edgeDetection.setIsoValue(600.0f);
		    edgeDetection.computeMesh(dt);
		    strokeWeight(1.5f);
		    stroke(0,0,0);
		    edgeDetection.draw();
		
	}
		
	   // processString()
	   // ------------------
		void processString(int k)
		{
			char[] data = new char[s.length()];	// TODO : could be allocated once at start
			int l = s.length();
			data = s.toCharArray();
			for (int i=0 ; i<l-1 ; i++)	data[i] = data[i+1];
			data[l-1] = (char)k;
			s = String.copyValueOf(data);
		}

		
	   // handleKeyPressed()
	   // ------------------
		void	handleKeyPressed()
		{
			if (
				(key>='a' && key<='z') || 
				(key>='A' && key<='Z') || 
				(key>='0' && key<='9') || 
				key==' '
				) 
				processString(key);
		};

		// handleMousePressed()
	   // ------------------
		void	handleMousePressed()
		{
			
		};
		
	}
	
//	 ==================================================
//	 class SceneCube
//	 ==================================================
	class SceneCube extends Scene
	{
		EdgeDetectionEx		edgeDetection;
		Cube				cube;
		String				cubeString;
		float				angle, angleSpeed;
		
		// init()
	   // ------------------
		void init()
		{
			// > EdgeDetection
			edgeDetection = new EdgeDetectionEx(renderTargetw,renderTargeth);
			// > Cube
			cube = new Cube(3);
			cubeString = "CUBE";
			// > Param
			angle 		= 0.0f;
			angleSpeed 	= 10.0f;
		}

	   // drawCube()
	   // ------------------
		void drawCube()
		{
		}
		
	   // run()
	   // ------------------
		void run(float dt)
		{
			// render Cube into texture
			 buffer.background(255);
			 buffer.fill(0);
		     buffer.push();
			 buffer.translate(renderTargetw/2, renderTargeth/2, 400);
			 buffer.rotateY(angle*PI/180.0f);
			 buffer.rotateZ(angle*PI/180.0f);
			 buffer.scale(180);
			 cube.computeProj(buffer);
			 buffer.pop();

			 buffer.textFont(metaFont, 20);
			 int i=0;
			 for (int n=0 ; n<cube.nbVertex ; n++)
			 {
			   buffer.text(cubeString.charAt(n%4), cube.vertexProj[i], cube.vertexProj[i+1]);
 		       i+=2;
  		       
             }
			 
			// draw Scene
     		background(255);
			
	 		edgeDetection.setIsoValue(550.0f);
			edgeDetection.copyScreenToImg(buffer);
		    edgeDetection.computeMesh(dt);
		    strokeWeight(1);
		    stroke(0,0,0);
		    edgeDetection.draw();
			
		    angle += angleSpeed*dt;
		    if (angle>360.0f) angle -= 360.0f;
	}
		
	   // handleKeyPressed()
	   // ------------------
		void	handleKeyPressed()
		{
		};

		// handleMousePressed()
	   // ------------------
		void	handleMousePressed()
		{
			
		};
		
	}
	
//	 ==================================================
//	 class Cube
//	 ==================================================
	class Cube
	{
		int 	dim;
		int 	nbVertex;
		float	vertex[];		 
		float	vertexProj[];
		Cube(int dim)
		{
			this.dim = dim;
			this.nbVertex = dim*dim*dim;
			//we store a single vertex as float[3]
			vertex 		= new float[nbVertex*3]; 
			vertexProj	= new float[nbVertex*2];
			// get normalised position of vertices
			int 	x,y,z;
			float	step = 1.0f/(float)(dim-1);
			int 	n=0;
			for (z=0;z<dim;z++)
				for (y=0;y<dim;y++)
					for (x=0;x<dim;x++)
					{
						vertex[n++] = (float)x*step - 0.5f;
						vertex[n++] = (float)y*step - 0.5f;
						vertex[n++] = (float)z*step - 0.5f;
					}
		}
		
		void computeProj(BGraphics b)
		{
			int n=0;
			float x,y,z;
            for (int i=0 ; i<nbVertex ; i++)
			{
				x = vertex[3*i];
				y = vertex[3*i+1];
				z = vertex[3*i+2];
				
				vertexProj[n++] = b.screenX(x,y,z);
				vertexProj[n++] = b.screenY(x,y,z);
			}
		}
	}
	
//	 ==================================================
//	 Super Fast Blur v1.1
//	 by Mario Klingemann <http://incubator.quasimondo.com>
//	 ==================================================
	void fastblur(BImage img,int radius){

	  if (radius<1){
	    return;
	  }
	  int w=img.width;
	  int h=img.height;
	  int wm=w-1;
	  int hm=h-1;
	  int wh=w*h;
	  int div=radius+radius+1;
	  int r[]=new int[wh];
	  int g[]=new int[wh];
	  int b[]=new int[wh];
	  int rsum,gsum,bsum,x,y,i,p,p1,p2,yp,yi,yw;
	  int vmin[] = new int[max(w,h)];
	  int vmax[] = new int[max(w,h)];
	  int[] pix=img.pixels;
	  int dv[]=new int[256*div];
	  for (i=0;i<256*div;i++){
	     dv[i]=(i/div); 
	  }
	  
	  yw=yi=0;
	 
	  for (y=0;y<h;y++){
	    rsum=gsum=bsum=0;
	    for(i=-radius;i<=radius;i++){
	      p=pix[yi+min(wm,max(i,0))];
	      rsum+=(p & 0xff0000)>>16;
	      gsum+=(p & 0x00ff00)>>8;
	      bsum+= p & 0x0000ff;
	   }
	    for (x=0;x<w;x++){
	    
	      r[yi]=dv[rsum];
	      g[yi]=dv[gsum];
	      b[yi]=dv[bsum];

	      if(y==0){
	        vmin[x]=min(x+radius+1,wm);
	        vmax[x]=max(x-radius,0);
	       } 
	       p1=pix[yw+vmin[x]];
	       p2=pix[yw+vmax[x]];

	      rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
	      gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
	      bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
	      yi++;
	    }
	    yw+=w;
	  }
	  
	  for (x=0;x<w;x++){
	    rsum=gsum=bsum=0;
	    yp=-radius*w;
	    for(i=-radius;i<=radius;i++){
	      yi=max(0,yp)+x;
	      rsum+=r[yi];
	      gsum+=g[yi];
	      bsum+=b[yi];
	      yp+=w;
	    }
	    yi=x;
	    for (y=0;y<h;y++){
	      pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
	      if(x==0){
	        vmin[y]=min(y+radius+1,hm)*w;
	        vmax[y]=max(y-radius,0)*w;
	      } 
	      p1=x+vmin[y];
	      p2=x+vmax[y];

	      rsum+=r[p1]-r[p2];
	      gsum+=g[p1]-g[p2];
	      bsum+=b[p1]-b[p2];

	      yi+=w;
	    }
	  }

	}

//	 ==================================================
//	 class timer
//	 ==================================================
	class timer
	{
	  float t;
	  timer(float now){t = now;}
	  float M_getDelta(float timeNow)
	  {
	    float dt = timeNow - t;
	    t = timeNow;
	    return dt;
	  }
	};
	

	boolean	showMeTheUglyHiddenScreen = false;

}