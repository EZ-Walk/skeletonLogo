abstract class Body {
  PVector position;
  float diameter;
  float mass;

  abstract void Update();
  abstract void Die();

  //void Destroy(){
  //  toDestroy.add(this);
  //}
  

  PVector gravityAt(PVector otherPos) {
    PVector direction = new PVector(position.x - otherPos.x, position.y - otherPos.y);
    direction.normalize();
    float d = dist(otherPos.x, otherPos.y, position.x, position.y);
    direction.mult(mass/(d*d));
    return direction;
  }
  
  PVector gridGrav(PVector otherPos) {
    PVector direction = new PVector(position.x - otherPos.x, position.y - otherPos.y);
    direction.normalize();
    float d = dist(otherPos.x, otherPos.y, position.x, position.y);
    direction.mult((mass*2)/(d*d)); //double mass to exaggerate effect on grid
    return direction;
  }
  
  abstract void draw();
}