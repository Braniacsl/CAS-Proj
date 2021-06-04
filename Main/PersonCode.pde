//The following is the code for the movable block. The block can be pushed by any entity, given that it can move in that direction. The block, unlike the entity cant be pushed into a wall. 

class Person extends Entity {
  
  int[] cellToMove; //This variable contains the cell the block should move to if it is ever pushed.
  
  public Person(int[] pos, int[] gridSize){
    super(pos, gridSize, new PVector(windowSize[0]/gridSize[0]*0.5, windowSize[1]/gridSize[1]*0.5)); //the block is 75% of the size of a cell
    this.cellToMove = this.currentCell;
    this.stationary = new boolean[] {false, false, false, false};
  }
  
  public void update(boolean move){
    if(move){
      this.moveTo();
      this.addPos(this.velocity);
    }
    else{
      this.halfMove();
      this.addPos(this.velocity);
    }
  }
  
  //temp render until there are assets
  public void render(){
    noStroke();
    fill(255);
    PVector pos = this.getPos();
    PVector dimensions = this.getDimensions();
    float factor = dimensions.x/2;
    PVector p1 = new PVector(pos.x-factor, pos.y+factor);
    PVector p2 = new PVector(pos.x+dimensions.x-factor, pos.y+factor);
    PVector p3 = new PVector(pos.x+(dimensions.x/2-factor), pos.y-dimensions.y+factor);
    triangle(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y);
  }
}
