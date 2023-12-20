import java.util.List;
import java.util.Iterator;
public static final String MENU_STRING = "menu";
public static final String PLAY_STRING = "play";
public static final String TITLE_STRING = "title";
public static final String PLACE_CHARGES_STRING = "place charges";
//public float t = Float.MIN_VALUE;

public static List<SourceCharge> sourceCharges = new ArrayList<SourceCharge>();
public static List<TestCharge> electrons = new ArrayList<TestCharge>();
public static List<Coordinate> spawnCoordinates = new ArrayList<Coordinate>();
public static List<Button> menuButtons = new ArrayList<Button>();
public static List<Button> titleButtons = new ArrayList<Button>();
public static Button playBackButton;
public static int nextSpawnIndex = 0;

public final Color backgroundColor = new Color(200, 200, 200);
public boolean playing = true;
public boolean vaccumModeEnabled = false;
public boolean regenerationEnabled = false;
public boolean showLines = false;
public String scene = TITLE_STRING;
public boolean wasHovering = false;
public static int rowSize = 20 - 2; //2 get added
public static int columnSize = 20 - 2; //2 get added

void setup(){
  //size(1000 , 1000, P2D); //Uncomment for not fullscreen
  fullScreen(P2D); //Uncomment for fullscreen
  frameRate(120);
  
  createButtons();
}

void draw(){
  if(scene.equals(TITLE_STRING)) {
    background(backgroundColor.getColor());
    textSize(75);
    textAlign(CENTER);
    
    fill(0);
    text("Field Simulation", width/2, height/4);
    text("by Joseph Sachtleben", width/2, height/3);
    boolean isHovered = false;
    for(Button button : titleButtons) {
      button.display();
      button.hover();
      if(button.isHovered()) {
        isHovered = true;
      }
    }
    if(isHovered && !wasHovering) {
      cursor(HAND);
      wasHovering = true;
    }
    else if(!isHovered && wasHovering){
      cursor(ARROW);
      wasHovering = false;
    }
  }
  else if(scene.equals(MENU_STRING)) {
    background(backgroundColor.getColor());
    textSize(50); 
    textAlign(CENTER);
    text("Launch Settings:", width/2, height/8);
    text("Charges Per Row: " + (rowSize + 2), width/2, height*11/16 + 10);
    boolean isHovered = false;
    for(Button button : menuButtons) {
      button.display();
      button.hover();
      if(button.isHovered()) {
        isHovered = true;
      }
    }
    if(isHovered && !wasHovering) {
      cursor(HAND);
      wasHovering = true;
    }
    else if(!isHovered && wasHovering){
      cursor(ARROW);
      wasHovering = false;
    }
  }
  else if(scene.equals(PLACE_CHARGES_STRING)) {
    background(backgroundColor.getColor());
    if(!wasHovering) {
      cursor(HAND);
      wasHovering = true;
    }
    textSize(50);
    textAlign(CENTER);
    fill(0);
    text("Click to place charges, press any key to start", width/3, height/10);
    
    for(SourceCharge charge : sourceCharges) {
      charge.display();
    }
  }
  else if(scene.equals(PLAY_STRING) && playing){
    background(backgroundColor.getColor());
    playBackButton.display();
    playBackButton.hover();
    if(!wasHovering) {
      cursor(HAND);
      wasHovering = true;
    }
    for(SourceCharge charge : sourceCharges) {
      charge.display();
    }
    //t += 0.001; this code allows parameterized movement of Source Charges
    //sourceCharges.get(0).setPosition(width/2 + width/4 * cos(t), height/2 + height/4 * sin(t)); 
    
    Iterator<TestCharge> iterator = electrons.iterator();
    List<TestCharge> newElectronList = new ArrayList<TestCharge>();
    while (iterator.hasNext()) {
      TestCharge electron = iterator.next();
      electron.display();
      electron.updatePosition(sourceCharges);  
      electron.checkSucked(sourceCharges);
      if(showLines) {
        electron.makeLine(sourceCharges);
      }
      if(!(electron.getDiameter() < 1)){
        newElectronList.add(electron);
      }
      else if(regenerationEnabled){
        nextSpawnIndex = (nextSpawnIndex + 1) % spawnCoordinates.size();
        if(nextSpawnIndex  == 0) {
          for(int i=0; i<spawnCoordinates.size(); i++) {
            Coordinate spawnCoordinate = spawnCoordinates.get(i);
            newElectronList.add(new TestCharge(spawnCoordinate.getX(), spawnCoordinate.getY()));
          }
        }
      }
     }
     electrons = newElectronList;
  }
}
void mousePressed(){
  if(scene.equals(TITLE_STRING)) {
    for(Button button : titleButtons) {
      if(button.isHovered()) {
        button.push();
        button.activate();
      }
    }
  }
  else if(scene.equals(MENU_STRING)) {
    for(Button button : menuButtons) {
      if(button.isHovered()) {
        button.push();
        button.activate();
      }
    }
  }
  else if(scene.equals(PLACE_CHARGES_STRING)) {
    sourceCharges.add(new SourceCharge(mouseX, mouseY));
  }
  else if(scene.equals(PLAY_STRING)) {
    if(playBackButton.isHovered()) {
      playBackButton.push();
    }
    else if(playing){playing = false;}
    else{playing = true;}
  }
}

