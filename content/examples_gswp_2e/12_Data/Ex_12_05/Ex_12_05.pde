Film[] films;

void setup() {
  size(480, 120);
  JSONArray filmArray = loadJSONArray("films.json");
  films = new Film[filmArray.size()];
  for (int i = 0; i < films.length; i++) {
    JSONObject o = filmArray.getJSONObject(i);
    films[i] = new Film(o);
  }
}

void draw() {
  background(0);
  for (int i = 0; i < films.length; i++) {
    int x = i*32 + 32;
    films[i].display(x, 105);
  }
}

class Film {

  String title;
  String director;
  int year;
  float rating;

  Film(JSONObject f) {
    title = f.getString("title");
    director = f.getString("director");
    year = f.getInt("year");
    rating = f.getFloat("rating");
  }
  
  void display(int x, int y) {
    float ratingGray = map(rating, 6.5, 8.1, 102, 255);
    pushMatrix();
    translate(x, y);
    rotate(-QUARTER_PI);
    fill(ratingGray);
    text(title, 0, 0);
    popMatrix();
  }
}