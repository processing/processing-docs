// This code was written with the _ALPHA_ version 
// of Processing and may not run correctly in the 
// current version.


// Skyline
// Mike Davis <http://www.lightcycle.org>

// Created 20 July 2003


World w;
int maxcells = 8000;
int numcells;
Cell[] cells = new Cell[maxcells];
color spore1_color, spore2_color, bg_color;
// set lower for smoother animation, higher for faster simulation
int runs_per_loop = 10000;

void setup()
{
  size(300, 200);
  noBackground();

  stroke(64);
  fill(0);

  w = new World();
  
  spore2_color = color(0, 0, 0);
  spore1_color = color(255, 255, 255);
  bg_color = color(139, 167, 206);
  
  clearscr();
  rect(width/4, height/8 * 7, width/2, 2);

  numcells = 0;

  // Add a bunch of cells at random places
  for (int i = 0; i < 3000; i++)
  {
    int cX = (int)random(width);
    int cY = (int)random(height);
    if (w.get(cX, cY) == bg_color)
    {
      if (random(1) < 0.5) w.set(cX, cY, spore1_color);
      else  w.set(cX, cY, spore2_color);
      cells[numcells] = new Cell(cX, cY);
      numcells++;
    }
  }
}

void loop()
{
  // Run cells in random order
  for (int i = 0; i < runs_per_loop; i++)
  {
    int selected = min((int)random(numcells), numcells - 1);
    cells[selected].run();
  }
}

void clearscr()
{
  for (int y = 0; y < height; y++)
    for (int x = 0; x < width; x++)
      setPixel(x, y, bg_color);
}

class Cell
{
  int x, y;
  Cell(int xin, int yin)
  {
    x = xin;
    y = yin;
  }

    // Perform action based on surroundings
  void run()
  {
    // Fix cell coordinates
    while(x < 0) x+=width;
    while(x > width - 1) x-=width;
    while(y < 0) y+=height;
    while(y > height - 1) y-=height;
    
    
    // Cell instructions
    if (w.get(x, y) == spore1_color)
    {
      if ((w.get(x - 1, y) != bg_color || w.get(x + 1, y) != bg_color) && w.get(x, y + 1) != bg_color) move(0, -1);
      else move(1, 1);
    }
    else if (w.get(x, y) == spore2_color)
    {
      if ((w.get(x - 1, y) != bg_color || w.get(x + 1, y) != bg_color) && w.get(x, y + 1) != bg_color) move(0, -1);
      else move(-1, 1);
    }
    
    if (random(1) < 0.0001) move((int)random(9) - 4, (int)random(9) - 4);
    
  }
  
  // Will move the cell (dx, dy) units if that space is empty
  void move(int dx, int dy)
  {
    if (w.get(x + dx, y + dy) == bg_color)
    {
      w.set(x + dx, y + dy, w.get(x, y));
      w.set(x, y, bg_color);
      x += dx;
      y += dy;
    }
  }

}

//  The World class simply provides two functions, get and set, which access the
//  display in the same way as getPixel and setPixel.  The only difference is that
//  the World class's get and set do screen wraparound ("toroidal coordinates").
class World
{
  void set(int x, int y, int c)
  {
    while(x < 0) x+=width;
    while(x > width - 1) x-=width;
    while(y < 0) y+=height;
    while(y > height - 1) y-=height;
    setPixel(x, y, c);
  }
  int get(int x, int y)
  {
    while(x < 0) x+=width;
    while(x > width - 1) x-=width;
    while(y < 0) y+=height;
    while(y > height - 1) y-=height;
    return getPixel(x, y);
  }
}

void mousePressed()
{
  setup();
}
