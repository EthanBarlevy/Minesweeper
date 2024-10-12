class Board {  //<>//
  private Tile tiles[][];
  private int numMines;
  private boolean gameOver;

  // count how many mines are next to it without getting an array out of bounds error
  // should all of these be replaced with a seprate method? probably. but too bad
  public void minesNear() {
    int count = 0;
    for (int i = 0; i < tiles.length; i++) {
      for (int j = 0; j < tiles[i].length; j++) {
        if (i - 1 >= 0) { // check all of the row above the current tile
          if (j - 1 >= 0) {
            if (tiles[i-1][j-1].getMine()) { // up 1 left 1
              count++;
            }
          }
          if (tiles [i-1][j].getMine()) { // up 1
            count++;
          }
          if (j + 1 < tiles.length) { // up 1 right 1
            if (tiles[i-1][j+1].getMine()) {
              count++;
            }
          }
        }
        if (i + 1 < tiles.length) { // check all of the row below
          if (j - 1 >= 0) {
            if (tiles[i+1][j-1].getMine()) { // down 1 left 1
              count++;
            }
          }
          if (tiles [i+1][j].getMine()) { // down 1
            count++;
          }
          if (j + 1 < tiles.length) { // down 1 right 1
            if (tiles[i+1][j+1].getMine()) {
              count++;
            }
          }
        }
        if (j - 1 >= 0) {
          if (tiles[i][j-1].getMine()) { // left 1
            count++;
          }
        }
        if (tiles [i][j].getMine()) { // same position (to make sure that mines arent opened when openZero() is called)
          count++;
        }
        if (j + 1 < tiles.length) { // right 1
          if (tiles[i][j+1].getMine()) {
            count++;
          }
        }
        tiles[i][j].setMinesNear(count);
        count = 0; // reset the count for each tile
      }
    }
  }

  public void addMines() {
    // array of positions the size of how many mines are wanted
    PVector[] positions = new PVector[numMines];

    // fill the PVectors with random x and y positions
    for (int i = 0; i < positions.length; i++) {
      positions[i] = new PVector((int)(random(0, tiles.length)), (int)(random(0, tiles.length)));
    }

    // make sure that none of the PVectors are the same
    for (int i = 0; i < positions.length; i++) {
      for (int j = 0; j < positions.length; j++) {
        if (i != j) {
          if (positions[j].x == positions[i].x && positions[j].y == positions[i].y) {
            positions[i].x = (int)(random(0, tiles.length));
            positions[i].y = (int)(random(0, tiles.length));
            i = 0;
            j = 0;
          }
        }
      }
    }

    // set the tiles with the same x and y as the PVectors to be mines
    for (int i = 0; i < tiles.length; i++) {
      for (int j = 0; j < tiles[i].length; j++) {
        for (int k = 0; k < positions.length; k++) {
          if (i == positions[k].y && j == positions[k].x) {
            tiles[j][i].makeMine();
          }
        }
      }
    }
  }

  // if the current tile has no mines nearby it
  // open all of the tiles around it
  // repeat on all tiles that were just opened
  public void openNearby() {
    for (int t = 0; t < 10; t++) { // this one is just to make sure that it opens all of the tiles that it should
      for (int i = 0; i < tiles.length; i++) {
        for (int j = 0; j < tiles[i].length; j++) {
          if (tiles[i][j].getMinesNear() == 0 && tiles[i][j].getOpen()) {
            if (i - 1 >= 0) { // check all of the row above the current tile
              if (j - 1 >= 0) {
                tiles[i-1][j-1].open(); // up 1 left 1
              }
              tiles [i-1][j].open(); // up 1
              if (j + 1 < tiles.length) {
                tiles[i-1][j+1].open(); // up 1 right 1
              }
            }

            if (i + 1 < tiles.length) { // check all of the row below
              if (j - 1 >= 0) {
                tiles[i+1][j-1].open();  // down 1 left 1
              }
              tiles [i+1][j].open(); // down 1
              if (j + 1 < tiles.length) { // down 1 right 1
                tiles[i+1][j+1].open();
              }
            }

            if (j - 1 >= 0) {
              tiles[i][j-1].open(); // left 1
            }
            if (j + 1 < tiles.length) { // right 1
              tiles[i][j+1].open();
            }
          }
        }
      }
    }
  }
  
  
  // show all of the tiles and check to see if user opens a mine
  public void run() {
    for (int i = 0; i < tiles.length; i++) {
      for (int j = 0; j < tiles[i].length; j++) {
        tiles[i][j].show();

        if (tiles[i][j].dead() && !gameOver) {
          boom.play();
          gameOver = true;
        }
      }
    }
    gameOver();
    // i know that this is just drawing you win over you loose but
    // im not fixing it
    if (win()) {
      rectMode(CENTER);
      fill(91);
      stroke(0);
      strokeWeight(5);
      rect(300, 300, 400, 140);
      textSize(80);
      fill(0);
      textAlign(CENTER);
      text("You Win!!", 300, 300);
      textSize(40);
      text("Press space to retry", 300, 350);
      gameOver = true;
    }
  }

  // I know that I should not do this in this class
  // but i dont care
  private void gameOver() {
    if (gameOver) {
      rectMode(CENTER);
      fill(91);
      stroke(0);
      strokeWeight(5);
      rect(300, 300, 400, 140);
      textSize(80);
      fill(0);
      textAlign(CENTER);
      text("You Loose!", 300, 300);
      textSize(40);
      text("Press space to retry", 300, 350);
      for (int i = 0; i < tiles.length; i++) {
        for (int j = 0; j < tiles[i].length; j++) {
          if(tiles[i][j].getMine()){
            tiles[i][j].open();
          }
        }
      }
    }
  }

  // if all of the tiles are open minus the number of mines
  // then the user has won
  private boolean win() {
    int total = (tiles.length * tiles[0].length) - numMines;
    int counter = 0;
    for (int i = 0; i < tiles.length; i++) {
      for (int j = 0; j < tiles[i].length; j++) {
        if (tiles[i][j].getOpen() && !tiles[i][j].getMine()) {
          counter++;
        }
      }
    }
    if (counter == total) {
      return true;
    }
    return false;
  }
  
  // CONSTRUCTOR
  
  public Board(int x, int y, int numMines) {
    tiles = new Tile[x][y];
    this.numMines = numMines;

    for (int i = 0; i < y; i++) {
      for (int j = 0; j < x; j++) {
        tiles[i][j] = new Tile(j, i);
      }
    }
  }
  
  // GETTERS AND SETTERS
  
  // this is only needed for mousePressed()
  public Tile[][] getTiles() {
    return tiles;
  }

  public int getMines() {
    return numMines;
  }
  
  public boolean getGameOver() {
    return gameOver;
  }
  
}
