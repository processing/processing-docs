// The Flock (a list of Boid objects)

function Flock() {
  // An array for all the boids
  this.boids = []; // Initialize the array

  this.run = function() {
    for (var i = 0; i < this.boids.length; i++) {
      this.boids[i].run(this.boids);  // Passing the entire list of boids to each boid individually
    }
  }

  this.addBoid = function(b) {
    this.boids.push(b);
  }
}


