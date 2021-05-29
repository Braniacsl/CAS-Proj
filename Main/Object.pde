//This class is for rendering the grid since there has to be one object when doing so

abstract class gridObject {
  public int[] currentCell;
  
  public boolean moving = false;
  
  public String direction = "right"; //The direction that the entity moves in, if moving.
  
  public boolean hitEdge; //This is used to check if an entity has hit an immovable wall, such as the edge of the screen or a wall object.
  
  public int[] gridSize; //the size of the grid of the level, this is taken from the level and is used for calculation as it would be ineffiecient to put it as a parameter in a function that is called frameRate times a second. It also is used for standardization
  //of code. It is easier to input it once than multiple times.
  
  public abstract void update();
  public abstract void render();
  
   
  //This function checks if the cell the entity is trying to move to is actually passable instead of hitting an immovable object.
  public boolean passable(){
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
    
    //If the player isnt going off screen it checks to see if the player is moving into any other object that cant move, such as a wall and if so cant pass. It does this by iterating through all the objects in the scene and checking if theyre immovable as well
    //as if they have the same currentCell
    for(int i = 0; i < SceneManager.currentScene.Objects.size(); i++){
      gridObject obj = SceneManager.currentScene.Objects.get(i); //gets the current object
      boolean blockEdge = false;
      if(obj.getClass().getSimpleName().equals("Block") && !this.getClass().getSimpleName().equals("Block")){
        boolean movingEdge = obj.passable();
        if(!movingEdge){
          blockEdge = true;
        }
      }
      
      if(obj.currentCell[0] == this.currentCell[0] && obj.currentCell[1] == this.currentCell[1] && obj.getClass().getSimpleName().equals("Wall") || blockEdge){ //Checks if the object has the same position and if its immovable
        this.hitEdge = true;
        return false;
      }
    }
    
    return true;
  }
 
}
