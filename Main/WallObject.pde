//This is the code for the wall. Comments arent added as the class is pretty straightforward as it has one set position and is simply a block restricting movement.

class Wall extends gridObject{
  PVector pos;
  PVector dimensions;
  
  public Wall(int[] gridPos, int[] gridSize){
    this.currentCell = gridPos;
    this.dimensions = new PVector(windowSize[0]/gridSize[0], windowSize[1]/gridSize[1]);
    this.pos = this.calculatePos(gridPos);
  }
  
  public void update(){
    return;
  }
  public void render(){
    fill(255);
    rect(this.pos.x, this.pos.y, this.dimensions.x, this.dimensions.y);
  }
  
  public PVector calculatePos(int[] gridPos){
    return new PVector(gridPos[0]*this.dimensions.x, gridPos[1]*this.dimensions.y);
  }
}
