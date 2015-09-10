XML xml;

void setup() {
  xml = loadXML("mammals.xml");
  for (XML a : xml.getChildren("animal")) {
    String name = a.getContent();
    String species = a.getString("species");
    println(name + ", " + species);
  }
}

