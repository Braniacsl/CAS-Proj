import java.util.List;
import java.lang.Math;

/*
This file contains the code for the player character. Before it was to contain all the code for the game, however the file would be too big and less readable
*/

class Player extends Entity{ //The player class    
  private List<String> keysPressed = new ArrayList<String>();
  
  private final float timeToNextSquare = 0.4f*frames; //I want to the ball to take 0.7 seconds to reach the next square, however since calculations are done frameRate times per second we multiply by the frameRate
  
  private PVector velocity = new PVector(0, 0);//The velocity of the player
  private float vMax; //vMax is the maximum velocity the player can move
  private float vRate; //vRate is the rate at which the player accelerates
  
  private int[] currentCell; //The current cell the player is in
  private int[] gridSize; //the size of the grid of the level, this is taken from the level and is used for calculation as it would be ineffiecient to put it as a parameter in a function that is called frameRate times a second.
  
  private boolean moving = false; //This is the checker to see if the player is moving
  private String direction; //The direction that the player moves in, if moving
  
  private boolean hitEdge = false;
  
  public Player(int[] pos, int[] gridSize){
    this.setDimensions(new PVector(100, 100)); //Sets the dimensions of the player. Its a rectangle so not the actual outline.
    this.currentCell = pos;
    this.gridSize = gridSize;
    this.setPos(this.currentCell, this.gridSize); //Sets the current player's position
    this.calculateVelocity(); //Calculates the variables for movement, that being vMax and vRate. Pretty genius stuff.
  }
  
  public void addKey(String k){
    keysPressed.add(k);
  }
  
