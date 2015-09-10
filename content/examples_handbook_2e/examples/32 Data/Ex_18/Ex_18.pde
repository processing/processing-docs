JSONArray bookData;

void setup() {
  bookData = loadJSONArray("books.json");
  for (int i = 0; i < bookData.size(); i++) {
    JSONObject b = bookData.getJSONObject(i); 
    String title = b.getString("title");
    JSONArray dims = b.getJSONArray("dimensions");
    float w = dims.getFloat(0);
    float h = dims.getFloat(1);
    float d = dims.getFloat(2);
    println(title, w, h, d);
  }
}
