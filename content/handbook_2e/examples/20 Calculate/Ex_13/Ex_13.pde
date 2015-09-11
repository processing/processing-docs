for (int x = 0; x < 100; x++) {
  float n = norm(x, 0.0, 100.0);  // Range 0.0 to 1.0
  float val = n * 255.0;
  stroke(val);
  line(x, 0, x, 50);  // Draw top gradient
  float valSquare = pow(n, 4) * 255.0;
  stroke(valSquare);
  line(x, 50, x, 100);  // Draw bottom gradient
}
