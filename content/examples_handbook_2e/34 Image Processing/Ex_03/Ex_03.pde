strokeWeight(8);
line(0, 0, width, height);
line(0, height, width, 0);
PImage slice = get(0, 0, 20, 100);  // Get window section
image(slice, 18, 0);
image(slice, 50, 0);
