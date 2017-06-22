class Grid {
  
  int diameter;
  PVector gravInfluence;
  PVector springBack;
  int spring;
 
  Grid(float xin, float yin, int din, int springIn) { //are xin and yin the coords of a dot
    diameter = din;
    gravInfluence = new PVector(xin, yin);
    springBack = new PVector(xin, yin);
    spring = springIn;
  }
  
  PVector gravityPushBack(PVector otherPos) {
    PVector direction = new PVector(springBack.x - otherPos.x, springBack.y - otherPos.y);
    direction.normalize();
    float d = dist(otherPos.x, otherPos.y, springBack.x, springBack.y);
    direction.mult(1000/(d*d));
    return direction;
  }
  
 
  void applyGravity() {
    
    for(Point planet : allPoints){
      PVector gravity = planet.gridGrav(gravInfluence);
      gravInfluence.add(gravity);
      
      if(dist(gravInfluence.x, gravInfluence.y, planet.position.x, planet.position.y) <= (diameter + planet.diameter)/2){
        gravInfluence.x = springBack.x;
        gravInfluence.y = springBack.y;
      } 
    }

    
  }
  
  void keepShape () {
    PVector direction = new PVector(springBack.x - gravInfluence.x, springBack.y - gravInfluence.y);
    direction.normalize();
    float d = dist(gravInfluence.x, gravInfluence.y, springBack.x, springBack.y);
    direction.mult(d/spring);
    PVector gravityReturn = direction;
    gravInfluence.add(gravityReturn);
  }
  
  void display() {
    fill(255);
    ellipse(gravInfluence.x, gravInfluence.y, diameter, diameter);
  }
  
}