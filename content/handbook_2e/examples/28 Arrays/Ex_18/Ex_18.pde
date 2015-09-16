String[] trees = { "ash", "oak" };
append(trees, "maple"); // INCORRECT! Does not change the array 
printArray(trees); // Prints [0] "ash",  [1] "oak"
println();

trees = append(trees, "maple"); // Add "maple" to the end 
printArray(trees); // Prints [0] "ash",  [1] "oak", [2] "maple"
println();

// Add "beech" to the end of the trees array, and creates a new 
// array to store the change 
String[] moretrees = append(trees, "beech"); 
// Prints [0] "ash", [1] "oak", [2] "maple", [3] "beech"
printArray(moretrees);
