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
  public float vMax; //vMax is the maximum velocity the entity can move between squares. It reaches this halfway to its destination
  private float vRate; //vRate is the rate at which the entity accelerates to max and decelerates to 0
  
  private final float timeToNextSquare = 0.3f*frames; //This is used in calculations for velocity of the entity. The time that it takes is the constant shown, however we need to multiply by "frames" because the game is ran "frames" times per second
  
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
        if(this.getPos().y < (steps[1]*(this.currentCell[1]))){ // This if checks if the entity is behind the halfway mark to its destination, and if so increases the velocity up to max.
          this.velocity.y = this.velocity.y + this.vRate < this.vMax ? this.velocity.y+this.vRate: this.vMax; //This line says that the velocity will increase down unless that increase would put it over the max. If it is, then it simply becomes the max.
          //this is done because vRate may not always be a multiple of vMax, which means that vRate may go over vMax, which would break things, and as such we need to set a hard limit.
          //P.S. It would break things because if velocity goes over vMax the else below may not set velocity to 0 and thus the object would keep moving, or it would decrease to 0 but not be in the middle but slightly to the side. This matters because this error
          //can add up.
        }
        else{ //This if is entered once the entity is in the second half of movement, and thus decreases velocity to 0.
          //This else is for when the entity is in the second half but hasnt hit an immovable wall
          this.velocity.y = this.velocity.y - this.vRate > 0 ? this.velocity.y-this.vRate: 0; //This does the same as the matching line above, except it decelerates the object.
          if(this.velocity.y == 0){ //This if checks when the player is done with movement and if so resets the variables used in movement.
            this.moving = false;
          }
        }
      break;
      //For the following cases refer to the comments above
      case "up":

        if(this.getPos().y > (steps[1]*(this.currentCell[1]+1))){
          this.velocity.y = this.velocity.y - this.vRate > -this.vMax ? this.velocity.y-this.vRate: -this.vMax;
        }
        else {
            this.velocity.y = this.velocity.y + this.vRate < 0 ? this.velocity.y+this.vRate: 0;
            if(this.velocity.y == 0){
              this.moving = false;
            }
        }
      break;
      case "left":
        if(this.getPos().x > (steps[0]*(this.currentCell[0]+1))){
          this.velocity.x = this.velocity.x - this.vRate > -this.vMax ? this.velocity.x-this.vRate: -this.vMax;
        }
        else {
            this.velocity.x = this.velocity.x + this.vRate < 0 ? this.velocity.x+this.vRate: 0;
            if(this.velocity.x == 0){
              this.moving = false;
            }
        }
      break;
      case "right":
        if(this.getPos().x < (steps[0]*(this.currentCell[0]+1))-(steps[0])){
          this.velocity.x = this.velocity.x + this.vRate < this.vMax ? this.velocity.x+this.vRate: this.vMax;
        }
        else {
            this.velocity.x = this.velocity.x - this.vRate > 0 ? this.velocity.x-this.vRate: 0;
            if(this.velocity.x == 0){
              this.moving = false;
            }
        }
      break;
    }
  } 
  public void halfMove() {
  
    //This switch basically does the same thing for each direction. What it does is it checks if the player is half way to the next cell if not, it adds velocity until it reaches a maximum, at which point it starts decreasing. It alo reverses the entity if
    //it hits an immovable wall.
    //Note: ternary operators are used just so that the value cant go over vMax
    float[] steps = new float[] {windowSize[0]/gridSize[0], windowSize[1]/gridSize[1]}; //This  calculates the distance between grid cells.
    float dist = (steps[0]) - (this.dimensions.x);
    switch(this.direction){
      case "down":
        if(this.getPos().y < ((steps[1]*(this.currentCell[1]+1)) - dist) - this.vRate && this.velocity.y >= 0){ // This if checks if the entity is behind the halfway mark to its destination, and if so increases the velocity up to max.
          this.velocity.y = this.velocity.y + this.vRate < this.vMax ? this.velocity.y+this.vRate: this.vMax; //This line says that the velocity will increase down unless that increase would put it over the max. If it is, then it simply becomes the max.
          //this is done because vRate may not always be a multiple of vMax, which means that vRate may go over vMax, which would break things, and as such we need to set a hard limit.
          //P.S. It would break things because if velocity goes over vMax the else below may not set velocity to 0 and thus the object would keep moving, or it would decrease to 0 but not be in the middle but slightly to the side. This matters because this error
          //can add up.
        }
        else{ //This if is entered once the entity is in the second half of movement, and thus decreases velocity to 0.
          //This else is for when the entity is in the second half but hasnt hit an immovable wall
          if(this.velocity.y > 0)
            this.velocity.y = -this.velocity.y;
          else
            this.velocity.y = this.velocity.y + this.vRate < 0 ? this.velocity.y+this.vRate: 0; //This does the same as the matching line above, except it decelerates the object.
          if(this.velocity.y == 0){ //This if checks when the player is done with movement and if so resets the variables used in movement.
            this.moving = false;
          }
        }
      break;
      //For the following cases refer to the comments above
      case "up":
        if(this.getPos().y > ((steps[1]*(this.currentCell[1])) + dist) + this.vRate && this.velocity.y <= 0){
          this.velocity.y = this.velocity.y - this.vRate > -this.vMax ? this.velocity.y-this.vRate: -this.vMax; 
        }
        else{
          if(this.velocity.y < 0){
            this.velocity.y = -this.velocity.y;
          }
          else
            this.velocity.y = this.velocity.y - this.vRate > 0 ? this.velocity.y-this.vRate: 0;
          if(this.velocity.y == 0){
            this.moving = false;
          }
        }
      break;
      case "left":
        if(this.getPos().x > ((steps[0]*(this.currentCell[0])) + dist) + this.vRate && this.velocity.x <= 0){
          this.velocity.x = this.velocity.x - this.vRate > -this.vMax ? this.velocity.x-this.vRate: -this.vMax; 
        }
        else{
          if(this.velocity.x < 0){
            this.velocity.x = -this.velocity.x;
          }
          else
            this.velocity.x = this.velocity.x - this.vRate > 0 ? this.velocity.x-this.vRate: 0;
          if(this.velocity.x == 0){
            this.moving = false;
          }
        }
      break;
      case "right":
        if(this.getPos().x < ((steps[0]*(this.currentCell[0]+1)) - dist) - this.vRate && this.velocity.x >= 0){
          this.velocity.x = this.velocity.x + this.vRate < this.vMax ? this.velocity.x+this.vRate: this.vMax;
        }
        else{
          if(this.velocity.x > 0)
            this.velocity.x = -this.velocity.x;
          else
            this.velocity.x = this.velocity.x + this.vRate < 0 ? this.velocity.x+this.vRate: 0;
          if(this.velocity.x == 0){
            this.moving = false;
          }
        }
      break;
    }
  } 
}
