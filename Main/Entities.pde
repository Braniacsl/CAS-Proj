import java.util.*;

/*
This file contains all the entities in the game, including the player.
This means that there is also an entity constructor class, so that all 
entities will extend it. This will be useful to standardize collision
detection. 
*/

class Entity { // The aforemention constructor
  private PVector pos = new PVector(); //The position of the entity and the getter and setter below
  
  public void setPos(PVector toSet){
    this.pos.set(toSet);
  }
  public PVector getPos(){
    return this.pos;
  }
  
}

class Player extends Entity{ //The player class    
  private List<String> keysPressed = new ArrayList<String>();
  
  private PVector acceleration = new PVector(0,0);//An acceleration object is used to make the movement smoother. We don't want to have somthing spacey as in it takes a long time to accelerate. It is a short acceleration period up to max acceleration, simply to make
  //it smoother
  private float accRate = 5; //The rate at which an object accelerates at per frame. This means that if accRate = 0.5 it takes 10 frames to reach max speed.
  private float accLimit = 25;// THis is the limit of the acceleration in each direction
  private float accDecay = 3.33;//The rate at which the object naturally decelerates. Drag, friction etc. not actually calculated its static
  
  private PVector velocity = new PVector(0, 0);//The velocity of the player which affects position. This is just to make sure the player doesnt go too fast.
  private float vMax = 50f;//see accLimit except this is velocity
  private float vDecay = 15;//see acceleration decay except its velocity
  
  public Player(PVector pos){
    this.setPos(pos);
  }
  
  public void addKey(String k){
    keysPressed.add(k);
  }
  
  public void update(){
    //The next two lines take the last keypressed out of the list and then remove it.
    String k = "";
    k = keysPressed.isEmpty() ? "" : keysPressed.get(keysPressed.size()-1);
    if(k != "")
      keysPressed.remove(keysPressed.lastIndexOf(k));
    
    //This switch functions to identify the input key. The movement keys are made so that if the current acceleration and the added acceleration are less than the limit it works if not it just stays at the limit. This means that acceleration wont go past
    //the max acceleration
    switch(k){
      case "s":
        if(acceleration.y+accRate<this.accLimit)
          this.acceleration.add(0, accRate);
        else
          this.acceleration.y = accLimit;
        break;
      case "w":
        if(acceleration.y-accRate>-this.accLimit)
          this.acceleration.add(0, -accRate);
        else
          this.acceleration.y = -accLimit;
        break;
      case "a":
        if(acceleration.x+accRate<this.accLimit)
          this.acceleration.add(-accRate, 0);
        else
          this.acceleration.x = -accLimit;
        break;
      case "d":
        if(acceleration.x-accRate>-this.accLimit)
          this.acceleration.add(accRate, 0);
        else
          this.acceleration.x = accLimit;
        break;     
    }
    
    //The following if block is transferring the acceleration into velocity and making sure velocity isnt too high
    velocity.add(this.acceleration);
    if(this.velocity.x>this.vMax)
      this.velocity.x = this.vMax;
    else if(this.velocity.x<-this.vMax)
       this.velocity.x = -this.vMax;
    else if(this.velocity.y>this.vMax)
       this.velocity.y = this.vMax;
    else if(this.velocity.y<-this.vMax)
       this.velocity.y = -this.vMax;
    
    //Finally, we put velocity into position
    this.setPos(this.getPos().add(this.velocity));
    
   
    this.accelerationDecay();
    
    this.velocityDecay();
  }
  
  private void accelerationDecay(){
     //the block which handles natural deceleration
    if(this.acceleration.x>0){
      this.acceleration.x -= this.accDecay;
      this.acceleration.x = (this.acceleration.x >= 0) ? this.acceleration.x : 0;
    }
    else{
      this.acceleration.x += this.accDecay;
      this.acceleration.x = (this.acceleration.x <= 0) ? this.acceleration.x : 0;
    }
    if(this.acceleration.y>0){
      this.acceleration.y -= this.accDecay;
      this.acceleration.y = (this.acceleration.y >= 0) ? this.acceleration.y : 0;
    }
    else{
      this.acceleration.y += this.accDecay;
      this.acceleration.y = (this.acceleration.y <= 0) ? this.acceleration.y : 0;
    }
  }
  
  private void velocityDecay(){
     //the block which handles natural deceleration
    if(this.velocity.x>0){
      this.velocity.x -= this.vDecay;
      this.velocity.x = (this.velocity.x >= 0) ? this.velocity.x : 0;
    }
    else{
      this.velocity.x += this.vDecay;
      this.velocity.x = (this.velocity.x <= 0) ? this.velocity.x : 0;
    }
    if(this.velocity.y>0){
      this.velocity.y -= this.vDecay;
      this.velocity.y = (this.velocity.y >= 0) ? this.velocity.y : 0;
    }
    else{
      this.velocity.y += this.vDecay;
      this.velocity.y = (this.velocity.y <= 0) ? this.velocity.y : 0;
    }
  }
  
  public void render(){ // Stand-in for the actual render function since no player model is made.
    PVector tempPos = this.getPos();
    color(255);
    fill(255);
    circle(tempPos.x, tempPos.y, height/25); // the current radius is 50. A variable isnt created for this since its temp
  }
  
}
