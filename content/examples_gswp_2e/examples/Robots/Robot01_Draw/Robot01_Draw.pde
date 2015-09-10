size(720, 480);
strokeWeight(2);
background(0, 153, 204);    // Blue background
ellipseMode(RADIUS);

// Neck
stroke(255);                // Set stroke to white
line(266, 257, 266, 162);   // Left
line(276, 257, 276, 162);   // Middle
line(286, 257, 286, 162);   // Right

// Antennae
line(276, 155, 246, 112);   // Small
line(276, 155, 306, 56);    // Tall
line(276, 155, 342, 170);   // Medium

// Body
noStroke();                 // Disable stroke
fill(255, 204, 0);          // Set fill to orange
ellipse(264, 377, 33, 33);  // Antigravity orb 
fill(0);                    // Set fill to black
rect(219, 257, 90, 120);    // Main body
fill(255, 204, 0);          // Set fill to yellow
rect(219, 274, 90, 6);      // Yellow stripe

// Head
fill(0);                    // Set fill to black
ellipse(276, 155, 45, 45);  // Head
fill(255);                  // Set fill to white
ellipse(288, 150, 14, 14);  // Large eye
fill(0);                    // Set fill to black
ellipse(288, 150, 3, 3);    // Pupil
fill(153, 204, 255);        // Set fill to light blue
ellipse(263, 148, 5, 5);    // Small eye 1
ellipse(296, 130, 4, 4);    // Small eye 2
ellipse(305, 162, 3, 3);    // Small eye 3