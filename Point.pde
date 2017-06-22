class Point extends Body {
  
  Point(PVector pos, float diameter, float mass){
    position = pos;
    this.diameter = diameter;
    this.mass = mass;
    allPoints.add(this);
  }
  
  //void checkhover () {
  //  PVector mousePos = new PVector(mouseX, mouseY);
  //  float dis = dist(position.x, position.y, mousePos.x, mousePos.y);
  //    if ( dis < 60) {
  //      isOver = true;
  //    } else {
  //      isOver = false;
  //    }
      
  //    if (release && isOver) {
  //      position.x = mouseX;
  //      position.y = mouseY;
  //    }
  //    //println(isOver);
  //}
  
  void newPos(float x, float y){
    position.x = x;
    position.y = y;
  }
  
  void changeMass (int mass) {
    this.mass = mass;
  }
  
  void Update(){
    this.draw();
  }
  
  void Die(){
    allPoints.remove(this);
  }
  
  void draw(){
    ellipse(position.x, position.y, 20,20);
    //imageMode(CENTER);
    //    image(star, position.x, position.y); 

  }
}