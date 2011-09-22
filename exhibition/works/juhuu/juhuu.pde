// This code was written with the _ALPHA_ version 
// of Processing and may not run correctly in the 
// current version.


/*

  The unbearable lightness of being a pixel
  by Juha Huuskonen <http://www.juhuu.nu>

  Created during August 2003

*/

// mouse variables
boolean  mouseStart = true;
int      previous_mouse_x;
int      previous_mouse_y;

// dots
int   dot_amount	   =	150 * 4;
Dot[] dots	           =	new Dot[dot_amount];
int   dots_moving	   =	0;
int   dots_moving_max	   =	100;
int   dot_index_counter    =    0;

// mirror axis variables
int       mirror = 0;
boolean   mirror_changed = false;

// counter for showing the controllers
int   key_press_counter = 75;

// color cycle counters
float  col_counter1 = 0.0;
float  col_counter2 = 0.0;
float  col_counter3 = 0.0;

void setup()
{
  size(300,320);
  noBackground();

  // create four lines of dots
  int 	x;
  int	y;
  int 	i;

  i = 0;
  x = 75;

  for (y = 75 ; y < 225 ; y++)
  {
    dots[i]		=	new Dot(x,y,dot_index_counter++);
    if(dots_moving < 50)
    {
      dots[i].init();
      dots_moving++;
    }
    i++;
  }

  x = 225;
  for (y = 75 ; y < 225 ; y++)
  {
    dots[i++]		=	new Dot(x,y,dot_index_counter++);
  }

  y = 75;
  for (x = 75 ; x < 225 ; x++)
  {
    dots[i++]		=	new Dot(x,y,dot_index_counter++);
  }

  y = 225;
  for (x = 75 ; x < 225 ; x++)
  {
    dots[i++]		=	new Dot(x,y,dot_index_counter++);
  }

  dot_index_counter =  0;

  // clear screen
  //  color c = color(50, 50, 50);
  color c = color(70, 60, 50);
  for (y = 0 ; y < height ; y++)
  {
    for (x = 0 ; x < width ; x++)
    {
      pixels[y*width + x] = c;
    }
  }

}

// main loop
void loop()
{
  // change dot location according to mouse dragging
  drawWithMouse();
  // draw all the dots and lines
  drawDotsAndLines();
  // fade the screen (by one r,g,b value)
  fade_colors();
  // show the controllers
  controllers();
}

//------------------------------------------------------
// draw and handle the controllers
void controllers()
{
  // check keys
  if(keyPressed)
  {
    if(key == 'S' || key == 's')
    {
      // init counter for showing the controllers
      key_press_counter = 50;
      // add 2 dots per time
      add_moving_dots(2);
    } else if(key == 'A' || key == 'a') {
      // init counter for showing the controllers
      key_press_counter = 50;
      // substract 2 dots per time
      substract_moving_dots(2);
    }

    if(key == 'M' || key == 'm') {
      // change mirror
      key_press_counter = 50;
      if(!mirror_changed)
      {
        mirror++;
        mirror_changed = true;
      }
    }
  } else {
    mirror_changed = false;
  }

  // draw the controllers
  if(key_press_counter-- > 0)
  {
    // bright red
    stroke(255,50,50);

    // amount of moving dots
    // horiz line
    line(20, height-13, 119, height-13);
    // vert line
    float amount_line = (float) dots_moving / (float) dots_moving_max;
    line(20 + (int) (amount_line * 99), height-16, 20 + (int) (amount_line * 99), height-10);
    int y_loc = height - 15;

    // type of the mirror
    // 1
    int x_loc = 150;
    if(mirror == 0)
    {
      line(x_loc-2, y_loc+4, x_loc + 2, y_loc+0);
    } else if (mirror == 1) {
      line(x_loc-2, y_loc+2, x_loc + 2, y_loc+2);
    } else if (mirror == 2) {
      line(x_loc, y_loc+0, x_loc, y_loc+4);
    } else if (mirror == 3) {
      line(x_loc-2, y_loc+4, x_loc + 2, y_loc+0);
      line(x_loc-2, y_loc+2, x_loc + 2, y_loc+2);
      line(x_loc, y_loc+0, x_loc, y_loc+4);
    } else {
      mirror = 0;
    }
    
    // white
    stroke(255,255,255);

    // 'draw' the letters :)
    
    // 'a'
    line(10 + 2, y_loc + 0, 10 + 3, y_loc + 0);
    line(10 + 4, y_loc + 1, 10 + 4, y_loc + 4);
    line(10 + 2, y_loc + 2, 10 + 4, y_loc + 2);
    line(10 + 2, y_loc + 4, 10 + 4, y_loc + 4);
    line(10 + 1, y_loc + 3, 10 + 1, y_loc + 3);
    
    // 's'
    line(125 + 1, y_loc + 0, 125 + 3, y_loc + 0);
    line(125 + 1, y_loc + 2, 125 + 2, y_loc + 2);
    line(125 + 0, y_loc + 4, 125 + 2, y_loc + 4);
    line(125 + 0, y_loc + 1, 125 + 0, y_loc + 1);
    line(125 + 3, y_loc + 3, 125 + 3, y_loc + 3);

    // 'm'
    x_loc = 160;
    line(x_loc + 0, y_loc + 0, x_loc + 3, y_loc + 0);
    line(x_loc + 0, y_loc + 0, x_loc + 0, y_loc + 4);
    line(x_loc + 2, y_loc + 0, x_loc + 2, y_loc + 4);
    line(x_loc + 4, y_loc + 1, x_loc + 4, y_loc + 4);
  }
}


