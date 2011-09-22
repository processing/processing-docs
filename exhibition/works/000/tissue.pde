// Tissue
// Casey Reas

int numLights = 3;
int numVehicles = 600;

Vehicle[] vehicles = new Vehicle[numVehicles];
Light[] lights = new Light[numLights];

float maxDistance;
int r, g, b;


void setup() {
  size(600, 250);
  background(230, 230, 200);
  ellipseMode(CENTER_DIAMETER);
  for(int i=0; i<numLights; i++) {
    lights[i] = new Light(random(20, width-20), random(20, height-20), 20, i, lights);
  }

  for(int i=0; i<numVehicles; i++) {
    int tm = i%4;
    if (tm == 0) {
      r = 153; g = 204; b = 0;
    } else if (tm == 1) {
      r = 102; g = 102; b = 102;
    } else if (tm == 2) {
      r = 153; g = 102; b = 0;
    } else if (tm == 3) {
      r = 153; g = 153; b = 0;
    }
    int grayrand = int(random(-26, 26));
    vehicles[i] = new Vehicle(random(width), random(height), random(360), 
                              tm, r+grayrand, g+grayrand, b);
  }
  maxDistance = sqrt(sq(width) + sq(height));
}

void loop() {
  for(int i=0; i<numLights; i++) {
    lights[i].update();
    lights[i].draw();
  }
  for(int i=0; i<numVehicles; i++) {
    vehicles[i].update();
    vehicles[i].draw();
  }

}

void mouseReleased() 
{
  for(int i=0; i<numLights; i++) {
    lights[i].unlock();    
  }
}


/////////////////////////////////////////
/////////////////////////////////////////

class Light
{
  float lightX;
  float lightY;
  int size;
  boolean over;
  boolean pressed;
  boolean locked;
  Light[] others;
  boolean otherslocked;
  int me;
  
  Light(float x, float y, int s, int m, Light[] l)
  {
    lightX = x;
    lightY = y;
    size = s;
    me = m;
    others = l;
  }
  
  void update()
  {
    for(int i=0; i<others.length; i++) {
      if(others[i].locked == true) {
        otherslocked = true;
        break;
      } else {
        otherslocked = false;
      }
    }
    if(otherslocked == false) {
      over();
      pressed();
    }
    
    if(locked) {
      lightX = constrain(mouseX, size/2, width-size/2);
      lightY = constrain(mouseY, size/2, height-size/2);
    }
  }
  
  void over()
  {
    if(overCircle(lightX, lightY, size)) {
      over = true;
    } else {
      over = false;
    }
  }
  
  void pressed()
  {
    if(mousePressed && over) {
      pressed = true;
      locked = true;
    } else {
      pressed = false;
    }
  }
  
  void unlock() 
  {
    locked = false;
  }
  
  void draw()
  {
    noStroke();
    if(over) {
      fill(204, 153, 0);
    } else {
      fill(255, 204, 0);
    }
    ellipse(lightX, lightY, size, size);
  }
}

