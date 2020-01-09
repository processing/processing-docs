/*
  This class represents a cubic Bézier curve.

  getPointAtParameter() method works the same as bezierPoint().

  Points returned from this method are closer to each other
  at places where the curve bends and farther apart where the
  curve runs straight.

  On the orther hand, getPointAtFraction() and getPointAtLength()
  return points at fixed distances. This is useful in many scenarios:
  you may want to move an object along the curve at some speed
  or you may want to draw dashed Bézier curves.
*/


class BezierCurve {
  
  private final int SEGMENT_COUNT = 100;
  
  private PVector v0, v1, v2, v3;
  
  private float arcLengths[] = new float[SEGMENT_COUNT + 1]; // there are n segments between n+1 points
  
  private float curveLength;
  
  
  BezierCurve(PVector a, PVector b, PVector c, PVector d) {
    v0 = a.get(); // curve begins here
    v1 = b.get();
    v2 = c.get();
    v3 = d.get(); // curve ends here
    
    // The idea here is to make a handy look up table, which contains
    // parameter values with their arc lengths along the curve. Later,
    // when we want a point at some arc length, we can go through our
    // table, pick the place where the point is going to be located and
    // interpolate the value of parameter from two surrounding parameters
    // in our table.

    // we will keep current length along the curve here
    float arcLength = 0;
    
    PVector prev = new PVector();
    prev.set(v0);
    
    // i goes from 0 to SEGMENT_COUNT
    for (int i = 0; i <= SEGMENT_COUNT; i++) {
      
      // map index from range (0, SEGMENT_COUNT) to parameter in range (0.0, 1.0)
      float t = (float) i / SEGMENT_COUNT;
      
      // get point on the curve at this parameter value
      PVector point = pointAtParameter(t);
      
      // get distance from previous point
      float distanceFromPrev = PVector.dist(prev, point);
      
      // add arc length of last segment to total length
      arcLength += distanceFromPrev;
      
      // save current arc length to the look up table
      arcLengths[i] = arcLength;
      
      // keep this point to compute length of next segment
      prev.set(point);
    }
    
    // Here we have sum of all segment lengths, which should be
    // very close to the actual length of the curve. The more
    // segments we use, the more accurate it becomes.
    curveLength = arcLength;
  }
  
  
  // Returns the length of this curve
  float length() {
    return curveLength;
  }
  
  
  // Returns a point along the curve at a specified parameter value.
  PVector pointAtParameter(float t) {
    PVector result = new PVector();
    result.x = bezierPoint(v0.x, v1.x, v2.x, v3.x, t);
    result.y = bezierPoint(v0.y, v1.y, v2.y, v3.y, t);
    result.z = bezierPoint(v0.z, v1.z, v2.z, v3.z, t);
    return result;
  }

  
  
  // Returns a point at a fraction of curve's length.
  // Example: pointAtFraction(0.25) returns point at one quarter of curve's length.
  PVector pointAtFraction(float r) {
    float wantedLength = curveLength * r;
    return pointAtLength(wantedLength);
  }
  
  
  // Returns a point at a specified arc length along the curve.
  PVector pointAtLength(float wantedLength) {
    wantedLength = constrain(wantedLength, 0.0, curveLength);
    
    // look up the length in our look up table
    int index = java.util.Arrays.binarySearch(arcLengths, wantedLength);
    
    float mappedIndex;
    
    if (index < 0) {
      // if the index is negative, exact length is not in the table,
      // but it tells us where it should be in the table
      // see https://docs.oracle.com/javase/8/docs/api/java/util/Arrays.html#binarySearch-float:A-float-
      
      // interpolate two surrounding indexes
      int nextIndex = -(index + 1);
      int prevIndex = nextIndex - 1;
      float prevLength = arcLengths[prevIndex];
      float nextLength = arcLengths[nextIndex];
      mappedIndex = map(wantedLength, prevLength, nextLength, prevIndex, nextIndex);
      
    } else {
      // wanted length is in the table, we know the index right away
      mappedIndex = index;
    }
    
    // map index from range (0, SEGMENT_COUNT) to parameter in range (0.0, 1.0)
    float parameter = mappedIndex / SEGMENT_COUNT;
    
    return pointAtParameter(parameter);
  }
  

  // Returns an array of equidistant point on the curve
  PVector[] equidistantPoints(int howMany) {
    
    PVector[] resultPoints = new PVector[howMany];
    
    // we already know the beginning and the end of the curve
    resultPoints[0] = v0.get();
    resultPoints[howMany - 1] = v3.get(); 
    
    int arcLengthIndex = 1;
    for (int i = 1; i < howMany - 1; i++) {
      
      // compute wanted arc length
      float fraction = (float) i / (howMany - 1);
      float wantedLength = fraction * curveLength;
      
      // move through the look up table until we find greater length
      while (wantedLength > arcLengths[arcLengthIndex] && arcLengthIndex < arcLengths.length) {
        arcLengthIndex++;
      }
      
      // interpolate two surrounding indexes
      int nextIndex = arcLengthIndex;
      int prevIndex = arcLengthIndex - 1;
      float prevLength = arcLengths[prevIndex];
      float nextLength = arcLengths[nextIndex];
      float mappedIndex = map(wantedLength, prevLength, nextLength, prevIndex, nextIndex);
      
      // map index from range (0, SEGMENT_COUNT) to parameter in range (0.0, 1.0)
      float parameter = mappedIndex / SEGMENT_COUNT;
      
      resultPoints[i] = pointAtParameter(parameter);
    }
    
    return resultPoints;
  }
  
  
  // Returns an array of points on the curve.
  PVector[] points(int howMany) {
    
    PVector[] resultPoints = new PVector[howMany];
    
    // we already know the first and the last point of the curve
    resultPoints[0] = v0.get();
    resultPoints[howMany - 1] = v3.get();
    
    for (int i = 1; i < howMany - 1; i++) {
      
      // map index to parameter in range (0.0, 1.0)
      float parameter = (float) i / (howMany - 1);
      
      resultPoints[i] = pointAtParameter(parameter);
    }
    
    return resultPoints;
  }
  
}
