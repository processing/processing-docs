JSONArray animals;

void setup() {
  animals = loadJSONArray("animals.json");
  println(animals.size());
}
