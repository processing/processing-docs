size(100, 100, P2D);
background(0);
stroke(255);
strokeWeight(2);
line(33, 0, 85, 100);
noStroke();
fill(102);
// Start inner triangle
beginShape();  
vertex(5, 12);
vertex(95, 12);
vertex(50, 92);
endShape();
fill(255); 
// Start outer triangle
beginShape();  
vertex(50, 20);
vertex(66, 50);
vertex(33, 50);
endShape();
