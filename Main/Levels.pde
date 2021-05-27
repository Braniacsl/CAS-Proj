/* 
This is the test scene for movement, entity behavior etc. It is used to test any new features.
*/


class Test extends Scene {
  Player player;

  
  void setup(){
    gridSize[0] = gridSize[1] = 5; //Sets the gridSize
    
    player = new Player(new int[] {0, 0}, gridSize); //instantiates the player
    
    createGrid(); //Creates the grid
    
    this.grid[0][0] = player;
    this.grid[2][0] = "wall";
    this.grid[3][1] = "wall";
    this.grid[1][2] = "wall";
  }
  
  void draw(){
    background(0);
    
    stroke(255);
    
    //This render any 
    for(int i = 0; i < this.gridSize[0]; i++){
      float steps = windowSize[0]/gridSize[0];
      line(steps * i, 0, steps* i, windowSize[1]);
      line(0, steps * i, windowSize[0], steps*i);
      for(int j = 0; j < this.gridSize[1]; j++){
        if(this.grid[i][j] == "wall"){
          rect(i*steps, j*steps, steps, steps);
        }
      }
    }
    
    //Calling the draw and update functions of the player
    player.update();
    
    player.render();
    
  } 
  
  void keyPressed(String key){
    //Sends key presses to the player
    this.player.addKey(key+"");
  }  
}
