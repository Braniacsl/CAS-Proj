import java.util.List;
import java.lang.Math;

/*
This file contains the code for the player character. Before it was to contain all the code for the entities in the game, however the file would be too big and less readable
*/

class Player extends Entity{ //The player class    
  
  //The constructor for the player
  public Player(int[] pos, int[] gridSize){
    super(pos, gridSize, new PVector(100, 100));
    this.stationary = new boolean[] {false, false, false, false};;
  }
  
  //THis function updates the characters position based on player input
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
  
  public void render(){ // Stand-in for the actual render function since no player model is made.
    PVector tempPos = this.getPos();
    color(255);
    fill(255);
    noStroke();
    circle(tempPos.x, tempPos.y, this.getDimensions().x/2);
  } 
}