boolean overCircle(float x, float y, int diameter) 
{
  float disX = x - mouseX;
  float disY = y - mouseY;
  if(sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}

/////////////////////////////////////////
/////////////////////////////////////////

class Vehicle
{
  int wom_length = 20;
  int direction = 1;
  float pos_x, pos_y;
  float lineRotate;
  float lineRotateNew = 0;
  float lineWidth = 25.0;  // Sets the radius of the circle
  float turnSpeed = 2.0;
  float lineSpeed = 2.0;
  float speed = 0;
  float maxSpeed = 6.0;
  float size = 0.0;
  int red, green, blue;

  int type;
  float[] past_x = new float[wom_length];
  float[] past_y = new float[wom_length];
  int id;
  int randval = 0;

  Vehicle(float x, float y, float angle, int cc, int r, int g, int b)
  {
    pos_x = x;
    pos_y = y;
    for (int i=0; i<wom_length; i++) {
      past_x[i] = pos_x;
      past_y[i] = pos_y;
    }
    lineRotate = lineRotateNew = angle;
    type = cc;

    lineWidth = 10.0;
    turnSpeed = 0.5;
    speed = 0;

    id = cc;
    red = r;
    green = g;
    blue = b;
  }

  float hump(float sa)
  {
    sa = (sa - 0.5) * 2.0; //scale from -1 to 1
    sa = 1 - sa*sa;
    return sa;
  }

  int clamp(float here)
  {
    float me = Math.max(0, here);
    me = Math.min( me, 255);
    return int(me);
  }

  void update()
  { 
    lineRotateNew = lineRotate/180.0 * PI;

    // Position of left sensor
    float lrn = lineRotateNew+PI/5.0;
    float left_sensor_x = pos_x + cos(lrn)*lineWidth;
    float left_sensor_y = pos_y + sin(lrn)*lineWidth;

    // Position of right sensor
    float lrl = lineRotateNew-PI/5.0;
    float right_sensor_x = pos_x + cos(lrl)*lineWidth;
    float right_sensor_y = pos_y + sin(lrl)*lineWidth;

    lineSpeed = 0.0;

    for (int i=0; i<numLights; i++) {
      float light_x = lights[i].lightX;
      float light_y = lights[i].lightY;

      // Distance from left sensor
      float dx = light_x - left_sensor_x;
      float dy = light_y - left_sensor_y;
      float ld = sqrt(dx*dx + dy*dy);

      // Distance from right sensor
      dx = light_x - right_sensor_x;
      dy = light_y - right_sensor_y;
      float rd = sqrt(dx*dx + dy*dy);

      float norm_sensor_left = ld/maxDistance;
      norm_sensor_left =  hump(norm_sensor_left);
      float norm_sensor_right = rd/maxDistance;
      norm_sensor_right =  hump(norm_sensor_right);
      float norm_sensor_average = (norm_sensor_left + norm_sensor_right) / 2.0;

      // SPEED
      lineSpeed += (maxSpeed - (maxSpeed * norm_sensor_average) ) / 10.0;

      // TURNING
      if (type == 0) {
        lineRotate += ld/turnSpeed * (1-norm_sensor_left);
        lineRotate -= rd/turnSpeed * (1-norm_sensor_right);
      } else if (type == 1) {
        lineRotate += rd/turnSpeed * (1-norm_sensor_left);
        lineRotate -= ld/turnSpeed * (1-norm_sensor_right);
      } else if (type == 2) {
        lineRotate -= (ld/turnSpeed * (1-norm_sensor_left));
        lineRotate += (rd/turnSpeed * (1-norm_sensor_right));
      } else if (type == 3) {
        lineRotate -= (rd/turnSpeed * (1-norm_sensor_left));
        lineRotate += (ld/turnSpeed * (1-norm_sensor_right));
      }

      // Add a small random element to simulate a course surface
      lineRotate += random(-2, 2); // larger numbers create varied movement

      // Convert to radians
      lineRotateNew = radians(lineRotate);

      if (lineRotateNew < PI/2.0) {
        float yd = sin(lineRotateNew) * lineSpeed;
        float xd = cos(lineRotateNew) * lineSpeed;
        pos_x += xd * direction;
        pos_y += yd * direction;
      } else if (lineRotateNew < PI) {
        lineRotateNew -= PI/2.0;
        float yd = cos(lineRotateNew) * lineSpeed;
        float xd = sin(lineRotateNew) * lineSpeed;
        pos_x -= xd * direction;
        pos_y += yd * direction;
      } else if (lineRotateNew < PI + PI/2.0) {
        lineRotateNew -= PI;
        float yd = sin(lineRotateNew) * lineSpeed;
        float xd = cos(lineRotateNew) * lineSpeed;
        pos_x -= xd * direction;
        pos_y -= yd * direction;
      } else {
        lineRotateNew -= PI+PI/2.0;
        float yd = cos(lineRotateNew) * lineSpeed;
        float xd = sin(lineRotateNew) * lineSpeed;
        pos_x += xd * direction;
        pos_y -= yd * direction;
      }

      int pw = width;
      int ph = height;
      if(pos_x > pw+size || pos_x < -size || pos_y > ph+size || pos_y < -size) {
        if(pos_x > pw+size) { 
          pos_x = past_x[0]; 
          pos_y = past_y[0];
        }
        if(pos_x < -size) { 
          pos_x = past_x[0]; 
          pos_y = past_y[0];
        }
        if(pos_y > ph+size) { 
          pos_x = past_x[0]; 
          pos_y = past_y[0]; 
        }
        if(pos_y < -size) { 
          pos_x = past_x[0]; 
          pos_y = past_y[0]; 
        }
        reset();
      }

      for (int j=wom_length-1; j>0; j--) {
        past_x[j] = past_x[j-1];
        past_y[j] = past_y[j-1];
      }
      past_x[0] = pos_x;
      past_y[0] = pos_y;
    }

  }

  void reset()
  {
    direction *= -1;
    lineRotate += 1;
  }

  void draw()  
  {
    stroke(red, green, blue);
    beginShape(LINE_STRIP);
    for( int j=1; j<wom_length; j++) {
      if(past_x[j] < width) {
        vertex(past_x[j], past_y[j], 0);
      }
    }
    endShape();
  }
}


