void setup() {
  float temp = getTemp("cincinnati.json");
  println(temp);
}

float getTemp(String fileName) {
  JSONObject weather = loadJSONObject(fileName);
  JSONArray list = weather.getJSONArray("list");
  JSONObject item = list.getJSONObject(0);
  JSONObject main = item.getJSONObject("main");
  float temperature = main.getFloat("temp");
  return temperature;
}