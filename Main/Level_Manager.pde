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
  
  public static Scene getScene(int index){
    return scenes[index];
  }
  
  public static void setCurrentScene(int index){
    currentScene = SceneManager.getScene(index);
    currentScene.setup();
  }
  
  public static void setup(){
    currentScene.setup();
  }
  
  public static void draw(){
    currentScene.draw();
  }
  
  public static void keyPressed(String key){
    currentScene.keyPressed(key);
  }
  
  public static void setGridSpace(int[] pos, Object obj){
    currentScene.grid[pos[0]][pos[1]] = obj;
  }
  
}

//The scene class is abstract as every level or menu will be using it and thus it is easier to have an object scene instead of multiple different classes. Basically, it allows me to have an array of scenes as well as a currentscene variable without hassle.
abstract class Scene {
  //These grid variables are going to be in every scene. Also, im not defining the size of the grid because it can change from level to level to increase difficulty.
  public int[] gridSize = new int[2];
  public Object[][] grid;
  
  public void createGrid(){
    grid = new Object[gridSize[0]][gridSize[1]];
    for(int i = 0; i < grid.length; i++){
      for(int j = 0; j < grid[i].length; j++){
        this.grid[i][j] = null;
      }
    }
  }
  
  public abstract void setup();
  
  public abstract void draw();
  
  public abstract void keyPressed(String key);
}
