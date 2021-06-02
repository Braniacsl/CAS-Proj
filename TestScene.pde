/* 
This is the test scene for movement, entity behavior etc. It is used to test any new features.
*/


class Test extends Scene {
  
  void setup(){
    gridSize[0] = gridSize[1] = 6; //Sets the gridSize
    
    player = new Player(new int[] {0, 0}, gridSize); //instantiates the player
    
    createGrid(); //Creates the grid
    
    this.addObject(player);
    this.addObject(new Wall(new int[] {2, 0}, gridSize));
    //Objects.add(new Wall(new int[] {3, 1}, gridSize));
   // Objects.add(new Wall(new int[] {1, 2}, gridSize));
    this.addObject(new Block(new int[] {2, 2}, gridSize));
    this.addObject(new Block(new int[] {3, 2}, gridSize));
  }
  
  void draw(){
    background(0);
    
    stroke(255);
    //This renders the lines of the grid
    for(int i = 1; i < this.gridSize[0]; i++){
      float steps = windowSize[0]/gridSize[0];
      line(steps * i, 0, steps* i, windowSize[1]);
      line(0, steps * i, windowSize[0], steps*i);
    }
    
    this.updateGrid();
    
    this.renderGrid();
  } 
  
  void keyPressed(String key){
    //Sends key presses to the player
    String sKey = key+"";
    if(sKey != ""){
      this.dirInitialQueue.add(sKey);
    }  
  }
}
