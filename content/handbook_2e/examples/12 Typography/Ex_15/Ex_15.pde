String s = "AEIOU";
float tw; // text width
fill(0);
textSize(14);
tw = textWidth(s); 
text(s, 4, 40); 
rect(4, 42, tw, 5);
textSize(28);
tw = textWidth(s); 
text(s, 4, 76); 
rect(4, 78, tw, 5);

