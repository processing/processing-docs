XML xml;

void setup() {
  xml = loadXML("mammals.xml");
  XML[] animals = xml.getChildren("animal");
  println(animals.length);
}