//------------------------------------------------------
// change the dot locations according to mouse drag
void drawWithMouse()
{
  // if mouse is pressed, draw on screen
  if(mousePressed)
  {
    int new_x = mouseX;
    int new_y = mouseY;
    if(new_x >= width)
    {
      new_x = width - 1;

      //    new_x -= width;
    } else if (new_x < 0) {
      //      new_x += width;
      new_x = 0;
    }

    if(new_y >= height)
    {
      //      new_y -= height;
      new_y = height - 1;
    } else if (new_y < 0) {
      //      new_y += height;
      new_y = 0;
    }

    if(mouseStart)
    {
      // start drawing
      dots[dot_index_counter].loc_x       = new_x;
      dots[dot_index_counter].loc_y       = new_y;
      dots[dot_index_counter].mouseUpdate = true;
      previous_mouse_x = new_x;
      previous_mouse_y = new_y;
      dot_index_counter++;
      if(dot_index_counter >= dot_amount)
      {
        dot_index_counter = 0;
      }
      mouseStart = false;
    }
    else if(new_x != previous_mouse_x || new_y != previous_mouse_y)
    {
      // create a line between the current and previous mouse location
      createLineWithDots(previous_mouse_x, previous_mouse_y, new_x, new_y);
      // store mouse coordinate
      previous_mouse_x = new_x;
      previous_mouse_y = new_y;
    }
  } else {
    mouseStart = true;
  }
}

//------------------------------------------------------
// fade the screen colours
void fade_colors()
{
  int r,g,b;

  // constantly changing bgcolor
  int r1 = 112 + (int) (20 * sin(col_counter1));
  int g1 = 102 + (int) (20 * cos(col_counter2));
  int b1 = 80 + (int) (20 * sin(col_counter3));
  col_counter1 += 0.001;
  col_counter2 += 0.00155;
  col_counter3 += 0.0021;
  
  // fade the colors towards bgcolor
  for (int j = 0 ; j < height ; j++)
  {
    for (int i = 0 ; i < width ; i++)
    {
      r = (int) red(getPixel(i,j));
      g = (int) green(getPixel(i,j));
      b = (int) blue(getPixel(i,j));

      if(r > r1)
      {
        r -= 1;
      } else if (r < r1) {
        r += 1;
      }

      if(g > g1)
      {
        g -= 1;
      } else if (g < g1){
        g += 1;
      }

      if(b > b1)
      {
        b -= 1;
      } else if (b < b1) {
        b += 1;
      }
      
      pixels[j*width + i] = color(r, g, b);
    }
  }
}

