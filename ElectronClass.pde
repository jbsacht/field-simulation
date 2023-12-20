import java.util.List;
public class TestCharge {
  private float diameter = height/30;

  private boolean sucked = false;

  private float x;
  private float y;

  private float dx; //xvelocity
  private float dy; //yvelocity
  
  //private float hue = random(0, 400); use for random colors
  private float transparency = 120;
  private final Color topRight = new Color(255, 0, 0);
  private final Color topLeft = new Color(0, 255, 0);
  private final Color bottomRight = new Color(0, 0, 255);
  private final Color bottomLeft = new Color(255, 255, 0);
  private Color displayColor;
  
  private final PVector X_HAT = new PVector(1, 0); //x unit vector
  private float e; //charge of electron
  private static final float m = 1.67E-27; //mass of electron
  private static final float k = 8.987E9; //coulomb's constant
  
  public TestCharge(float x, float y, float e) {
    this.x=x; 
    this.y=y; 
    this.e=e;
    displayColor = interpolateColor(topLeft, topRight, bottomLeft, bottomRight);
  }
  public TestCharge(float x, float y) {
    this(x, y, -1.6E-19);
  }

  //displays test charge
  public void display() {
    if (vaccumModeEnabled && sucked) {
      if (transparency>0) {
        transparency -= 5; 
      }
      if(diameter>0){
        diameter -= 0.5;
      }
    }
    noStroke();
    
    colorMode(RGB, 255);
    fill(displayColor.getRed(), displayColor.getGreen(), displayColor.getBlue(), transparency);
    //colorMode(HSB, 400);
    //fill(hue, 400, 400, transparency);
    ellipse(x, y, diameter, diameter);
  }
  
  //updates the position of the source charge
  public void updatePosition(List<SourceCharge> charges) {
    updateVelocity(charges);
    x += dx*3E-5;
    y += dy*3E-5;
  }

  //makes a line pointing in the direction of the net force on a test charge
  public void makeLine(List<SourceCharge> charges) {
    float minLength = 20;
    stroke(0, 0, 255, transparency);
    strokeWeight(2);
    
    final float xAcceleration = acceleration(charges).x/1E24;
    final float yAcceleration = acceleration(charges).y/1E24;
    float accelerationLineX = xAcceleration;// >= 0 ? min(minLength, xAcceleration) : max(-minLength, xAcceleration);
    float accelerationLineY = yAcceleration;// >= 0 ? min(minLength, yAcceleration) : max(-minLength, yAcceleration);
    while(abs(accelerationLineX) >= minLength || abs(accelerationLineY) >= minLength) {
      accelerationLineX *= .9;
      accelerationLineY *= .9;
    }
    line(x, y, x + accelerationLineX, y + accelerationLineY);
    
    stroke(255, 0, 0, transparency);
    float velocityRatio = 500;
    
    float velocityLineX = dx/velocityRatio;// >= 0 ? min(minLength, dx/velocityRatio) : max(-minLength, dx/velocityRatio);
    float velocityLineY = dy/velocityRatio;// >= 0 ? min(minLength, dy/velocityRatio) : max(-minLength, dy/velocityRatio);
    while(abs(velocityLineX) >= minLength || abs(velocityLineY) >= minLength) {
      velocityLineX *= 0.99;
      velocityLineY *= 0.99;
    }
    line(x, y, x + velocityLineX, y + velocityLineY);
  }

  public void checkSucked(List<SourceCharge> charges) {
    for (int i=0; i<charges.size(); i++) {
      if (dist(x, y, charges.get(i).x, charges.get(i).y)<(diameter+charges.get(i).diameter)/2-diameter) {
        sucked=true;
      }
    }
  }
  
  public float getDiameter() {
    return diameter;
  }
  
  //creates a distance vector pointing from the source to test charge
  private PVector distance(SourceCharge other) {
    PVector dist = new PVector(x-other.x, y-other.y);
    return dist;
  }
  
  //creates a float of the magnitude of the electric field
  private float emag(SourceCharge other) {
    float Emag; 
    //if point charge, Emag = k*other.q/(distance(other).mag()*distance(other).mag());


    //if conducting sphere
    if (dist(x, y, other.getX(), other.getY())>=(diameter+other.getDiameter())/2) {
      //outside sphere
      Emag = k*other.getCharge()/(distance(other).mag()*distance(other).mag());
    } else {
      //inside sphere
      Emag = k * other.getCharge() * dist(x, y, other.getX(), other.getY()) / 
          (other.getDiameter()*other.getDiameter()*other.getDiameter());
    }
    return Emag;
  }

  //creates a float of the angle of the distance vector and the x-axis
  private float angle(SourceCharge other) {
    return PVector.angleBetween(distance(other), X_HAT);
  }

  //creates a vector of the electric field with one source charge
  private PVector field(SourceCharge other) {
    PVector force = new PVector();
    if (y>=other.y) {
      force.set(emag(other)*cos(angle(other)), emag(other)*sin(angle(other)));
    } else {
      force.set(emag(other)*cos(angle(other)), -emag(other)*sin(angle(other)));
    }
    return force;
  }

  //creates a vector of the electric field on the test charge from all source charges
  private PVector field(List<SourceCharge> charges) {
    PVector totalForce = new PVector(0, 0);
    for(SourceCharge charge : charges) {
      totalForce.add(field(charge));
    }
    return totalForce;
  }

  //creates a vector of the force on the test charge due to all source charges
  //N/pixel
  private PVector forceField(List<SourceCharge> charges) {
    PVector f = new PVector();
    f.set(this.field(charges).x*e, this.field(charges).y*e);
    return f;
  }

  //creates a vector of the acceleration of the test charge due to all source charges
  //pixels/s^2
  private PVector acceleration(List<SourceCharge> charges) {
    PVector a = new PVector();
    a.x = forceField(charges).x/m;
    a.y = forceField(charges).y/m;
    return a;
  }

  //updates the velocity of the test charge
  private void updateVelocity(List<SourceCharge> charges) {
    dx += acceleration(charges).x*1E-24;
    dy += acceleration(charges).y*1E-24;
  }
  
  private Color interpolateColor(Color topLeft, Color topRight, Color bottomLeft, Color bottomRight) {
    
      float normalizedX = x / width;
      double normalizedY = y / height;

      double w1 = (1 - normalizedX) * (1 - normalizedY);
      double w2 = normalizedX * (1 - normalizedY);
      double w3 = (1 - normalizedX) * normalizedY;
      double w4 = normalizedX * normalizedY;
      
      int red = (int) (w1 * topLeft.getRed() + w2 * topRight.getRed() + w3 * bottomLeft.getRed() + w4 * bottomRight.getRed());
      int green = (int) (w1 * topLeft.getGreen() + w2 * topRight.getGreen() + w3 * bottomLeft.getGreen() + w4 * bottomRight.getGreen());
      int blue = (int) (w1 * topLeft.getBlue() + w2 * topRight.getBlue() + w3 * bottomLeft.getBlue() + w4 * bottomRight.getBlue());

      return new Color(red, green, blue);
  }
}

public class Color {
  private float r;
  private float g;
  private float b;
  
  public Color(float r, float g, float b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }
  
  public float getRed() {
    return r;
  }
  public float getGreen() {
    return g;
  }
  public float getBlue() {
    return b;
  }
  public color getColor() {
    colorMode(RGB, 255);
    return color(r, g, b);
  }
}
