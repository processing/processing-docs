
function EggRing(x,  y,  t,  sp) {
  this.ovoid = new Egg(x, y, t, sp);
  this.circle = new Ring();
  this.circle.start(x, y - sp/2);
  
  this.transmit = function() {
    this.ovoid.wobble();
    this.ovoid.display();
    this.circle.grow();
    this.circle.display();
    if (this.circle.on == false) {
      this.circle.on = true;
    }
  }
}
