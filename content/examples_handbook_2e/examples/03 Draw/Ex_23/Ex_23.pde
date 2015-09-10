// Top row, filled and stroked
arc(20, 20, 28, 28, radians(0), radians(225), OPEN);
arc(50, 20, 28, 28, radians(0), radians(225), CHORD);
arc(80, 20, 28, 28, radians(0), radians(225), PIE);
// Middle row, not stroked
noStroke();
arc(20, 50, 28, 28, radians(0), radians(225), OPEN);
arc(50, 50, 28, 28, radians(0), radians(225), CHORD);
arc(80, 50, 28, 28, radians(0), radians(225), PIE);
// Bottom row, not filled
stroke(0);
noFill();
arc(20, 80, 28, 28, radians(0), radians(225), OPEN);
arc(50, 80, 28, 28, radians(0), radians(225), CHORD);
arc(80, 80, 28, 28, radians(0), radians(225), PIE);
