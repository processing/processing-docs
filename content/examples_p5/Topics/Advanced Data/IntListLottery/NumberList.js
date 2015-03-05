  /**
   *  Table objects store data with multiple rows and columns, much
   *  like in a traditional spreadsheet. Tables can be generated from
   *  scratch, dynamically, or using data from an existing file.
   *
   *  @class p5.Table
   *  @constructor
   *  @param  {Array}     [rows] An array of p5.TableRow objects
   *  @return {p5.Table}         p5.Table generated
   */
  p5.NumberList = function (length) {
    /**
     *  @property columns
     *  @type {Array}
     */
    // if no arguments
    if (arguments.length < 1) {
      length = 10;
      this.count = 0;
      this.data = new Array(length);
    // If we are passing in an array
    } else if (length instanceof Array) {
      var list = length;
      this.count = list.length;
      this.data = list.slice();
    // Or we are given a length
    } else {
      this.count = 0;
      this.data = new Array(length);
    }
  };


  /**
   * Improve efficiency by removing allocated but unused entries from the
   * internal array used to store the data. Set to private, though it could
   * be useful to have this public if lists are frequently making drastic
   * size changes (from very large to very small).
   */
  p5.NumberList.prototype.crop = function() {
    if (this.count !== this.data.length) {
      this.data = this.data.splice(0, this.count);
    }
  };


  /**
   * Get the length of the list.
   *
   * @webref floatlist:method
   * @brief Get the length of the list
   */
  p5.NumberList.prototype.size = function() {
    return this.count;
  };


  p5.NumberList.prototype.resize = function(length) {
    if (length < this.data.length) {
      this.data = this.data.slice(0, length);
    } else {
      this.data.fill(0, this.count, length-this.count);
    }
    this.count = length;
  };


  /**
   * Remove all entries from the list.
   *
   * @webref floatlist:method
   * @brief Remove all entries from the list
   */
  p5.NumberList.prototype.clear = function() {
    this.count = 0;
  };


  /**
   * Get an entry at a particular index.
   *
   * @webref floatlist:method
   * @brief Get an entry at a particular index
   */
  p5.NumberList.prototype.get = function(index) {
    return this.data[index];
  };


  /**
   * Set the entry at a particular index. If the index is past the length of
   * the list, it'll expand the list to accommodate, and fill the intermediate
   * entries with 0s.
   *
   * @webref floatlist:method
   * @brief Set the entry at a particular index
   */
  p5.NumberList.prototype.set = function(index, what) {
    if (index >= this.count) {
      for (var i = this.count; i < index; i++) {
        this.data[i] = 0;
      }
      this.count = index+1;
    }
    this.data[index] = what;
  };


  /**
   * Remove an element from the specified index.
   *
   * @webref floatlist:method
   * @brief Remove an element from the specified index
   */
  p5.NumberList.prototype.remove = function(index) {
    if (index < 0 || index >= this.count) {
      throw index + ' is not a valid index for this NumberList';
    }
    var entry = this.data[index];
    // For most cases, this actually appears to be faster
    // than arraycopy() on an array copying into itself.
    for (var i = index; i < this.count-1; i++) {
      this.data[i] = this.data[i+1];
    }
    this.count--;
    return entry;
  };


  // Remove the first instance of a particular value,
  // and return the index at which it was found.
  p5.NumberList.prototype.removeValue = function(value) {
    var index = this.index(value);
    if (index !== -1) {
      this.remove(index);
      return index;
    }
    return -1;
  };


  // Remove all instances of a particular value,
  // and return the number of values found and removed
  p5.NumberList.prototype.removeValues = function(value) {
    var ii = 0;
    var i;
    if (isNaN(value)) {
      for (i = 0; i < this.count; i++) {
        if (!isNaN(this.data[i])) {
          this.data[ii++] = this.data[i];
        }
      }
    } else {
      for (i = 0; i < this.count; i++) {
        if (this.data[i] !== value) {
          this.data[ii++] = this.data[i];
        }
      }
    }
    var removed = this.count - ii;
    this.count = ii;
    return removed;
  };


  /** Replace the first instance of a particular value */
  p5.NumberList.prototype.replaceValue = function(value, newValue) {
    if (isNaN(value)) {
      for (var i = 0; i < this.count; i++) {
        if (isNaN(this.data[i])) {
          this.data[i] = newValue;
          return true;
        }
      }
    } else {
      var index = this.index(value);
      if (index !== -1) {
        this.data[index] = newValue;
        return true;
      }
    }
    return false;
  };


  /** Replace all instances of a particular value */
  p5.NumberList.prototype.replaceValues = function(value, newValue) {
    var changed = false;
    var i;
    if (isNaN(value)) {
      for (i = 0; i < this.count; i++) {
        if (isNaN(this.data[i])) {
          this.data[i] = newValue;
          changed = true;
        }
      }
    } else {
      for (i = 0; i < this.count; i++) {
        if (this.data[i] === value) {
          this.data[i] = newValue;
          changed = true;
        }
      }
    }
    return changed;
  };



  /**
   * Add a new entry to the list.
   *
   * @webref floatlist:method
   * @brief Add a new entry to the list
   */
  p5.NumberList.prototype.append = function(value) {
    if (value instanceof Array) {
      for (var i = 0; i < value.length; i++) {
        this.append(value[i]);
      }
    } else if (value instanceof p5.NumberList) {
      var newData = value.slice(0, value.count);
      this.append(newData);
    } else {
      this.data[this.count++] = value;
    }
  };
  

  // Basically splice() but you can insert a full array or NumberList
  p5.NumberList.prototype.insert = function(index, value) {
    if (index < 0) {
      throw 'insert() index cannot be negative: it was ' + index;
    }
    if (index >= this.data.length) {
      throw 'insert() index ' + index + ' is past the end of this list';
    }
    if (value instanceof Array) {
      for (var i = 0; i < value.length; i++) {
        this.insert(index, value[i]);
      }
    } else if (value instanceof p5.NumberList) {
      var newData = value.slice(0, value.count);
      this.insert(index, newData);
    } else {
      this.data.splice(index, 0, value);
      this.count++;
    }
  };

  /** Return the first index of a particular value. */
  // This should maybe be getIndex()
  p5.NumberList.prototype.index = function(what) {
    for (var i = 0; i < this.count; i++) {
      if (this.data[i] === what) {
        return i;
      }
    }
    return -1;
  };


  /**
   * @webref floatlist:method
   * @brief Check if a number is a part of the list
   */
  p5.NumberList.prototype.hasValue = function(value) {
    var i;
    if (isNaN(value)) {
      for (i = 0; i < this.count; i++) {
        if (isNaN(this.data[i])) {
          return true;
        }
      }
    } else {
      for (i = 0; i < this.count; i++) {
        if (this.data[i] === value) {
          return true;
        }
      }
    }
    return false;
  };


  p5.NumberList.prototype.boundsProblem = function(index, method) {
    var msg = 'The list size is ' + this.count + '.  You cannot ';
    msg +=  method + '() to element ' + index + '.';
    throw msg;
  };

  /**
   * @webref floatlist:method
   * @brief Add to a value
   */
  p5.NumberList.prototype.add = function(index, amount) {
    if (index < this.count) {
      this.data[index] += amount;
    } else {
      this.boundsProblem(index, 'add');
    }
  };


  /**
   * @webref floatlist:method
   * @brief Subtract from a value
   */
  p5.NumberList.prototype.sub = function(index, amount) {
    if (index < this.count) {
      this.data[index] -= amount;
    } else {
      this.boundsProblem(index, 'sub');
    }
  };


  /**
   * @webref floatlist:method
   * @brief Multiply a value
   */
  p5.NumberList.prototype.mult = function(index, amount) {
    if (index < this.count) {
      this.data[index] *= amount;
    } else {
      this.boundsProblem(index, 'mult');
    }
  };


  /**
   * @webref floatlist:method
   * @brief Divide a value
   */
  p5.NumberList.prototype.div = function(index, amount) {
    if (index < this.count) {
      this.data[index] /= amount;
    } else {
      this.boundsProblem(index, 'div');
    }
  };


  p5.NumberList.prototype.checkMinMax = function(functionName) {
    if (this.count === 0) {
      throw 'Cannot use ' + functionName + ' on an empty NumberList.';
    }
  };


  /**
   * @webref floatlist:method
   * @brief Return the smallest value
   */
  p5.NumberList.prototype.min = function() {
    this.checkMinMax('min');
    var index = this.minIndex();
    return index === -1 ? NaN : this.data[index];
  };


  p5.NumberList.prototype.minIndex = function() {
    this.checkMinMax('minIndex');
    var m = NaN;
    var mi = -1;
    for (var i = 0; i < this.count; i++) {
      // find one good value to start
      if (this.data[i] === this.data[i]) {
        m = this.data[i];
        mi = i;

        // calculate the rest
        for (var j = i+1; j < this.count; j++) {
          var d = this.data[j];
          if (!isNaN(d) && (d < m)) {
            m = this.data[j];
            mi = j;
          }
        }
        break;
      }
    }
    return mi;
  };


  /**
   * @webref floatlist:method
   * @brief Return the largest value
   */
  p5.NumberList.prototype.max = function() {
    this.checkMinMax('max');
    var index = this.maxIndex();
    return index === -1 ? NaN : this.data[index];
  };


  p5.NumberList.prototype.maxIndex = function() {
    this.checkMinMax('maxIndex');
    var m = NaN;
    var mi = -1;
    for (var i = 0; i < this.count; i++) {
      // find one good value to start
      if (this.data[i] === this.data[i]) {
        m = this.data[i];
        mi = i;

        // calculate the rest
        for (var j = i+1; j < this.count; j++) {
          var d = this.data[j];
          if (!isNaN(d) && (d > m)) {
            m = this.data[j];
            mi = j;
          }
        }
        break;
      }
    }
    return mi;
  };


  p5.NumberList.prototype.sum = function() {
    var outgoing = 0;
    for (var i = 0; i < this.count; i++) {
      outgoing += this.data[i];
    }
    return outgoing;
  };


  /**
   * Sorts the array in place.
   *
   * @webref floatlist:method
   * @brief Sorts an array, lowest to highest
   */
  p5.NumberList.prototype.sort = function() {
    // This seems like a place to use native JS sort
    // So it's silly to have to deal with extra spots
    this.crop();
    this.data.sort(function(a, b) {
      return a > b;
    });
  };


  /**
   * Reverse sort, orders values from highest to lowest
   *
   * @webref floatlist:method
   * @brief Reverse sort, orders values from highest to lowest
   */
  p5.NumberList.prototype.sortReverse = function() {
    // This seems like a place to use native JS sort
    // So it's silly to have to deal with extra spots
    this.crop();
    this.data.sort(function(a, b) {
      return a < b;
    });
  };

  /**
   * @webref floatlist:method
   * @brief Reverse the order of the list elements
   */
  p5.NumberList.prototype.reverse = function() {
    var ii = this.count - 1;
    for (var i = 0; i < this.count/2; i++) {
      var t = this.data[i];
      this.data[i] = this.data[ii];
      this.data[ii] = t;
      --ii;
    }
  };


  /**
   * Randomize the list order using the random() function from the specified
   * sketch, allowing shuffle() to use its current randomSeed() setting.
   */
  p5.NumberList.prototype.shuffle = function() {
    var num = this.count;
    while (num > 1) {
      var value = 0;
      if (this.p5) {
        value = Math.floor(this.p5.random(num));
      } else {
        value = Math.floor(Math.random()*num);
      }
      num--;
      var temp = this.data[num];
      this.data[num] = this.data[value];
      this.data[value] = temp;
    }
  };


  p5.NumberList.prototype.copy = function() {
    var outgoing = new p5.NumberList(this.data);
    outgoing.count = this.count;
    return outgoing;
  };


  /**
   * Returns the actual array being used to store the data. For advanced users,
   * this is the fastest way to access a large list. Suitable for iterating
   * with a for() loop, but modifying the list will have terrible consequences.
   */
  p5.NumberList.prototype.values = function() {
    this.crop();
    return this.data;
  };


