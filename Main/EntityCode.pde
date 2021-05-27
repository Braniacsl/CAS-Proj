//This contains the co

class Entity { // The aforemention constructor
  private PVector pos = new PVector(); //The position of the entity and the getter and setter below
  
  private PVector dimensions = new PVector(); //width and height of an object.
  
  public void setDimensions(PVector toSet){
    this.dimensions.set(toSet);
  }
  
  public PVector getDimensions(){
    return this.dimensions;
  }
  
  //This is used to set a position on the grid
  public void setPos(int[] toSet, int[] gridSize){
    float[] middleOfGrid = new float[] {(windowSize[0]/gridSize[0])/2, (windowSize[1]/gridSize[1])/2}; //This calculates where the middle of the grid will be based upon the size of the window as well as the 
    //dimensions of the entity
    
    //Multiplies the middle by the position the entity is in the grid to get the position of the middle of the grid the entity is in.
    float x = middleOfGrid[0]+((toSet[0])*(windowSize[0]/gridSize[0]));
    float y = middleOfGrid[1]+((toSet[1])*(windowSize[1]/gridSize[1]));
    
    this.pos.set(new PVector(x, y));
  }
  
  //This differs from setPos in that its not strictly for the grid
  public void addPos(PVector v){
    this.pos.add(v);
  }
  
  public PVector getPos(){
    return this.pos;
  }
 
}
