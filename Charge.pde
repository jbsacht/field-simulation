class SourceCharge{
  private float x;
  private float y;
  private float charge;
  private float diameter = 150;
  private final float DEFAULT_CHARGE = 4E12;
  
  public SourceCharge(float charge, float x, float y){
    this.x = x;
    this.y = y;
    this.charge = charge;
  }
  
  public SourceCharge(float x, float y){
    this.x = x;
    this.y = y;
    this.charge = DEFAULT_CHARGE;
  }
  
  public void setPosition(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  public void display(){
    noStroke();
    colorMode(RGB, 255);
    fill(240, 110, 0, 170);
    ellipse(this.x, this.y, diameter, diameter);
  }
  
  public float getX() {
    return x;
  }
  
  public float getY() {
    return y;
  }
  
  public float getCharge() {
    return charge;
  }
  
  public float getDiameter() {
    return diameter;
  }
  
}
