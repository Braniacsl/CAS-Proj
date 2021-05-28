import java.util.List;
import java.lang.Math;

/*
This file contains the code for the player character. Before it was to contain all the code for the entities in the game, however the file would be too big and less readable
*/

class Player extends Entity{ //The player class    
  private List<String> keysPressed = new ArrayList<String>(); //The list of keypresses inputted by the player
  
  //The constructor for the player
  public Player(int[] pos, int[] gridSize){
    super(pos, gridSize, new PVector(100, 100));
  }
  
  //adds a key to the list
  public void addKey(String k){
    keysPressed.add(k);
  }
  
  //THis function updates the characters position based on player input
  public void update(){
    //This block is used to get the key pressed. First it checks if the player is stationary so it can move, then gets the key. If they key isnt null the character moves and the list is cleared.
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
