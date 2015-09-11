background(0);
noFill();
stroke(204);
translate(33, 66);              // Set initial offset
for (int i = 0; i < 12; i++) {  // 12 repetitions
  scale(1.2);                   // Accumulate the scaling
  ellipse(4, 2, 20, 20); 
}
