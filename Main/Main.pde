public static final int[] windowSize = new int[] {750, 750}; //The size of the game window
public static final int frames = 60;

//Settings is used to set the size instead of setup because we are using predefined variables. It is simply a property of Processing. When we are using variables in the function size it cant go in setup
void settings(){
  size(windowSize[0], windowSize[1]);
}

void setup(){
  noStroke();
  frameRate(frames);//Sets the frame rate
  
  SceneManager.addScene(new Test()); //adds the test scene to the scenemanager
  SceneManager.setCurrentScene(0); //Sets the current scene to the test scene
}

void draw(){
  background(0); //Resets the background to black every frame

  SceneManager.draw(); //Calls the draw function of the scenemanager which will call the draw function of the current scene
  
} 

void keyPressed(){
  SceneManager.keyPressed(key+""); //Sends any key press to the scenemanager
}
