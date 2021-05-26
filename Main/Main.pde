public static final int[] windowSize = new int[] {750, 750};

void settings(){
  size(windowSize[0], windowSize[1]);
}

void setup(){
  noStroke();
  frameRate(60);
  SceneManager.addScene(new Test(0));
  SceneManager.setCurrentScene(0);
}

void draw(){
  background(0);

  SceneManager.draw();
  
} 

void keyPressed(){
  SceneManager.keyPressed(key+"");
}
  
