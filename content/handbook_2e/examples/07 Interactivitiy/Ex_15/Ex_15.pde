void setup() {
  size(100, 100);

  strokeWeight(4);
}

void draw() { 
  background(204);
  if (keyPressed == true) {  // If the key is pressed,
    line(20, 20, 80, 80);    // draw a line
  } else {                   // Otherwise,
    rect(40, 40, 20, 20);    // draw a rectangle
  } 
}   
      