void keyPressed() {
  if(scene.equals(PLACE_CHARGES_STRING)) {
    if(sourceCharges.size() == 0) {
      setupDefaultSourceCharges();
    }
    scene = PLAY_STRING;
  }
}

public class Coordinate {
  private float x;
  private float y;
  public Coordinate(float x, float y) {
    this.x = x;
    this.y = y;
  }
  public float getX() {
    return x;
  }
  public float getY() {
    return y;
  }
}

void setupTestCharges () {
  for(int i=-width/rowSize; i<=width + width/rowSize; i+=width/rowSize){
     for(int j=-height/columnSize; j<=height + height/columnSize; j+=height/columnSize){
       if(i < 0 || j < 0 || i > width || j > height) {
         spawnCoordinates.add(new Coordinate(i, j));
       }
       else {
          electrons.add(new TestCharge(i, j));
       }
     }
  }
}
void setupDefaultSourceCharges () {
  sourceCharges.add(new SourceCharge(width/3, height/2));
  sourceCharges.add(new SourceCharge(2*width/3, height/2));
}

void createButtons() {
  menuButtons.add(new Button("Vaccum Mode?", width/2, height*2/8, 600, 100, true, () -> {
    vaccumModeEnabled = !vaccumModeEnabled;
  }));
  menuButtons.add(new Button("Regeneration?", width/2, height*3/8, 600, 100, true, () -> {
    regenerationEnabled = !regenerationEnabled;
  }));
  menuButtons.add(new Button("Velocity/Acceleration Lines?", width/2, height*4/8, 600, 100, true, () -> {
    showLines = !showLines;
  }));
  menuButtons.add(new Button("Increase", width/2, height*10/16, 400, 60, () -> {
    rowSize++;
    columnSize++;
  }));
  menuButtons.add(new Button("Decrease", width/2, height*12/16, 400, 60, () -> {
    if(rowSize >= 2) {
      rowSize--;
      columnSize--;
    }
  }));
  menuButtons.add(new Button("Start!", width/3, height*7/8, 200, 100, () -> {
    setupTestCharges();
    setupDefaultSourceCharges();
    scene = PLAY_STRING;
  }));
  menuButtons.add(new Button("Place Custom Charges", width*3/5, height*7/8, 500, 100, () -> {
    setupTestCharges();
    scene = PLACE_CHARGES_STRING;
  }));
  menuButtons.add(new Button("Back to Title", width*8/9, height/10, 350, 60, () -> {
    scene = TITLE_STRING;
  }));
  titleButtons.add(new Button("Start!", width/2, height*4/8, 600, 100, () -> {
    setupTestCharges();
    setupDefaultSourceCharges();
    scene = PLAY_STRING;
  }));
    titleButtons.add(new Button("Startup Settings", width/2, height*6/8, 600, 100, () -> {
    scene = MENU_STRING;
  }));
  playBackButton = new Button("Settings", width*8/9, height/10, 300, 60, true, () -> {
    sourceCharges.clear();
    electrons.clear();
    scene = MENU_STRING;
  });
}
