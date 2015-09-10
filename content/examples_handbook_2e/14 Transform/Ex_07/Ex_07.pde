pushMatrix();
translate(20, 0);
rect(0, 10, 70, 20);  // Draw at (20, 10)
pushMatrix();
translate(30, 0);  
rect(0, 30, 70, 20);  // Draw at (50, 30)
popMatrix();
rect(0, 50, 70, 20);  // Draw at (20, 50)
popMatrix();
rect(0, 70, 70, 20);  // Draw at (0, 70) 
