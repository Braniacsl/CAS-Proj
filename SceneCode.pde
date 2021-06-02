//The purpose here is to define the scene manager which, as the name implies, will handle the switching, ordering and storing of scenes.
//The scene class is defined here as an abstract class for all the different scenes, as they will have these functions or variables

static class SceneManager {
  //The variable and functions below are the basic funcionality. This allows us to think of levels as their own individual sketches(what processing calls programs)
  private static Scene currentScene;
  
  private static Scene[] scenes = new Scene[5];//Stores the scenes
  
  private static int counter = 0;//counter for the number of scenes in the scene array
  
  //adds a scene to the end of the array, not at an index
  public static void addScene(Scene sc){
    scenes[counter] = sc;
    counter += 1;
  }
  
  //Retrieves a scene at an index
  public static Scene getScene(int index){
    return scenes[index];
  }
  
  //Sets the currentScene through an index and runs setup on it
  public static void setCurrentScene(int index){
    currentScene = SceneManager.getScene(index);
    currentScene.setup();
  }
  
  //Sends the draw and keyPressed functions to the currentScene
  public static void draw(){
    currentScene.draw();
  }
  
  public static void keyPressed(String key){
    currentScene.keyPressed(key);
  }  
}

//The scene class is abstract as every level or menu will be using it and thus it is easier to have an object scene instead of multiple different classes. Basically, it allows me to have an array of scenes as well as a currentscene variable without hassle.
abstract class Scene {
  //These grid variables are going to be in every scene. Also, im not defining the size of the grid because it can change from level to level to increase difficulty. The object list contains all the objects in the currentScene as calculations are done based on
  //object not the grid. The grid is mainly here for saving the gameState as well as loading a level easily, however some minor calculations take the grid state into account.
  public int[] gridSize = new int[2];
  public gridObject[][] grid;
  
  public Player player;
  
  public Exit exit;
  
  public LimitedQueue<String> dirInitialQueue = new LimitedQueue<String>(2);
  public String dirInitial = "";
  
  public List<gridObject> chain = null;
  public boolean chainMove = false;
  
  //This creates the grid. It uses the gridSize to construct a gridObject[][] and sets each value to null.
  public void createGrid(){
    grid = new gridObject[gridSize[0]][gridSize[1]];
    this.nullifyGrid();
  }
  
  //Wipes the grid, setting each cell to null
  public void nullifyGrid(){
    for(int i = 0; i < this.gridSize[0]; i++){
      for(int j = 0; j < this.gridSize[1]; j++){
        this.grid[i][j] = null;
      }
    }
  }
  
  public void addObject(gridObject obj){
    this.grid[obj.currentCell[0]][obj.currentCell[1]] = obj;
  }
  
  public void updateGrid(){
    if(this.dirInitialQueue.size() != 0 && this.chain == null && this.checkMovement()){
      this.dirInitial = this.letterToDir(this.dirInitialQueue.poll());
      this.chain = this.createChain(this.player.currentCell, dirInitial);
      this.chainMove = this.canChainMove(chain);
      if(this.chainMove)
        this.assignDir(dirInitial, true); 
      else
        this.assignDir(dirInitial, false);
      this.dirInitial = "";
    }
      
    if(this.chain != null){
      for(int i = 0; i < this.chain.size(); i++){
        if(this.chain.get(i).moving){
          if(this.chainMove)
            this.chain.get(i).update(true);
          else
            this.chain.get(i).update(false);
        }
      }
    }
    

    
    //loop through chain looking for movement
    if(this.checkMovement() && this.chain != null){
      if(this.chainMove){
        for(int i = 0; i < this.chain.size(); i++)
          this.chain.get(i).updateGridCell(i > 0 ? true : false);
      }  
        
      this.chainMove = false;
      //this.dirInitial = "";
      this.chain = null;
    }
  }
  
  public void printGrid(){
    for(int i = 0; i < this.grid.length; i++){
        for(int j = 0; j < this.grid[i].length; j++){
          if(this.grid[j][i] != null)
            System.out.print(this.grid[j][i].getClass().getSimpleName() + " ");
          else
            System.out.print(this.grid[j][i] + " ");
        }
        System.out.println();
      }
      System.out.println();
  }
  
  public String letterToDir(String letter){
    switch(letter){
      case "w":
        return "up";
      case "s":
        return "down";
      case "d": 
        return "right";
      case "a":
        return "left";
    }
    return "";
  }
  
  public boolean canChainMove(List<gridObject> chain){
    gridObject last = chain.get(chain.size()-1); 
    if(chain.size() == 1){
      if(this.onEdge(last.currentCell, this.dirInitial)){
        return false;
      }
      return true;
    }
    String direction = this.getDir(chain.get(chain.size()-2), last);
    if(last.getClass().getSimpleName().equals("Person") && surrounded(last.currentCell, direction)){
      return false;
    }
    if(this.stationary(last, direction)){
      return false;
    }
    else if(this.onEdge(last.currentCell, direction))
      return false;
    return true;
  }
  
