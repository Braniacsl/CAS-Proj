Player player = new Player(new PVector(250, 250)); // Main loop which will handle level picker. Right now main is the whole temp scene to test basic concepts

void setup(){
  size(500, 500);
  noStroke();
}

void draw(){
  background(0);
  
  player.update();
  
  player.render();
  
} 

void keyPressed(){
  this.player.addKey(key+"");
}
  
