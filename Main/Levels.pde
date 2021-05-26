/* 
This is the test scene for movement, entity behavior etc. It is used to test any new features.
*/


class Test extends Scene {
  int instance = 0;
  Player player;

  
  void setup(){
    gridSize[0] = gridSize[1] = 5;
    
    player = new Player(new int[] {0, 0}, gridSize);
    
    createGrid();
  }
  
  void draw(){
    background(0);
    
    stroke(255);
    
    //This simply renders the grid. Only for testing purposes
    for(int i = 1; i <= gridSize[0]; i++){
      float steps = windowSize[0]/gridSize[0];
      line(steps * i, 0, steps* i, windowSize[1]);
      line(0, steps * i, windowSize[0], steps*i);
    }
    
    player.update();
    
    player.render();
    
  } 
  
  void keyPressed(String key){
    this.player.addKey(key+"");
  }
  
  public Test(int instance){
    this.instance = instance;
  }  
}
