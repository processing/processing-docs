#!/usr/bin/perl
#require 'globals_API.pl';
#require 'globals.pl';


# KEY 2.0b7+
# LITERAL2 - Constants (QUARTER_PI, CORNERS, etc.)
# KEYWORD1 - Java datatypes and keywords (void, int, boolean, etc.)
# KEYWORD2 - Fields [variables within a class]
# KEYWORD3 - Processing variables (width, height, focused, etc.)
# FUNCTION1 - Functions
# FUNCTION2 - Methods (functions inside a class)


$dir = "../content/api_en/";
#$path = "../../processing/build/shared/lib/";
$path = "../../processing/java/";

# Open base file and copy into array
open (BASE, "keywords_base.txt") || die "can't open keywords_base.txt: $!";
@baseinfo = <BASE>; 
close(BASE);
chomp(@baseinfo);

foreach $bi (@baseinfo) {
  push(@modfiles, $bi)
}

# Add a blank line to separate the data
push(@modfiles, "\n");

opendir(DIR, $dir) || die $!;
@tempfiles = readdir(DIR);
closedir(DIR);

foreach $temp (@tempfiles) {
  if($temp =~ ".xml" && !($temp =~ "~")) {
    get_data("$temp");
    $tempname = strip_name($name);
    #$namelength = length($tempname);
    if ($tempname ne "x" && $tempname ne "y" && $tempname ne "z" && $tempname ne "") {
    #if ($tempname ne "") {
      push(@modfiles, strip_name($name) . "\t" . set_category() . "\t" . file_name_convert($temp));
    }
  }
 }


open(KEYWORDS, ">$path/keywords.txt");

foreach $temp (@modfiles) {
  # Add additional API to file
  print KEYWORDS "$temp\n";
  print "$temp\n";
}

close(KEYWORDS);


sub get_data
{
  open (CAT, "$dir/$_[0]") || die "can't open $_[0]: $!";
  @cat = "";
  while (<CAT>) { 
    chomp;
    push(@cat, $_);
    #print "$_\n";
  }
  close CAT;
  foreach $el (@cat) {
    #$type_cat = "";
    if(grep{/^<type>/} $el) {
      $type_cat = $el;
      $type_cat =~ s/<type>//;
      $type_cat =~ s/<\/type>//; 
    }
    if(grep{/^<name>/} $el) {
      $name_cat = $el;
      $name_cat =~ s/<name>//;
      $name_cat =~ s/<\/name>//; 
    }
    if(grep{/^<category>/} $el) {
      $category = $el;
      $category =~ s/<category>//;
      $category =~ s/<\/category>//; 
    }
    if(grep{/^<subcategory>/} $el) {
      $type_subcat = $el;
      $type_subcat =~ s/<subcategory>//;
      $type_subcat =~ s/<\/subcategory>//; 
    }
  }
  $type = $type_cat;
  $name = $name_cat;
  $subcat = $type_subcat;
  $cat = $category;
}

sub strip_name
{
    local ($page) = @_[0];
    
    # Exceptions for constants with PI
    if($page =~ /PI/) {
	  $_ = $page;
	  $page =~ s/\(.*\)//g;   # Remove all between parenthesis
	  $page =~ s/\s//g;       # Remove the spaces
      #print("$page\n");
    }

    $_ = $page;
    if(!($page =~ s/\(\)//g))  # Truncate all functions 
    {
      # Exception for the case of pixels[] and vpixels[]
      if(/pixels\[\]/) {
	    $page =~ s/\[\]//g;
      }

      # Exception for the case of all operators
      if(/\(.*\)/) {
        #$page = $&;        
        $tp = $&;           # Get the entire match
	    $page =~ s/$tp//g;  # Remove the entire match
        $page =~ s/\(//g;   # Remove the left paren
	    $page =~ s/\)//g;   # Remove the right paren
      }
    } 

    # Exception for the case of () (parenthesis)
    if($page =~ /paren/) {
      #$tp = $&;               # Get the entire match
      $page =~ s/\(.*\)/()/g;  # Remove the entire match
    }

    $page =~ s/\s//g;        # Remove the spaces
    $page =~ s/\&lt;/\</g;   # Replace <
    $page =~ s/\&gt;/\</g;   # Replace >
    $page =~ s/\&amp;/\&/g;  # Replace &
    $page =~ s/\*\///g;      # Replace */
 

    return $page;
}

sub set_category
{
    
    # Set the default
	$category = "FUNCTION1";
	
    #if ($name eq $subcat) {
    #	$category = "KEYWORD1";
    #} elsif($subcat =~ s/method/method/i) {
	#	$category = "FUNCTION2";
    #} elsif($subcat =~ s/field/field/i) {
	#	$category = "KEYWORD2";
    #} elsif($cat =~ s/constants/constants/i) {
    #	$category = "LITERAL2";
    #} elsif ($type eq "variable") {
    #    $category = "KEYWORD3";
    #}
    
    if ($subcat =~ s/method/method/i) {
    	$category = "FUNCTION2";
    } elsif($name eq $subcat) {
		$category = "KEYWORD1";
    } elsif($subcat =~ s/field/field/i) {
		$category = "KEYWORD2";
    } elsif($type eq "variable") {
    	$category = "KEYWORD3";
    } elsif ($cat =~ s/constants/constants/i) {
        $category = "LITERAL2";
    }
    
    return $category;
}

sub file_name_convert 
{
    local ($thisfile) = @_[0];

    # Remove the "xml" from the files
    $thisfile =~ s/\.xml//;
    
    # Remove the "converts" from the xml files
    $thisfile =~ s/convert//;

    # Remove the "_var" from the xml files
    $thisfile =~ s/_var//;
    
    # Add an "_" if the reference is a function, structure, or method
    # 27 NOV 2011, this no longer works do to changes in the XML structure
    #if(($type =~ /function/i) || ($type =~ /structure/i) ||($type =~ /method/i)) {
    #  $thisfile = $thisfile . "_";
    #}
    
    if(($category =~ /KEYWORD2/i) || ($category =~ /KEYWORD3/i)) {
    	$thisfile = $thisfile . "_";
    }

    return $thisfile;
}
