// The variable y iterates from 10 to 90 to draw 
// the point 9 times and the variable x iterates from 
// 10 to 90 to draw the point 81 times
for (int y = 10; y < 100; y += 10) {
  for (int x = 10; x < 100; x += 10) {
    point(x, y);
  }
}