//--------------------------------------------------------------
// draw a line to the screen with additive drawing method
void plotAdditiveLine(int x1, int y1, int x2, int y2)
{
  int r,g,b;

  // don't plot if coordinates are same
  if(x1 == x2 && y1 == y2)
  {
    return;
  }

  int distance_x = x2 - x1;
  int distance_y = y2 - y1;
  // draw a line with dots
  if(abs(distance_y) > abs(distance_x))
  {
    int   y_loc = y1;
    int   amount = abs(distance_y);
    int   y_add = distance_y / amount;
    float x_loc = (float) x1;
    float x_add = (float) distance_x / (float) amount;
    for(int j = 0; j < amount ; j++)
    {
      x_loc += x_add;
      y_loc += y_add;
      r = (int) red(getPixel((int) x_loc,y_loc)) + 27;
      g = (int) green(getPixel((int) x_loc,y_loc)) + 22;
      b = (int) blue(getPixel((int) x_loc,y_loc)) + 12;
      pixels[y_loc * width + (int) x_loc] = color(r, g, b);
    }
  } else {
    int   x_loc = x1;
    int   amount = abs(distance_x);
    int   x_add = distance_x / amount;
    float y_loc = (float) y1;
    float y_add = (float) distance_y / (float) amount;
    for(int i = 0; i < amount ; i++)
    {
      x_loc += x_add;
      y_loc += y_add;
      r = (int) red(getPixel(x_loc,(int) y_loc)) + 27;
      g = (int) green(getPixel(x_loc,(int) y_loc)) + 22;
      b = (int) blue(getPixel(x_loc,(int) y_loc)) + 12;
      pixels[(int) y_loc * width + x_loc] = color(r, g, b);
    }
  }
}

//------------------------------------------------------------------
// Dot class for moving dots
class Dot {
  // unique dot index
  int    dot_index;
  // location
  double loc_x, loc_x_new;
  double loc_y, loc_y_new;
  // direction
  double dir_x, dir_y;
  // moving or not
  boolean moving;
  // wait for a few frames before stopping
  int moving_start_time;
  // location updated with mouse drawing?
  boolean mouseUpdate;

  Dot(int x, int y, int index)
  {
    loc_x = x;
    loc_y = y;
    dot_index = index;

    moving = false;
    mouseUpdate = false;
  }

  void init()
  {
    moving = true;
    dir_x = random(2.0) - 1.0;
    dir_y = random(2.0) - 1.0;
    moving_start_time = 8;
  }

  // update the dot location & take care of activating or disabling dots in the case of a collision
  void update()
  {
    double new_x, new_y;

    if(moving)
    {
      // update location
      new_x = loc_x + dir_x + random(2.0) - 1.0;
      if(new_x > width)
      {
        new_x -= width;
      } else if (new_x < 0) {
        new_x += width;
      }

      new_y = loc_y + dir_y + random(2.0) - 1.0;
      if(new_y > height)
      {
        new_y -= height;
      } else if (new_y < 0) {
        new_y += height;
      }

      // if we are on top of another dot, let's go back and try again...
      int i;
      for (i = 0 ; i < dot_amount ; i++)
      {
        if(this.dot_index != dots[i].dot_index)
        {
          if((int) new_x == (int) dots[i].loc_x && (int) new_y == (int) dots[i].loc_y)
          {
            return;
          }
        }
      }

      // if we are next to a still dot, let's stop and find a new dot to move
      if(moving_start_time-- < 0)
      {
        for (i = 0 ; i < dot_amount ; i++)
        {
          if(this.dot_index != dots[i].dot_index)
          {
            if(!dots[i].moving)
            {
              if(abs((int) new_x - (int) (dots[i].loc_x)) == 1 && abs((int) new_y - (int) (dots[i].loc_y)) == 0)
              {
                activate_dot();
                this.moving = false;
                break;
              } else if(abs((int) new_x - (int) (dots[i].loc_x)) == 0 && abs((int) new_y - (int) (dots[i].loc_y)) == 1) {
                activate_dot();
                this.moving = false;
                break;
              }
            }
          }
        }
      }
      // location ok
      loc_x = new_x;
      loc_y = new_y;
    }
  }
}

