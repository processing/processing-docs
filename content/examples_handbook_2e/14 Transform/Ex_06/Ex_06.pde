pushMatrix(); 
translate(33, 0);  // Shift 33 pixels right
rect(0, 20, 66, 30);
popMatrix();  // Remove the shift
// This shape is not affected by translate() because 
// it is isolated between pushMatrix() and popMatrix()
rect(0, 50, 66, 30); 
