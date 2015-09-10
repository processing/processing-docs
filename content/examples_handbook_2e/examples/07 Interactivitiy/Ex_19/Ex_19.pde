void setup() {
  size(100, 100);
  stroke(0);
}

void draw() { 
  if (keyPressed == true) { 
    int x = key - 32;
    line(x, 0, x, height);  
  } 
} 