//--------------------------------------------------------------

//  misc Dot functions

//--------------------------------------------------------------
// make one still dot move
void activate_dot()
{
  int still_dots = dot_amount - dots_moving;
  int random_dot = (int) random(still_dots - 1);
  int counter = 0;
  for (int i = 0 ; i < dot_amount ; i++)
  {
    if(dots[i].moving == false)
    {
      if (counter == random_dot)
      {
        dots[i].init();
        break;
      } else {
        counter++;
      }
    }
  }
}

//----------------------------------------------------------
// add the amount of moving dots
void add_moving_dots(int amount)
{
  while(amount-- > 0)
  {
    dots_moving++;
    if(dots_moving > dots_moving_max)
    {
      dots_moving    =    dots_moving_max;
    } else {
      int still_dots = dot_amount - dots_moving;
      int random_dot = (int) random(still_dots - 1);
      int counter = 0;
      for (int i = 0 ; i < dot_amount ; i++)
      {
        if(dots[i].moving == false)
        {
          if (counter == random_dot)
          {
            dots[i].init();
            break;
          } else {
            counter++;
          }
        }
      }
    }
  }
}
//----------------------------------------------------------
// substract the amount of moving dots
void substract_moving_dots(int amount)
{
  while(amount-- > 0)
  {
    dots_moving--;
    if(dots_moving < 0)
    {
      dots_moving    =    0;
    } else {
      int counter = 0;
      int random_dot = (int) random(dots_moving - 1);
      for (int i = 0 ; i < dot_amount ; i++)
      {
        if(dots[i].moving == true)
        {
          if (counter == random_dot)
          {
            dots[i].moving = false;
            break;
          } else {
            counter++;
          }
        }
      }
    }
  }
}
//--------------------------------------------------------------
// create a line with dots
void createLineWithDots(int x1, int y1, int x2, int y2)
{
  int distance_x = x2 - x1;
  int distance_y = y2 - y1;
  // draw a line with dots
  if(abs(distance_y) > abs(distance_x))
  {
    int   y_loc = y1;
    int   amount = abs(distance_y);
    int   y_add = distance_y / amount;
    float x_loc = (float) x1;
    float x_add = (float) distance_x / (float) amount;
    for(int j = 0; j < amount ; j++)
    {
      x_loc += x_add;
      y_loc += y_add;
      dots[dot_index_counter].loc_x       = x_loc;
      dots[dot_index_counter].loc_y       = y_loc;
      dots[dot_index_counter].mouseUpdate = true;
      dot_index_counter++;
      if(dot_index_counter >= dot_amount)
      {
        dot_index_counter = 0;
      }
    }
  } else {
    int   x_loc = x1;
    int   amount = abs(distance_x);
    int   x_add = distance_x / amount;
    float y_loc = (float) y1;
    float y_add = (float) distance_y / (float) amount;
    for(int i = 0; i < amount ; i++)
    {
      x_loc += x_add;
      y_loc += y_add;
      dots[dot_index_counter].loc_x       = x_loc;
      dots[dot_index_counter].loc_y       = y_loc;
      dots[dot_index_counter].mouseUpdate = true;
      dot_index_counter++;
      if(dot_index_counter >= dot_amount)
      {
        dot_index_counter = 0;
      }
    }
  }
}

