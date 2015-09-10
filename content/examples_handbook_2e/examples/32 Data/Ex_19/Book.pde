class Book {

  String title;
  String author;
  int isbn;
  float w, h, d;

  Book(JSONObject b) {
    title = b.getString("title");
    author = b.getString("author");
    isbn = b.getInt("ISBN-10");
    JSONArray dims = b.getJSONArray("dimensions");
    w = dims.getFloat(0);
    h = dims.getFloat(1);
    d = dims.getFloat(2);
    println(title, author, isbn, w, h, d);
  }

  float getDepth() {
    return d;
  }

  void display() {
    fill(0);
    stroke(255);
    box(w, d, h);
  }
}