  public String getDir(gridObject before, gridObject after){
    if(before.currentCell[0]==after.currentCell[0]-1)
      return "right";
    if(before.currentCell[0] == after.currentCell[0]+1)
      return "left";
    if(before.currentCell[1] == after.currentCell[1]-1)
      return "down";
    if(before.currentCell[1] == after.currentCell[1]+1)
      return "up";
    return "";
  }
  
  public void assignDir(String direction, boolean canMove){
    for(int i = this.chain.size()-1; i >= 1; i--){
      String dir = this.getDir(this.chain.get(i-1), this.chain.get(i));
      this.chain.get(i).direction = dir;
      if(!this.chain.get(i).getClass().getSimpleName().equals("Wall"))
        this.chain.get(i).moving = true;
      if(canMove){
        this.chain.get(i).updateCell();
      }
    }
    this.chain.get(0).direction = direction;
    player.moving = true;
    if(canMove)
      player.updateCell();
  }
  
  public boolean checkMovement(){
    boolean toReturn = true;
    if(this.chain == null)
      return true;
    for(int i = 0; i < this.chain.size(); i++){
      if(this.chain.get(i).moving)
        toReturn = false;
    }
    return toReturn;
  }
  
  public void renderGrid(){
    for(int i = 0; i < this.grid.length; i++){
      for(int j = 0; j < this.grid[i].length; j++){
        if(this.grid[i][j] != null)
          this.grid[i][j].render();
      }
    }
  }
  
  public List<gridObject> createChain(int[] initialCell, String direction){
    List<gridObject> objs = new ArrayList<gridObject>();
    objs.add(this.player);
    int[] intDir = intFromDir(direction);
    boolean chainDiscovering = true;
    int steps = 1;
    while(chainDiscovering && !this.offMap(new int[] {initialCell[0]+(intDir[0]*steps), initialCell[1]+(intDir[1]*steps)}, direction)){
      gridObject currentObj = this.grid[initialCell[0]+(intDir[0]*steps)][initialCell[1]+(intDir[1]*steps)];
      if(currentObj == null){
        return objs;
      }
      else if(stationary(currentObj, direction)){
        objs.add(currentObj);
        return objs;
      }
      else {
        objs.add(currentObj);
      }
      steps++;
    }
    gridObject last = objs.get(objs.size()-1);
    if(last.getClass().getSimpleName().equals("Person") && this.onEdge(last.currentCell, direction) && !this.surrounded(last.currentCell, direction)){
      String newDir = "";
      if(direction.equals("up") || direction.equals("down"))
        newDir = last.currentCell[0] > this.exit.currentCell[0] ? "right" : "left";
      else if(direction.equals("left") || direction.equals("right"))
        newDir = last.currentCell[1] > this.exit.currentCell[1] ? "down" : "up";
      objs.addAll(this.createChain(last.currentCell, newDir));
    }
    return objs;
  }
  
  public boolean stationary(gridObject currentObj, String direction){
    if ((currentObj.stationary[0] && direction == "down") ||
              (currentObj.stationary[1] && direction == "up")   ||
              (currentObj.stationary[2] && direction == "right")||
              (currentObj.stationary[3] && direction == "left") )
      return true;
    return false;
  }
  
  public int[] intFromDir(String direction){
    int[] intDir = new int[2];
    switch(direction){
      case "up":
        intDir[0] = 0;
        intDir[1] = -1;
        break;
      case "down":
        intDir[0] = 0;
        intDir[1] = 1;
        break;
      case "left":
        intDir[0] = -1;
        intDir[1] = 0;
        break;
      case "right":
        intDir[0] = 1;
        intDir[1] = 0;
        break;
    }
    return intDir;
  }
  
  public boolean surrounded(int[] currentCell, String direction){
    if(direction.equals("up") || direction.equals("down")){
      if(this.grid[currentCell[0]-1][currentCell[1]] != null && this.grid[currentCell[0]+1][currentCell[1]] != null)
       return true;
    }
    if(direction.equals("left") || direction.equals("right")){
      if(this.grid[currentCell[0]][currentCell[1]-1] != null && this.grid[currentCell[0]][currentCell[1]+1] != null)
        return true;
    }
    return false;
  }
  
  public boolean onEdge(int[] pos, String direction){
    if(direction == "up" && pos[1] == 0)
      return true;
    else if(direction == "down" && pos[1] == this.gridSize[1]-1)
      return true;
    else if(direction == "left" && pos[0] == 0)
      return true;
    else if(direction == "right" && pos[0] == this.gridSize[0]-1)
      return true;
    return false;
  }
  
  public boolean offMap(int[] pos, String direction){
    if(direction == "up" && pos[1] == -1)
      return true;
    else if(direction == "down" && pos[1] == this.gridSize[1])
      return true;
    else if(direction == "left" && pos[0] == -1)
      return true;
    else if(direction == "right" && pos[0] == this.gridSize[0])
      return true;
    return false;
  }
  public abstract void setup();
  
  public abstract void draw();
  
  public abstract void keyPressed(String key);
}