  private void calculateVelocity(){
    //the distance to the next cell
    float distance = windowSize[0]/gridSize[0];
    
    //to calculate maximum velocity we consider a right triangle where the lines vmax and timeToNextSquare converge on the right angle. Given that the area is distance we manipulate the equation distance/2 = 1/2*vmax*(time/2), resulting in the below
    this.vMax = (2*distance)/this.timeToNextSquare;
    
    //vRate is the slope of the right triangle's hypotenuse, which means that vRate will be vMax/(time/2)
    this.vRate = vMax/(this.timeToNextSquare/2);
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
  
  private boolean passable(){
    //This block checks if the player is trying to move off screen
    if(this.direction == "down" && this.currentCell[1] == this.gridSize[1]){
      this.hitEdge = true;
      return false;
    }
    else if(this.direction == "up" && this.currentCell[1] == -1){
      this.hitEdge = true;
      return false;
    }
    else if(this.direction == "left" && this.currentCell[0] == -1){
      this.hitEdge = true;
      return false;
    }
    else if(this.direction == "right" && this.currentCell[0] == this.gridSize[0]){
      this.hitEdge = true;
      return false;
    }
    
    //If the player isnt going off screen it checks to see if the player is moving into any other object and if so cant pass
    Object obj = SceneManager.currentScene.grid[this.currentCell[0]][this.currentCell[1]];
    if(obj != null){
      this.hitEdge = true;
      return false;
    }
    
    return true;
  }
    
  
  public void moveTo() {
    
    //This switch basically does the same thing for each direction. What it does is it checks if the player is half way to the next cell if not, it adds velocity until it reaches a maximum, at which point it starts decreasing. 
    //Note: ternary operators are used just so that the value cant go over vMax
    float[] steps = new float[] {windowSize[0]/gridSize[0], windowSize[1]/gridSize[1]};
    switch(this.direction){
      case "down":
        if(this.getPos().y < (steps[1]*(this.currentCell[1]+1))-(steps[1])){ // This if checks if the player is behind the halfway mark to its destination
          this.velocity.y = this.velocity.y + this.vRate < this.vMax ? this.velocity.y+this.vRate: this.vMax; //This line says that the velocity will increase down unless that increase would put it over the max. If it is, then it simply becomes the max.
          //this is done because vRate may not always be a multiple of vMax, which means that vRate may go over vMax, which would break things.
        }
        else {
          if(!this.passable()){ //This second if is here to check if the player hits the wall and if so reverses back
            this.velocity.y = -this.vMax;
            this.currentCell[1]--;
            SceneManager.setGridSpace(this.currentCell, null);//This sets the grid space that the player is moving back to to null. This is because the cell we are moving back to still contains the player according to the grid, and because of this passable thinks
            //there is still an object there
            this.direction = "up";
          }
          else{
            this.velocity.y = this.velocity.y - this.vRate > 0 ? this.velocity.y-this.vRate: 0; //This does the same as the line above, except it decelerates the object.
            if(this.velocity.y == 0){ //This if checks when the player is done with movement and if so resets the variables.
              this.moving = false;
              this.direction = "";
              //This changes the current scenes grid to match the current grid positions if the player isnt coming back from colliding against something. This is needed for other calculations. The two lines basically set the last cell to null and the current cell 
              //to the player.
              if(!this.hitEdge){
                SceneManager.setGridSpace(new int[] {this.currentCell[0], this.currentCell[1]-1}, null);
                SceneManager.setGridSpace(this.currentCell, this);
              }
              this.hitEdge = false;
            }
          }
        }
      break;
      //For the following cases refer to the comments above
      case "up":
        if(this.getPos().y > (steps[1]*(this.currentCell[1]+1))){
          this.velocity.y = this.velocity.y - this.vRate > -this.vMax ? this.velocity.y-this.vRate: -this.vMax;
        }
        else {
          if(!this.passable()){
            this.velocity.y = this.vMax;
            this.currentCell[1]++;
            SceneManager.setGridSpace(this.currentCell, null);
            this.direction = "down";
          }
          else {
            this.velocity.y = this.velocity.y + this.vRate < 0 ? this.velocity.y+this.vRate: 0;
            if(this.velocity.y == 0){
              this.moving = false;
              this.direction = "";
              if(!this.hitEdge){
                SceneManager.setGridSpace(new int[] {this.currentCell[0], this.currentCell[1]+1}, null);
                SceneManager.setGridSpace(this.currentCell, this);
              }
              this.hitEdge = false;
            }
          } 
        }
      break;
      case "left":
        if(this.getPos().x > (steps[0]*(this.currentCell[0]+1))){
          this.velocity.x = this.velocity.x - this.vRate > -this.vMax ? this.velocity.x-this.vRate: -this.vMax;
        }
        else {
          if(!this.passable()){
            this.velocity.x = this.vMax;
            this.currentCell[0]++;
            SceneManager.setGridSpace(this.currentCell, null);
            this.direction = "right";
          }
          else {
            this.velocity.x = this.velocity.x + this.vRate < 0 ? this.velocity.x+this.vRate: 0;
            if(this.velocity.x == 0){
              this.moving = false;
              this.direction = "";
              if(!this.hitEdge){
                SceneManager.setGridSpace(new int[] {this.currentCell[0]+1, this.currentCell[1]}, null);
                SceneManager.setGridSpace(this.currentCell, this);
              }
              this.hitEdge = false;
            }
          }
        }
      break;
      case "right":
        if(this.getPos().x < (steps[0]*(this.currentCell[0]+1))-(steps[0])){
          this.velocity.x = this.velocity.x + this.vRate < this.vMax ? this.velocity.x+this.vRate: this.vMax;
        }
        else {
          if(!this.passable()){
            this.velocity.x = -this.vMax;
            this.currentCell[0]--;
            SceneManager.setGridSpace(this.currentCell, null);
            this.direction = "left";
          }
          else {
            this.velocity.x = this.velocity.x - this.vRate > 0 ? this.velocity.x-this.vRate: 0;
            if(this.velocity.x == 0){
              this.moving = false;
              this.direction = "";
              if(!this.hitEdge){
                SceneManager.setGridSpace(new int[] {this.currentCell[0]-1, this.currentCell[1]}, null);
                SceneManager.setGridSpace(this.currentCell, this);
              }
              this.hitEdge = false;
            }
          }
        }
      break;
    }
  }  
  
  public void render(){ // Stand-in for the actual render function since no player model is made.
    PVector tempPos = this.getPos();
    color(255);
    fill(255);
    noStroke();
    circle(tempPos.x, tempPos.y, this.getDimensions().x/2);
  } 
}
