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
  
  //Sets a position on the grid in the currentScene to an object
  public static void setGridSpace(int[] pos, gridObject obj){
    currentScene.grid[pos[0]][pos[1]] = obj;
  }
  
  //Returns the grid of the currentScene
  public static gridObject[][] getGrid(){
    return currentScene.grid;
  }
  
}

//The scene class is abstract as every level or menu will be using it and thus it is easier to have an object scene instead of multiple different classes. Basically, it allows me to have an array of scenes as well as a currentscene variable without hassle.
abstract class Scene {
  //These grid variables are going to be in every scene. Also, im not defining the size of the grid because it can change from level to level to increase difficulty. The object list contains all the objects in the currentScene as calculations are done based on
  //object not the grid. The grid is mainly here for saving the gameState as well as loading a level easily, however some minor calculations take the grid state into account.
  public List<gridObject> Objects = new ArrayList<gridObject>();
  public int[] gridSize = new int[2];
  public gridObject[][] grid;
  
  public Player player;
  
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
  
  //This updates the grid based on the objects in the list. Each time that movement ceases the grid is updated by iterating through the objects list, checking the objects' position and adding them to the grid.
  public void updateGrid() {
    //This sets the whole grid to null to wipe it before adding objects to the grid.
    this.nullifyGrid();
    
    //This loop runs through the objects list and sets the grid spaces to those objects.
    for(int i = 0; i < this.Objects.size(); i++){
      gridObject obj = this.Objects.get(i);
      this.grid[obj.currentCell[0]][obj.currentCell[1]] = obj;
    }
  }
  
  //This renders the grid
  public void drawGrid(){
    boolean tempMove = false; //tempMove is here to check if there is any object moving and if not updates the grid. This was added because after update some objects would not be in a cell or would be in a cell and update grid wouldnt see it and thus would simply
    //delete the object
     for(int i = 0; i < this.gridSize[0]; i++){
      for(int j = 0; j < this.gridSize[1]; j++){
        if(this.grid[i][j] != null){
          this.grid[i][j].update(); //Updates each object
          this.grid[i][j].render(); //Renders each object
          
          if(this.grid[i][j].moving){//Checks if object is moving
            tempMove = true; 
          }
        }
      }
    } 
    if(!tempMove)
      this.updateGrid(); //updates grid once there is no movement
  }
  
  public abstract void setup();
  
  public abstract void draw();
  
  public abstract void keyPressed(String key);
}
