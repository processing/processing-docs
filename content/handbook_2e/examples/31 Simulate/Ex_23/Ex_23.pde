int[][] grid, futureGrid;

void setup() {
  size(540, 100);
  frameRate(8);
  grid = new int[width][height];
  futureGrid = new int[width][height];
  float density = 0.3 * width * height;
  // Set a random initial state
  for (int i = 0; i < density; i++) {
    int rx = int(random(width));
    int ry = int(random(height));
    grid[rx][ry] = 1;
  }
  background(0);
}

void draw() {
  for (int x = 1; x < width-1; x++) {
    for (int y = 1; y < height-1; y++) {
      // Check the number of neighbors (adjacent cells)
      int nb = neighbors(x, y);
      if ((grid[x][y] == 1) && (nb <  2)) {
        futureGrid[x][y] = 0;  // Isolation death  
        set(x, y, color(0));
      } else if ((grid[x][y] == 1) && (nb >  3)) {  
        futureGrid[x][y] = 0;  // Overpopulation death
        set(x, y, color(0));
      } else if ((grid[x][y] == 0) && (nb == 3)) {
        futureGrid[x][y] = 1;  // Birth
        set(x, y, color(255));
      } else {   
        futureGrid[x][y] = grid[x][y];  // No change  
      }  
    }
  }
  // Swap current and future grids
  int[][] temp = grid;
  grid = futureGrid;
  futureGrid = temp;
}

// Count the number of adjacent cells 'on' 
int neighbors(int x, int y) { 
  int north = (y + height-1) % height;
  int south = (y + 1) % height;
  int east = (x + 1) % width;
  int west = (x + width-1) % width;
  return grid[x][north] +     // North
         grid[east][north] +  // Northeast
         grid[east][y] +      // East
         grid[east][south] +  // Southeast
         grid[x][south] +     // South
         grid[west][south] +  // Southwest
         grid[west][y] +      // West
         grid[west][north];   // Northwest
} 