//   /** Implemented this way so that we can use a FloatList in a for loop. */
//   @Override
//   public Iterator<Float> iterator() {
// //  }
// //
// //
// //  public Iterator<Float> valueIterator() {
//     return new Iterator<Float>() {
//       int index = -1;

//       public void remove() {
//         FloatList.this.remove(index);
//       }

//       public Float next() {
//         return data[++index];
//       }

//       public boolean hasNext() {
//         return index+1 < count;
//       }
//     };
//   }


  /**
   * Create a new array with a copy of all the values.
   * @return an array sized by the length of the list with each of the values.
   * @webref floatlist:method
   * @brief Create a new array with a copy of all the values
   */
  /**
   * Copy values into the specified array. If the specified array is null or
   * not the same size, a new array will be allocated.
   * @param array
   */
  p5.NumberList.prototype.array = function(array) {
    if (!array || array.length !== this.count) {
      array = new Array(this.count);
    }
    for (var i = 0; i < array.length; i++) {
      array[i] = this.data[i];
      // System.arraycopy(data, 0, array, 0, count);
    }
    return array;
  };


  /**
   * Returns a normalized version of this array. Called getPercent() for
   * consistency with the Dict classes. It's a getter method because it needs
   * to returns a new list (because IntList/Dict can't do percentages or
   * normalization in place on int values).
   */
  p5.NumberList.prototype.getPercent = function(array) {
  //public FloatList getPercent() {
    var sum = 0;
    var i;
    for (i = 0; i < this.count; i++) {
      sum += this.data[i];
    }
    var outgoing = new p5.NumberList(this.count);
    for (i = 0; i < this.count; i++) {
      var percent = this.data[i] / sum;
      outgoing.set(i, percent);
    }
    return outgoing;
  };



  p5.NumberList.prototype.getSubset = function(start, num) {
    var end = (start + num) || this.count;
    var subset = this.data.slice(start, end);
    return new p5.NumberList(subset);
  };


  p5.NumberList.prototype.join = function(separator) {
    if (this.count === 0) {
      return '';
    }
    var sb = this.data[0];
    for (var i = 1; i < this.count; i++) {
      sb += separator;
      sb += this.data[i];
    }
    return sb;
  };


  p5.NumberList.prototype.print = function() {
    for (var i = 0; i < this.size(); i++) {
      console.log('[' + i + '] ' +  this.data[i]);
    }
  };


  p5.NumberList.prototype.toString = function() {
    var sb = '';
    sb += 'NumberList size=' + this.size() + ' [ ';
    for (var i = 0; i < this.size(); i++) {
      if (i !== 0) {
        sb += ', ';
      }
      sb += i + ': ' + this.data[i];
    }
    sb += ' ]';
    return sb;
  };

