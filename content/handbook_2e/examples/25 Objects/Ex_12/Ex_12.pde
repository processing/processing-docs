Spot sp1, sp2;

void setup() { 
  size(100, 100);
  noLoop();
  // Run the constructor without parameters
  sp1 = new Spot();
  // Run the constructor with three parameters  
  sp2 = new Spot(66, 50, 20);
} 
 
void draw() { 
  sp1.display();
  sp2.display();
}

class Spot {
  float x, y, diameter;

  // First version of the Spot constructor;
  // the fields are assigned default values
  Spot() {  
    x = 33;
    y = 50;
    diameter = 8;  
  }

  // Second version of the Spot constructor;
  // the fields are assigned with parameters
  Spot(float xpos, float ypos, float d) {  
    x = xpos;
    y = ypos;
    diameter = d;
  }
  
  void display() {
    ellipse(x, y, diameter, diameter);
  }
}