//-------------------------------------------------------------
// draw all the dots and additive lines
void drawDotsAndLines()
{
  color black = color(0, 0, 0);
  color dark = color(200, 200, 200);
  color pink = color(255, 150, 150);
  Dot dot;
  stroke(200,200,200);
  int old_x = 0;
  int old_y = 0;
  // moving dots will have lines
  for (int i = 0 ; i < dot_amount ; i++)
  {
    dot = dots[i];
    if(dot.mouseUpdate)
    {
      dot.mouseUpdate = false;
      if(mirror < 1)
      {
        plotAdditiveLine((int)dot.loc_x, (int)dot.loc_y, (int)dot.loc_y, (int)dot.loc_x);
      } else if (mirror < 2) {
        int loc_y_mirrored = height-(int)dot.loc_y;
        if(loc_y_mirrored < 0)
        {
          loc_y_mirrored = 0;
        } else if (loc_y_mirrored >= height) {
          loc_y_mirrored = height - 1;
        }
        plotAdditiveLine((int)dot.loc_x, (int)dot.loc_y, (int)dot.loc_x, loc_y_mirrored);
      } else if (mirror < 3) {
        int loc_x_mirrored = width-(int)dot.loc_x;
        if(loc_x_mirrored < 0)
        {
          loc_x_mirrored = 0;
        } else if (loc_x_mirrored >= width) {
          loc_x_mirrored = width - 1;
        }
        plotAdditiveLine((int)dot.loc_x, (int)dot.loc_y, loc_x_mirrored, (int)dot.loc_y);
      } else if (mirror < 4) {
        int loc_x_mirrored = width-(int)dot.loc_x;
        if(loc_x_mirrored < 0)
        {
          loc_x_mirrored = 0;
        } else if (loc_x_mirrored >= width) {
          loc_x_mirrored = width - 1;
        }
        int loc_y_mirrored = height-(int)dot.loc_y;
        if(loc_y_mirrored < 0)
        {
          loc_y_mirrored = 0;
        } else if (loc_y_mirrored >= height) {
          loc_y_mirrored = height - 1;
        }
        plotAdditiveLine((int)dot.loc_x, (int)dot.loc_y, loc_x_mirrored, loc_y_mirrored);
      } else {
        mirror = 0;
      }
    } else {
      old_x = (int) dot.loc_x;
      old_y = (int) dot.loc_y;
      dot.update();
      if((int)dot.loc_x != old_x || (int)dot.loc_y != old_y)     // did the dot move ?
      {
        if(mirror < 1)
        {
          plotAdditiveLine((int)dot.loc_x, (int)dot.loc_y, (int)dot.loc_y, (int)dot.loc_x);
        } else if (mirror < 2) {
          int loc_y_mirrored = height-(int)dot.loc_y;
          if(loc_y_mirrored < 0)
          {
            loc_y_mirrored = 0;
          } else if (loc_y_mirrored >= height) {
            loc_y_mirrored = height - 1;
          }
          plotAdditiveLine((int)dot.loc_x, (int)dot.loc_y, (int)dot.loc_x, loc_y_mirrored);
        } else if (mirror < 3) {
          int loc_x_mirrored = width-(int)dot.loc_x;
          if(loc_x_mirrored < 0)
          {
            loc_x_mirrored = 0;
          } else if (loc_x_mirrored >= width) {
            loc_x_mirrored = width - 1;
          }
          plotAdditiveLine((int)dot.loc_x, (int)dot.loc_y, loc_x_mirrored, (int)dot.loc_y);
        } else if (mirror < 4) {
          int loc_x_mirrored = width-(int)dot.loc_x;
          if(loc_x_mirrored < 0)
          {
            loc_x_mirrored = 0;
          } else if (loc_x_mirrored >= width) {
            loc_x_mirrored = width - 1;
          }
          int loc_y_mirrored = height-(int)dot.loc_y;
          if(loc_y_mirrored < 0)
          {
            loc_y_mirrored = 0;
          } else if (loc_y_mirrored >= height) {
            loc_y_mirrored = height - 1;
          }
          plotAdditiveLine((int)dot.loc_x, (int)dot.loc_y, loc_x_mirrored, loc_y_mirrored);
        } else {
          mirror = 0;
        }
      }
    }
  }

  for (int i = 0 ; i < dot_amount ; i++)
  {
    dot = dots[i];
    pixels[ ((width*(int)dot.loc_y) + (int)dot.loc_x)] = black;
  }

}
