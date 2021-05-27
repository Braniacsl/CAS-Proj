import java.util.List;
import java.lang.Math;

/*
This file contains the code for the player character. Before it was to contain all the code for the game, however the file would be too big and less readable
*/

class Player extends Entity{ //The player class    
  private List<String> keysPressed = new ArrayList<String>();
  
  public Player(int[] pos, int[] gridSize){
    super(pos, gridSize);
  }
  
  public void addKey(String k){
    keysPressed.add(k);
  }
  
  public void update(){
    //The next two lines take the last keypressed out of the list and then remove it. Also, it ensures that no new inputs can be made if the character still moving to a new cell.
    String k = "";
    if(!this.moving){
      k = keysPressed.isEmpty() ? "" : keysPressed.get(0);        
      if(k != ""){
        this.moving = true;
        keysPressed.clear();
      }
    }
    
    //The if block functions to identify the input key and the subsequent direction. The movement keys are made so that when a key is pressed the character will move towards the next cell. The current cell is recorded for calculations.
    if(k.equals("s")){
      this.currentCell[1] += 1;
      this.direction = "down";
    }
    else if(k.equals("w")){
      this.currentCell[1] -= 1;
      this.direction = "up";
    }
    else if(k.equals("a")){
      this.currentCell[0] -= 1;
      this.direction = "left";
    }
    else if(k.equals("d")){
      ++this.currentCell[0];
      this.direction = "right";
    }
    
    //This checks if the object is moving and, if so, makes the next moving calculation
    if(this.moving)
      this.moveTo();
    
    this.addPos(this.velocity); //Adds the velocity to position
  }      
  
  public void render(){ // Stand-in for the actual render function since no player model is made.
    PVector tempPos = this.getPos();
    color(255);
    fill(255);
    noStroke();
    circle(tempPos.x, tempPos.y, this.getDimensions().x/2);
  } 
}
