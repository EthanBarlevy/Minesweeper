import processing.sound.*;

Board board;
StatBar bar;
SoundFile boom;

public void setup() {
  size(599, 700);
  boom = new SoundFile(this, "boom.mp3");
  board = new Board(10, 10, 15);
  board.addMines();
  board.minesNear();
  bar = new StatBar(board.getMines());
}

public void draw() {
  background(255);
  board.run();
  bar.show();
}

// check if user is pressing on any spesific tile
void mousePressed() {
  for (int i = 0; i < board.getTiles().length; i++) {
    for (int j = 0; j < board.getTiles()[i].length; j++) {
      if (mouseX >= board.getTiles()[i][j].getPosition().x &&
        mouseX <= board.getTiles()[i][j].getPosition().x + 60 &&
        mouseY >= board.getTiles()[i][j].getPosition().y &&
        mouseY <= board.getTiles()[i][j].getPosition().y + 60) {
        if (mouseButton == LEFT && !board.getGameOver()) {
          board.getTiles()[i][j].open();
          board.openNearby();
        } else if (mouseButton == RIGHT && !board.getGameOver()) {
          if(!(board.getTiles()[i][j].getOpen())){
          bar.flag(board.getTiles()[i][j].getFlagged());
          }
          board.getTiles()[i][j].flag();
        }
      }
    }
  }
}

// after the games is over reset the game by pressing the space bar
public void keyPressed(){
  if(key == 32 && board.getGameOver()){
    setup();
  }
}
