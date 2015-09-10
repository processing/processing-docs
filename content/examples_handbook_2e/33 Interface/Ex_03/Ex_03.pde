// Requires the OverRect and OverCircle classes

OverRect r;
OverCircle c;

void setup() { 
  size(100, 100); 
  r = new OverRect(9, 30, 36);
  c = new OverCircle(72, 48, 40);
  noStroke(); 
} 
 
void draw() { 
  background(204); 
  r.update(mouseX, mouseY);
  r.display();
  c.update(mouseX, mouseY);
  c.display();
} 
