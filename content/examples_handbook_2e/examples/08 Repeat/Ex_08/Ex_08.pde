background(255);
strokeWeight(2);
for (int i = 0; i < 100; i += 4) { 
  // The variable is used for the position and gray value
  stroke(i*2.5); 
  line(i, 0, i, 200); 
} 
