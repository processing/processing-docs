Table cities;

void setup() {
  size(240, 120);
  cities = loadTable("cities.csv", "header");
  stroke(255);
}

void draw() {
  background(0, 26, 51);
  float xoffset = map(mouseX, 0, width, -width*3, -width);
  translate(xoffset, -300);
  scale(10);
  strokeWeight(0.1);
  for (int i = 0; i < cities.getRowCount(); i++) {
    float latitude = cities.getFloat(i, "lat");
    float longitude = cities.getFloat(i, "lng");
    setXY(latitude, longitude);
  }
}

void setXY(float lat, float lng) {
  float x = map(lng, -180, 180, 0, width);
  float y = map(lat, 90, -90, 0, height);
  point(x, y);
}