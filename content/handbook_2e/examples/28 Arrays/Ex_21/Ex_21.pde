String[] north = { "OH", "IN", "MI" };
String[] south = { "GA", "FL", "NC" };
arraycopy(north, south); // Copy from north array to south array 
printArray(south); // Prints [0] "OH", [1] "IN", [3] "MI"
println();
String[] east = { "MA", "NY", "RI" };
String[] west = new String[east.length]; // Create a new array 
arraycopy(east, west); // Copy from east array to west array 
printArray(west); // Prints [0] "MA", [1] "NY", [2] "RI"
