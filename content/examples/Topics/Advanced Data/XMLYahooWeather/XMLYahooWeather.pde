/**
 * Loading XML Data
 * by Daniel Shiffman.  
 * 
 * This example demonstrates how to use loadXML()
 * to retrieve data from an XML document via a URL
 */

// We're going to store the temperature
int temperature = 0;
// We're going to store text about the weather
String weather = "";


// Yahoo weather uses something called A WOEID (Where On Earth IDentifier) 
// https://en.wikipedia.org/wiki/WOEID
// This is the WOEID for zip code 10003
String zip = "10003";
String woeid = "12761335";

PFont font;

void setup() {
  size(600, 360);
  
  font = createFont("Merriweather-Light.ttf", 28);
  textFont(font);

  // The URL for the XML document
  String url = "http://query.yahooapis.com/v1/public/yql?format=xml&q=select+*+from+weather.forecast+where+woeid=" + woeid + "+and+u='F'";
  
  // Load the XML document
  XML xml = loadXML(url);

  // Grab the element we want
  XML forecast = xml.getChild("results/channel/item/yweather:forecast");
  
  // Get the attributes we want
  temperature = forecast.getInt("high");
  weather = forecast.getString("text");
}

void draw() {
  background(255);
  fill(0);

  // Display all the stuff we want to display
  text("Zip: " + zip, width*0.15, height*0.33);
  text("Today’s high: " + temperature + "°F", width*0.15, height*0.5);
  text("Forecast: " + weather, width*0.15, height*0.66);

}