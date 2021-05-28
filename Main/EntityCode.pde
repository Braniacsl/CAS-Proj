//This contains the generic entity code. It is responsible for having shared functions which all entities will use, such as basic calculations for position and dimensions as well as movement of entities.

abstract class Entity extends gridObject{ // The aforemention class
  private PVector pos = new PVector(); //The position of the entity and the getter and setter below
  
  public PVector getPos(){
    return this.pos;
  }
  
  //This is used to calculate position based on the position of the entity on the grid. This is chosen instead of stricly changing the pos because it is easier to do the calculations here rather than everytime we set position of an object.
  public void setPos(int[] toSet, int[] gridSize){
    float[] middleOfGrid = new float[] {(windowSize[0]/gridSize[0])/2, (windowSize[1]/gridSize[1])/2}; //This calculates where the middle of the grid will be based upon the size of the window as well as the 
    //dimensions of the entity
    
    //Multiplies the middle by the position the entity is in the grid to get the position of the middle of the grid the entity is in.
    float x = middleOfGrid[0]+((toSet[0])*(windowSize[0]/gridSize[0]));
    float y = middleOfGrid[1]+((toSet[1])*(windowSize[1]/gridSize[1]));
    
    this.pos.set(new PVector(x, y));
  }
  
  //This adds a distance to the position vector. This is usually used when adding the final velocity to the object.
  public void addPos(PVector v){
    this.pos.add(v);
  }
  
  private PVector dimensions = new PVector(); //width and height of an object, and the getter and setter
  
  public void setDimensions(PVector toSet){
    this.dimensions.set(toSet);
  }
  
  public PVector getDimensions(){
    return this.dimensions;
  }
  
  public PVector velocity = new PVector(0, 0);//The velocity of the entity
  private float vMax; //vMax is the maximum velocity the entity can move between squares. It reaches this halfway to its destination
  private float vRate; //vRate is the rate at which the entity accelerates to max and decelerates to 0
  
  private int[] gridSize; //the size of the grid of the level, this is taken from the level and is used for calculation as it would be ineffiecient to put it as a parameter in a function that is called frameRate times a second. It also is used for standardization
  //of code. It is easier to input it once than multiple times.

  public String direction; //The direction that the entity moves in, if moving.
  
  private boolean hitEdge; //This is used to check if an entity has hit an immovable wall, such as the edge of the screen or a wall object.
  
  private final float timeToNextSquare = 0.4f*frames; //This is used in calculations for velocity of the entity. The time that it takes is the constant shown, however we need to multiply by "frames" because the game is ran "frames" times per second
  
  //The constructor for the entity object. We take in position, gridSize and dimensions of the entity. The position here is the cell the player is in, not the actual position. That is later calculated using this parameter.
  public Entity(int[] pos, int[] gridSize, PVector dimensions){
    this.setDimensions(dimensions);
    this.currentCell = pos;
    this.gridSize = gridSize;
    this.setPos(this.currentCell, this.gridSize); //Sets the current player's real position from the cell the entity is in as well as the size of the grid in the level.
    this.calculateVelocity(); //Calculates the variables for movement, that being vMax and vRate. Pretty genius stuff.
  }
  
  public void calculateVelocity(){
    //the distance to the next cell
    float distance = windowSize[0]/gridSize[0];
    
    /*
      The idea behind these calculations are that there is some function f(x) = c, where c is a constant. However, there is also some function y=Math.abs(mx)+b. The thing that joins them together is that they are both velocity-time graphs, which means that their
      area should be position. This means that as long as area=distance(calculated above), we can find the properties of the second function. Given the area is the same, we divide the rectangle created by the first function in half, and we also split the 
      second function, a triangle, in half. This allows us to have a right triangle, where the lines vMax are the height, timeTaken/2 is the width, and the slope of the hypotenuse is vRate.
    */
    
    //In this first calculation we find vMax, by manipulating the equation A=(1/2)*width*height, distance/2=(1/2)*(timeTaken/2)*vMax => vMax = 2*(distance/2)/this.timeTaken.
    this.vMax = (2*distance)/this.timeToNextSquare;
    
    //Given that vRate is the slope of the hypotenuse, and that we have a right triangle, the rise and run would height and width of the triangle respectively. Therefore, vRate = vMax/(timeTaken/2).
    this.vRate = this.vMax/(this.timeToNextSquare/2);
  }
  
