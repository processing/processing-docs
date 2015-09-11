Table stats;

void setup() {
  stats = loadTable("ortiz.csv");
  for (int i = 0; i < stats.getRowCount(); i++) {
    // Gets an integer from row i, column 0 in the file
    int year = stats.getInt(i, 0);
    // Gets the integer from row i, column 1
    int homeRuns = stats.getInt(i, 1);
    int rbi = stats.getInt(i, 2);
    // Read a number that includes decimal points
    float average = stats.getFloat(i, 3);
    println(year, homeRuns, rbi, average);
  }
}