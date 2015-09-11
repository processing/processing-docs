JSONArray animals;

void setup() {
  animals = loadJSONArray("animals.json");
  for (int i = 0; i < animals.size(); i++) {
    JSONObject a = animals.getJSONObject(i); 
    String name = a.getString("name");
    String species = a.getString("species");
    println(name + ", " + species);
  }
}