  public void moveTo() {
  
    //This switch basically does the same thing for each direction. What it does is it checks if the player is half way to the next cell if not, it adds velocity until it reaches a maximum, at which point it starts decreasing. It alo reverses the entity if
    //it hits an immovable wall.
    //Note: ternary operators are used just so that the value cant go over vMax
    float[] steps = new float[] {windowSize[0]/gridSize[0], windowSize[1]/gridSize[1]}; //This  calculates the distance between grid cells.
    switch(this.direction){
      case "down":
        if(this.getPos().y < (steps[1]*(this.currentCell[1]+1))-(steps[1])){ // This if checks if the entity is behind the halfway mark to its destination, and if so increases the velocity up to max.
          this.velocity.y = this.velocity.y + this.vRate < this.vMax ? this.velocity.y+this.vRate: this.vMax; //This line says that the velocity will increase down unless that increase would put it over the max. If it is, then it simply becomes the max.
          //this is done because vRate may not always be a multiple of vMax, which means that vRate may go over vMax, which would break things, and as such we need to set a hard limit.
          //P.S. It would break things because if velocity goes over vMax the else below may not set velocity to 0 and thus the object would keep moving, or it would decrease to 0 but not be in the middle but slightly to the side. This matters because this error
          //can add up.
        }
        else { //This if is entered once the entity is in the second half of movement, and thus decreases velocity to 0.
          if(!this.passable()){ //This second if-else is here to check if the player hits an immovable wall and if so reverses back
            //The way that the entity reverses is it changes its current direction. If the player had to enter this case even though it hit a wall, it would be more complicated than simply reversing the direction and setting the velocity to max since it is halway
            //It also resets the currentCell
            this.velocity.y = -this.vMax;
            this.currentCell[1]--;
            this.direction = "up";
          }
          else{ //This else is for when the entity is in the second half but hasnt hit an immovable wall
            this.velocity.y = this.velocity.y - this.vRate > 0 ? this.velocity.y-this.vRate: 0; //This does the same as the matching line above, except it decelerates the object.
            if(this.velocity.y == 0){ //This if checks when the player is done with movement and if so resets the variables used in movement.
              this.moving = false;
              this.direction = "";
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
            this.direction = "down";
          }
          else {
            this.velocity.y = this.velocity.y + this.vRate < 0 ? this.velocity.y+this.vRate: 0;
            if(this.velocity.y == 0){
              this.moving = false;
              this.direction = "";
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
            this.direction = "right";
          }
          else {
            this.velocity.x = this.velocity.x + this.vRate < 0 ? this.velocity.x+this.vRate: 0;
            if(this.velocity.x == 0){
              this.moving = false;
              this.direction = "";
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
            this.direction = "left";
          }
          else {
            this.velocity.x = this.velocity.x - this.vRate > 0 ? this.velocity.x-this.vRate: 0;
            if(this.velocity.x == 0){
              this.moving = false;
              this.direction = "";
            }
          }
        }
      break;
    }
  } 
  
  //This function checks if the cell the entity is trying to move to is actually passable instead of hitting an immovable object.
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
    
    //If the player isnt going off screen it checks to see if the player is moving into any other object that cant move, such as a wall and if so cant pass. It does this by iterating through all the objects in the scene and checking if theyre immovable as well
    //as if they have the same currentCell
    for(int i = 0; i < SceneManager.currentScene.Objects.size(); i++){
      gridObject obj = SceneManager.currentScene.Objects.get(i); //gets the current object
      if(obj.currentCell[0] == this.currentCell[0] && obj.currentCell[1] == this.currentCell[1] && obj.getClass().getSimpleName().equals("Wall")){ //Checks if the object has the same position and if its immovable
        this.hitEdge = true;
        return false;
      }
    }
    
    return true;
  }
 
}
