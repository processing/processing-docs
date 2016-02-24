// Class for animating a sequence of GIFs


function Animation(imagePrefix, count) {
  this.imageCount = count;
  this.images = [];
  this.frame = 0;

  for (var i = 0; i < this.imageCount; i++) {
    // Use nf() to number format 'i' into four digits
    var filename = imagePrefix + nf(i, 4) + ".gif";
    this.images[i] = loadImage(filename);
  }
  
  this.display = function(xpos, ypos) {
    this.frame = (this.frame+1) % this.imageCount;
    image(this.images[this.frame], xpos, ypos);
  }
  
  this.getWidth = function() {
    return this.images[0].width;
  }
}
