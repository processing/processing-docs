Table cars;

void setup() {
  size(100, 100);
  cars = loadTable("cars.tsv", "header");
  for (TableRow row : cars.rows()) {
    String id = row.getString("name");
    int mpg = row.getInt("mpg");
    println(id + ", " + mpg + " miles per gallon");
  }
}
