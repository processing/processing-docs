size(700, 100);
stroke(255, 102);
background(0);  
for (int i = 0; i < width; i+=6) { 
  float r = random(-10, 10);
  strokeWeight(abs(r));
  line(i-r, 100, i+r, 0); 
} 
