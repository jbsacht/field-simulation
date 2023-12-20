public class Button {
  private float buttonX;
  private float buttonY;
  private float buttonWidth;
  private float buttonHeight;
  private String message;
  private ButtonPushHandler pushHandler;
  private boolean activated = false;
  private boolean activatable;
  private boolean isHovered = false;
  
  public Button(String message, float x, float y, float buttonWidth, float buttonHeight, boolean activatable, ButtonPushHandler pushHandler) {
    this.message = message;
    this.buttonX = x;
    this.buttonY = y;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
    this.pushHandler = pushHandler;
    this.activatable = activatable;
  }
  
  public Button(String message, float x, float y, float buttonWidth, float buttonHeight, ButtonPushHandler pushHandler) {
    this(message, x, y, buttonWidth, buttonHeight, false, pushHandler);
  }
  
  public float getX() {
    return buttonX;
  }
  public float getY() {
    return buttonY;
  }
  public float getWidth() {
    return buttonWidth;
  }
  public float getHeight() {
    return buttonHeight;
  }
  
  public boolean isHovered() {
    return mouseX > buttonX - buttonWidth/2 && mouseX < buttonX + buttonWidth/2
      && mouseY > buttonY - buttonHeight/2 && mouseY < buttonY + buttonHeight/2;
  }
  
  public void activate() {
    if(activatable) {
      activated = !activated;
    }
  }
  
  public void display() {
    rectMode(CENTER);
    if(!activated && !isHovered){
      fill(230);
    }
    else {
      fill(75, 156, 211);
    }
    stroke(0);
    rect(buttonX, buttonY, buttonWidth, buttonHeight);
    textAlign(CENTER);
    textSize(50);
    fill(0);
    text(message, buttonX, buttonY + 13);
  }
  
  public void push() {
    if(pushHandler != null) {
      pushHandler.handlePush();
    }
  }
  public void hover() {
    isHovered = isHovered();
  }
}

public interface ButtonPushHandler {
    void handlePush();
}
