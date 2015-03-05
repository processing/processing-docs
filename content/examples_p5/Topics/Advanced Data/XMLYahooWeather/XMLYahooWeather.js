/**
 * Loading XML Data
 * by Daniel Shiffman.  
 * 
 * This example demonstrates how to use loadXML()
 * to retrieve data from an XML document via a URL
 */

// Also needs this resolved: https://github.com/processing/p5.js/issues/562

// We're going to store the temperature
var temperature = 0;
// We're going to store text about the weather
String weather = "";

// The zip code we'll check for
String zip = "10003";

PFont font;

function setup() {
  createCanvas(600, 360);
  
  font = createFont("Merriweather-Light.ttf", 28);
  textFont(font);

  // The URL for the XML document
  String url = "http://xml.weather.yahoo.com/forecastrss?p=" + zip;
  
  // Load the XML document
  XML xml = loadXML(url);

  // Grab the element we want
  XML forecast = xml.getChild("channel/item/yweather:forecast");
  
  // Get the attributes we want
  temperature = forecast.getInt("high");
  weather = forecast.getString("text");
}

function draw() {
  background(255);
  fill(0);

  // Display all the stuff we want to display
  text("Zip code: " + zip, width*0.15, height*0.33);
  text("Today’s high: " + temperature, width*0.15, height*0.5);
  text("Forecast: " + weather, width*0.15, height*0.66);

}
