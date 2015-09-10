// To print text to the console, place the desired output in quotes
println("Processing...");  // Prints "Processing..." to the console

// To print the value of a variable, rather than its name, 
// don’t put the name of the variable in quotes
int x = 20;
println(x);  // Prints "20" to the console 

// While println() moves to the next line after the text 
// is output, print() does not
print("10"); 
println("20");  // Prints "1020" to the console
println("30");  // Prints "30" to the console 

// Use a comma inside println() to write more than one value
int x2 = 20;
int y2 = 80;
println(x2, y2);  // Prints "20 80" to the console

// Use the "+" operator to combine variables with 
// custom text in between
int x3 = 20;
int y3 = 80;
println(x3 + " and " + y3);  // Prints "20 and 80" to the console
