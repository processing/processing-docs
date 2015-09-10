int s = 6;  // Seed value
size(700, 100);
stroke(255, 102);
randomSeed(s);  // Produce the same numbers each time
background(0);  
for (int i = 0; i < width; i+=6) { 
  float r = random(-10, 10);
  strokeWeight(abs(r));
  line(i-r, 100, i+r, 0); 
}
