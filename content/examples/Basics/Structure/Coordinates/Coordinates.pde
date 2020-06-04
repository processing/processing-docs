/**
 * Coordinates. 
 * 
 * All shapes drawn to the screen have a position that is 
 * specified as a coordinate. All coordinates are measured 
 * as the distance from the origin in units of pixels.
 * The origin (0, 0) is the coordinate is in the upper left 
 * of the window and the coordinate in the lower right is 
 * (width-1, height-1).  
 */

// Sets the screen to be 640 pixels wide and 360 pixels high
size(640, 360);

// Set the background to black and turn off the fill color
background(0);
noFill();

// The two parameters of the point() function define its location.
// The first parameter is the x-coordinate and the second is the y-coordinate 
stroke(255);
point(320, 180);
point(320, 90); 

// Coordinates are used for drawing all shapes, not just points.
// Parameters for different functions are used for different purposes.
// For example, the first two parameters to line() specify 
// the coordinates of the first endpoint and the second two parameters 
// specify the second endpoint
stroke(0, 153, 255);
line(0, 120, 640, 120);

// The first two parameters to rect() are the coordinates of the 
// upper-left corner and the second pair is the width and height 
// of the rectangle
stroke(255, 153, 0);
rect(160, 36, 320, 288);
