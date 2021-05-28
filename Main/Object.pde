//This class is for rendering the grid since there has to be one object when doing so

abstract class gridObject {
  public int[] currentCell;
  
  public boolean moving = false;
  
  public abstract void update();
  public abstract void render();
}
