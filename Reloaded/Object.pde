//This class is for rendering the grid since there has to be one object when doing so

abstract class gridObject {
  public int[] currentCell;
  
  public boolean moving = false;
  
  public String direction = ""; //The direction that the entity moves in, if moving.
  
  public boolean hitEdge; //This is used to check if an entity has hit an immovable wall, such as the edge of the screen or a wall object.
  
  public int[] gridSize; //the size of the grid of the level, this is taken from the level and is used for calculation as it would be ineffiecient to put it as a parameter in a function that is called frameRate times a second. It also is used for standardization
  //of code. It is easier to input it once than multiple times.
  
  public boolean[] stationary;
  
  public abstract void update(boolean move);
  public abstract void render();
  
  public void updateCell(){
    if(this.direction == "up"){
      this.currentCell[1]--;
    }
    if(this.direction == "down"){
      this.currentCell[1]++;
    }
    if(this.direction == "left"){
      this.currentCell[0]--;
    }
    if(this.direction == "right"){
      this.currentCell[0]++;
    }
  }
  public void updateGridCell(boolean hasBefore){
    if(this.direction == "up"){
      if(!hasBefore)
        SceneManager.currentScene.grid[this.currentCell[0]][this.currentCell[1]+1] = null;
      SceneManager.currentScene.grid[this.currentCell[0]][this.currentCell[1]] = this;
    }
    if(this.direction == "down"){
      if(!hasBefore)
        SceneManager.currentScene.grid[this.currentCell[0]][this.currentCell[1]-1] = null;
      SceneManager.currentScene.grid[this.currentCell[0]][this.currentCell[1]] = this;
    }
    if(this.direction == "left"){
      if(!hasBefore)
        SceneManager.currentScene.grid[this.currentCell[0]+1][this.currentCell[1]] = null;
      SceneManager.currentScene.grid[this.currentCell[0]][this.currentCell[1]] = this;
    }
    if(this.direction == "right"){
      if(!hasBefore)
        SceneManager.currentScene.grid[this.currentCell[0]-1][this.currentCell[1]] = null;
      SceneManager.currentScene.grid[this.currentCell[0]][this.currentCell[1]] = this;
    }
    this.direction = "";
  }
}
