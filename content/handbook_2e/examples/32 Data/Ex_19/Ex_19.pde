JSONArray bookData;
Book[] books;

void setup() {
  size(100, 100, P3D);
  bookData = loadJSONArray("books.json");
  books = new Book[bookData.size()];
  for (int i = 0; i < books.length; i++) {
    JSONObject b = bookData.getJSONObject(i); 
    books[i] = new Book(b);
  }
}

void draw() {
  background(204);
  translate(50, 20, -50);
  scale(10);
  strokeWeight(0.1);
  float angle = map(mouseX, 0, width, -1, 1);
  rotateY(angle);  // Rotate with mouseX
  for (Book b : books) {
    b.display();
    translate(0, b.getDepth(), 0);
  } 
}
