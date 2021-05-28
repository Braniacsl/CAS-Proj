//The following is the code for the movable block. The block can be pushed by any entity, given that it can move in that direction. The block, unlike the entity cant be pushed into a wall. 

class Block extends Entity {
  
  int[] cellToMove; //This variable contains the cell the block should move to if it is ever pushed.
  
  public Block(int[] pos, int[] gridSize){
    super(pos, gridSize, new PVector(windowSize[0]/gridSize[0]*0.75, windowSize[1]/gridSize[1]*0.75)); //the block is 75% of the size of a cell
    this.cellToMove = this.currentCell;
  }
  
  public void update(){
    Player player = SceneManager.currentScene.player; //Gets the player for calculations
    
    if(this.currentCell[0] == player.currentCell[0] && this.currentCell[1] == player.currentCell[1]){ //Checks if the player is moving toward the block, and if so the block will initiate movement in that direction.
      if(player.direction == "down"){
        this.currentCell[1] += 1;
        this.direction = "down";
        this.moving = true;
      }
      else if(player.direction == "up"){
        this.currentCell[1] -= 1;
        this.direction = "up";
        this.moving = true;
      }
      else if(player.direction == "left"){
        this.currentCell[0] -= 1;
        this.direction = "left";
        this.moving = true;
      }
      else if(player.direction == "right"){
        ++this.currentCell[0];
        this.direction = "right";
        this.moving = true;
      }
    }
    
    //If moving the block moves towards the target cell.
    if(this.moving){
      this.moveTo();
    }
    
    this.addPos(this.velocity); //Adds the velocity to position
  }
  
  //temp render until there are assets
  public void render(){
    fill(255);
    PVector pos = this.getPos();
    PVector dimensions = this.getDimensions();
    rect(pos.x - (dimensions.x/2), pos.y - (dimensions.y/2), dimensions.x, dimensions.y);
  }
}
